$Async = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
$Type = Add-Type -MemberDefinition $Async -name Win32ShowWindowAsync -namespace Win32Functions -PassThru
$hwnd = (Get-Process -PID $pid).MainWindowHandle
if ($hwnd -ne [System.IntPtr]::Zero) {
  $Type::ShowWindowAsync($hwnd, 0)
}
else {
  $Host.UI.RawUI.WindowTitle = 'hideme'
  $Proc = (Get-Process | Where-Object { $_.MainWindowTitle -eq 'hideme' })
  $hwnd = $Proc.MainWindowHandle
  $Type::ShowWindowAsync($hwnd, 0)
}


$scriptPath = $null;
if (!$scriptName) {
  $scriptPath = "script.exe"
}
else {
  $scriptPath = $scriptName
}
Write-host $scriptPath
$removableDrives = Get-WmiObject Win32_LogicalDisk | Where-Object { $_.DriveType -eq 2 }
$count = $removableDrives.count
$i = 30


While ($true) {
  Clear-host
  Write-Host "Connect a Device.. ($i)" -ForegroundColor Yellow
  $removableDrives = Get-WmiObject Win32_LogicalDisk | Where-Object { $_.DriveType -eq 2 }
  Start-sleep 1
  if ($count -gt $removableDrives.count) {
    $count = $removableDrives.count
    $i--
    continue
  }
  if ($count -lt $removableDrives.count) {
    Write-Host "USB Drive Connected!" -ForegroundColor Green
    break
  }
  $i--
  if ($i -eq 0 ) {
    Write-Host "Timeout! Exiting" -ForegroundColor Red
    sleep 1
    exit
  }
}

$drive = $removableDrives | Sort-Object -Descending | Select-Object -First 1
$driveLetter = $drive.DeviceID
Write-Host "Running: $driveLetter/$scriptPath"


Start-Process -FilePath "$($driveLetter)\$scriptPath"
exit 