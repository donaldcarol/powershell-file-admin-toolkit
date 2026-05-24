Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 Name, CPU
