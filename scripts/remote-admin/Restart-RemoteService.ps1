param($ComputerName, $ServiceName)

Invoke-Command -ComputerName $ComputerName -ScriptBlock {
    param($ServiceName)
    Restart-Service $ServiceName
} -ArgumentList $ServiceName
