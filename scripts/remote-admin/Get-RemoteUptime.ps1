<#
.SYNOPSIS
Get uptime information from one or more remote computers.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string[]]$ComputerName,

    [string]$ExportCsv = ".\reports\uptime-report.csv"
)

$results = foreach ($computer in $ComputerName) {
    try {
        Write-Host "Checking uptime on $computer..."

        Invoke-Command -ComputerName $computer -ScriptBlock {
            $os = Get-CimInstance Win32_OperatingSystem
            $lastBoot = $os.LastBootUpTime
            $uptime = (Get-Date) - $lastBoot

            [PSCustomObject]@{
                ComputerName   = $env:COMPUTERNAME
                LastBootUpTime = $lastBoot
                UptimeDays     = [math]::Round($uptime.TotalDays, 2)
                UptimeHours    = [math]::Round($uptime.TotalHours, 2)
                OSVersion      = $os.Caption
            }
        }
    }
    catch {
        [PSCustomObject]@{
            ComputerName   = $computer
            LastBootUpTime = $null
            UptimeDays     = $null
            UptimeHours    = $null
            OSVersion      = $null
            ErrorMessage   = $_.Exception.Message
        }
    }
}

$results | Export-Csv -Path $ExportCsv -NoTypeInformation
Write-Host "Report saved to $ExportCsv"

$results
