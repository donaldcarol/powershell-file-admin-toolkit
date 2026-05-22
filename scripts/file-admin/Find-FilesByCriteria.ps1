<#
.SYNOPSIS
Find files based on name patterns, extensions, and minimum size.

.DESCRIPTION
Searches recursively for files matching one or more criteria:
- Name contains text
- File extension
- Minimum file size

Exports results to CSV.

.EXAMPLE
.\Find-FilesByCriteria.ps1 `
-Path "M:\films" `
-NameContains "watch" `
-Extension "mkv","mp4" `
-MinSizeMB 100

#>

[CmdletBinding()]
param(

    [Parameter(Mandatory)]
    [ValidateScript({
        if(Test-Path $_ -PathType Container){
            $true
        }
        else{
            throw "Folder not found"
        }
    })]
    [string]$Path,

    [string]$NameContains,

    [string[]]$Extension,

    [int]$MinSizeMB=0,

    [switch]$IncludeHidden,

    [string]$ExportCsv=".\\reports\\file-search-report.csv"

)

Write-Host "Scanning: $Path"

$files=Get-ChildItem `
-Path $Path `
-File `
-Recurse `
-Force:$IncludeHidden


# Filter by name
if($NameContains){

    $files=$files |
    Where-Object{
        $_.Name -like "*$NameContains*"
    }

}


# Filter by extension
if($Extension){

    $files=$files |
    Where-Object{

        $_.Extension.TrimStart('.') `
        -in $Extension

    }

}


# Filter by size
if($MinSizeMB){

    $files=$files |
    Where-Object{

        $_.Length -gt ($MinSizeMB*1MB)

    }

}


$results=$files |
Sort-Object Length -Descending |
Select-Object `

Name,

Extension,

@{
Name="SizeMB"
Expression={
    [math]::Round(
        $_.Length/1MB
    ,2)
}
},

LastWriteTime,

FullName


$results |
Export-Csv `
-Path $ExportCsv `
-NoTypeInformation


Write-Host "Found: $($results.Count) files"

$results
