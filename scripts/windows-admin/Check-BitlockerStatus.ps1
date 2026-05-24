param($ComputerName)

Invoke-Command -ComputerName $ComputerName -ScriptBlock {
    Get-Process | Sort CPU -Descending | Select -First 5
}
