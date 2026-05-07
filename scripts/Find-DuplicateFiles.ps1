function Find-DuplicateFiles {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path,

        [ValidateSet("Name","Hash")]
        [string]$Mode = "Name",

        [ValidateSet("Newest","Oldest")]
        [string]$Keep = "Newest",

        [switch]$WhatIf
    )

    Write-Output "Scanning path: $Path"
    Write-Output "Mode: $Mode | Keep: $Keep"

    if ($Mode -eq "Name") {
        $items = Get-ChildItem -Path $Path -File -Recurse
        $groups = $items | Group-Object Name
    }
    else {
        $items = Get-ChildItem -Path $Path -File -Recurse | Get-FileHash
        $groups = $items | Group-Object Hash
    }

    $duplicates = $groups | Where-Object { $_.Count -gt 1 }

    $toDelete = foreach ($group in $duplicates) {

        if ($Mode -eq "Hash") {
            $files = $group.Group | Get-Item
        } else {
            $files = $group.Group
        }

        if ($Keep -eq "Newest") {
            $files | Sort-Object LastWriteTime -Descending | Select-Object -Skip 1
        }
        else {
            $files | Sort-Object LastWriteTime | Select-Object -Skip 1
        }
    }

    # export raport
    $toDelete | Select-Object FullName, Length, LastWriteTime |
    Export-Csv "duplicates_to_delete.csv" -NoTypeInformation

    Write-Output "Found $($toDelete.Count) files to delete"

    # ștergere (sau simulare)
    if ($WhatIf) {
        $toDelete | Remove-Item -WhatIf
    }
    else {
        $toDelete | Remove-Item
    }
}