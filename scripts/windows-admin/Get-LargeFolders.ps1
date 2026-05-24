param(
[string]$Path="C:\"
)

Get-ChildItem `
$Path `
-Directory |

ForEach-Object {

[PSCustomObject]@{

Folder=$_.Name

SizeGB=[math]::Round(

(
Get-ChildItem `
$_.FullName `
-File `
-Recurse `
-ErrorAction SilentlyContinue |

Measure-Object Length -Sum
).Sum/1GB

,2)

}

} |

Sort-Object SizeGB -Descending
