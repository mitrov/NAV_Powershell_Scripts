# This script stops all running NAV client processes
# Works also on terminal servers because of the UserName filtering

$Process = Get-Process | Where-Object {$_.ProcessName -eq "fin" -or `
                                       $_.ProcessName -eq "finsql" -or `
                                       $_.ProcessName -like "*Nav.Client*"}

if ($Process.Count -eq 0)
    {exit}

$Win32Processes =  Get-WmiObject win32_process | Select-Object ProcessId, Name,@{n='Owner';e={$_.GetOwner().User}} `
                                               | Where-Object {$_.Owner -eq ([Environment]::UserName)} `
                                               | Where-Object {$_.Name -like "finsql*exe" -or `
                                                               $_.Name -like "fin*exe" -or ` 
                                                               $_.Name -like "*Nav.Client*exe"} `
                                               | ForEach-Object {$Process = Get-Process -Id $_.ProcessId 
                                                                 $Process.CloseMainWindow() | Out-Null}
