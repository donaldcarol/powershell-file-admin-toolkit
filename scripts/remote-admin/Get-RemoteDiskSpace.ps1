<#
.SYNOPSIS
Get disk usage information from remote computers.

.DESCRIPTION
Connects to one or more remote computers and retrieves
disk information for a specified drive letter.

.EXAMPLE
.\Get-RemoteDiskSpace.ps1 `
-ComputerName server1,server2 `
-DriveLetter C

#>

[CmdletBinding()]
param(

    [Parameter(Mandatory)]
    [string[]]$ComputerName,

    [Parameter(Mandatory)]
    [string]$DriveLetter,

    [string]$ExportCsv = ".\reports\disk-report.csv"

)

$results = foreach ($computer in $ComputerName) {

    try {

        Write-Host "Checking $computer..."

        Invoke-Command `
        -ComputerName $computer `
        -ScriptBlock {

            Get-CimInstance Win32_LogicalDisk |
            Where-Object {
                $_.DeviceID -eq "$using:DriveLetter:"
            } |
            Select-Object `
            @{Name="ComputerName";Expression={$env:COMPUTERNAME}},
            DeviceID,

            @{Name="SizeGB";Expression={
                [math]::Round($_.Size/1GB,2)
            }},

            @{Name="FreeGB";Expression={
                [math]::Round($_.FreeSpace/1GB,2)
            }},

            @{Name="FreePercent";Expression={
                [math]::Round(
                    ($_.FreeSpace/$_.Size)*100
                ,2)
            }}

        }

    }
    catch {

        [PSCustomObject]@{

            ComputerName=$computer
            DeviceID="N/A"
            SizeGB="N/A"
            FreeGB="N/A"
            FreePercent="N/A"
            Error=$_.Exception.Message

        }

    }

}

$results |
Export-Csv $ExportCsv -NoTypeInformation

Write-Host "Report saved to $ExportCsv"

$results
