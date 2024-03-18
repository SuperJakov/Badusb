$scriptPath = "script.exe"
$removableDrives = Get-WmiObject Win32_LogicalDisk | Where-Object { $_.DriveType -eq 2 }
$count = $removableDrives.count
$i = 30
While ($true) {
  Clear-host
  Write-Host "Connect a Device.. ($i)" -ForegroundColor Yellow
  $removableDrives = Get-WmiObject Win32_LogicalDisk | Where-Object { $_.DriveType -eq 2 }
  sleep 1
  if (!($count -eq $removableDrives.count)) {
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