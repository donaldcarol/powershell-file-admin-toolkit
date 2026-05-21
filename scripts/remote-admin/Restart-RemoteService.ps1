<#
.SYNOPSIS
Restart a Windows service on one or more remote computers.
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory = $true)]
    [string[]]$ComputerName,

    [Parameter(Mandatory = $true)]
    [string]$ServiceName
)

foreach ($computer in $ComputerName) {
    try {
        Write-Host "Processing $computer..."

        if ($PSCmdlet.ShouldProcess($computer, "Restart service $ServiceName")) {
            Invoke-Command -ComputerName $computer -ScriptBlock {
                param($ServiceName)

                Restart-Service -Name $ServiceName -ErrorAction Stop

                Get-Service -Name $ServiceName |
                Select-Object Name, Status, MachineName
            } -ArgumentList $ServiceName
        }
    }
    catch {
        [PSCustomObject]@{
            ComputerName = $computer
            ServiceName  = $ServiceName
            Status       = "Error"
            ErrorMessage  = $_.Exception.Message
        }
    }
}