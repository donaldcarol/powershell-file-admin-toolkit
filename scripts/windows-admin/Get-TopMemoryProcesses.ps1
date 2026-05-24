Get-Process |

Sort-Object WorkingSet -Descending |

Select-Object `
-First 10 `
Name,
Id,

@{
Name="MemoryGB"
Expression={
[math]::Round(
$_.WorkingSet/1GB
,2)
}
}
