<#
.SYNOPSIS
Check service status on one or more remote computers.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string[]]$ComputerName,

    [Parameter(Mandatory)]
    [string]$ServiceName,

    [string]$ExportCsv = ".\reports\service-status-report.csv"
)

$results = foreach ($computer in $ComputerName) {
    try {
        Write-Host "Checking service $ServiceName on $computer..."

        Invoke-Command -ComputerName $computer -ScriptBlock {
            Get-Service -Name $using:ServiceName -ErrorAction Stop |
            Select-Object `
                @{Name="ComputerName";Expression={$env:COMPUTERNAME}},
                Name,
                DisplayName,
                Status,
                StartType
        }
    }
    catch {
        [PSCustomObject]@{
            ComputerName = $computer
            Name         = $ServiceName
            DisplayName  = $null
            Status       = "Error"
            StartType    = $null
            ErrorMessage = $_.Exception.Message
        }
    }
}

$results | Export-Csv -Path $ExportCsv -NoTypeInformation
Write-Host "Report saved to $ExportCsv"

$results
