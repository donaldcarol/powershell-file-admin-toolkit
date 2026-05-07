![PowerShell](https://img.shields.io/badge/PowerShell-7-blue)
![Platform](https://img.shields.io/badge/platform-Windows-lightgrey)

# PowerShell File Admin Toolkit

A collection of practical PowerShell scripts for file management and system administration tasks.

## 📂 Project Structure

scripts/
Find-DuplicateFiles.ps1
Remove-OldLogFiles.ps1
Rename-FilesByPattern.ps1


## 🚀 Features

- Find duplicate files (by name or hash)
- Safe removal with `-WhatIf`
- Log export to CSV
- Batch file renaming
- File cleanup automation

## 🛠️ Usage

### Find duplicate files

```powershell
.\Find-DuplicateFiles.ps1 -Path "G:\lab" -Mode Hash -WhatIf

.\Remove-OldLogFiles.ps1 -Path "C:\Temp" -Days 30 -WhatIf

```


⚠️ Safety

All scripts support -WhatIf to simulate actions before execution.

📊 Example Output

(you can add screenshots here later)

👨‍💻 Author

Donald Carol
