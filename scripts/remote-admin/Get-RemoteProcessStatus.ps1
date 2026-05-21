<#
.SYNOPSIS
Check process status on multiple remote servers.

.DESCRIPTION
Reads server names from a text file and checks if a given process
is running on each remote computer.

Exports results to CSV.

.EXAMPLE
.\Get-RemoteProcessStatus.ps1 `
-ServerList .\servers\servers.txt `
-ProcessName "MsMpEng"
#>

[CmdletBinding()]
param(

    [Parameter(Mandatory)]
    [ValidateScript({
        if(Test-Path $_){$true}
        else{throw "Server list file not found"}
    })]
    [string]$ServerList,

    [string]$ProcessName="MsMpEng",

    [string]$ExportCsv=".\\reports\\process-report.csv"

)

$servers=Get-Content $ServerList

$results=foreach($server in $servers){

    try{

        Write-Host "Checking $server..."

        $process=Invoke-Command `
        -ComputerName $server `
        -ScriptBlock {

            Get-Process $using:ProcessName `
            -ErrorAction SilentlyContinue

        }

        [PSCustomObject]@{

            ComputerName=$server

            ProcessName=$ProcessName

            Status=if($process){
                "Running"
            }
            else{
                "Not Running"
            }

            ScanDate=Get-Date
        }

    }
    catch{

        [PSCustomObject]@{

            ComputerName=$server

            ProcessName=$ProcessName

            Status="Connection error"

            ScanDate=Get-Date
        }

    }
}

$results |
Export-Csv $ExportCsv -NoTypeInformation

Write-Host "Report saved to: $ExportCsv"