<#
.SYNOPSIS
Gets the top CPU-consuming processes from one or more remote computers.

.EXAMPLE
.\Get-RemoteTopCPU.ps1 -ComputerName server1,server2 -Top 5
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string[]]$ComputerName,

    [int]$Top = 5,

    [string]$ExportCsv = ".\reports\remote-top-cpu.csv"
)

$results = foreach ($computer in $ComputerName) {

    try {
        Write-Host "Checking $computer..."

        Invoke-Command -ComputerName $computer -ScriptBlock {
            param($Top)

            Get-Process |
            Sort-Object CPU -Descending |
            Select-Object -First $Top Name, Id, CPU, WorkingSet

        } -ArgumentList $Top |
        Select-Object @{
            Name = "ComputerName"
            Expression = { $computer }
        }, Name, Id, CPU, WorkingSet
    }
    catch {
        [PSCustomObject]@{
            ComputerName = $computer
            Name         = $null
            Id           = $null
            CPU          = $null
            WorkingSet   = $null
            Error        = $_.Exception.Message
        }
    }
}

$results | Export-Csv -Path $ExportCsv -NoTypeInformation

$results
