![PowerShell](https://img.shields.io/badge/PowerShell-7-blue)
![Platform](https://img.shields.io/badge/platform-Windows-lightgrey)
![Status](https://img.shields.io/badge/status-active-success)

# PowerShell File & Remote Admin Toolkit

A practical PowerShell toolkit for Windows administration, file operations, and remote server management.

## Features

- File cleanup and reporting
- Duplicate file detection
- Batch rename and extension changes
- File counting with exclusion rules
- Remote process checks
- Remote service checks/restarts
- Disk space and uptime reports
- CSV reporting and logging
- Safe execution with `-WhatIf`

## 📂 Project Structure

```
powershell-file-admin-toolkit/
│
├── README.md
├── servers/
│   └── servers.txt
├── reports/
├── logs/
│
├── scripts/
│   ├── file-admin/
│   │   ├── Find-DuplicateFiles.ps1
│   │   ├── Rename-FilesByPattern.ps1
│   │   ├── Change-FileExtension.ps1
│   │   ├── Move-FilesByRule.ps1
│   │   └── Count-FilesExcludingFolders.ps1
│   │
│   └── remote-admin/
│       ├── Test-ServerConnectivity.ps1
│       ├── Get-RemoteProcessStatus.ps1
│       ├── Get-RemoteServiceStatus.ps1
│       ├── Restart-RemoteService.ps1
│       ├── Get-RemoteDiskSpace.ps1
│       ├── Get-RemoteUptime.ps1
│       └── Invoke-RemoteHealthCheck.ps1

```
---

## 🛠️ Requirements

- PowerShell 7+
- Windows / Linux (cross-platform compatible where possible)

---

## 📦 Scripts Overview

### 🔍 Find-DuplicateFiles.ps1

Find duplicate files using multiple strategies:
- `Name` → same filename
- `Size` → same file size
- `Hash` → identical content (recommended)

#### Example

```powershell
.\scripts\Find-DuplicateFiles.ps1 -Path "G:\lab" -Mode Hash

```

Safe mode (simulation)
```
.\scripts\Find-DuplicateFiles.ps1 -Path "G:\lab" -Mode Hash -Delete -WhatIf
```

✏️ Rename-FilesByPattern.ps1

Replace text in file names using regex.

```
.\scripts\Rename-FilesByPattern.ps1 -Path "G:\lab" -Find "Watch\s*" -ReplaceWith "" -Recurse -WhatIf
```

🔄 Change-FileExtension.ps1

Change file extensions in bulk.

```
.\scripts\Change-FileExtension.ps1 -Path "G:\lab" -OldExtension "log" -NewExtension "txt" -Recurse -WhatIf
```
---
⚠️ Safety

All scripts support safe execution:

-WhatIf → simulate changes  
-Confirm → interactive confirmation  
Logging enabled via Start-Transcript  

📊 Example Output

Scripts can generate CSV reports:
```
reports/duplicates-report.csv
```
---
🧠 Design Principles
- Uses PowerShell advanced functions (CmdletBinding)
- Supports pipeline and automation scenarios
- Built with safety-first approach
- Designed for real-world system administration

---
👨‍💻 Author

Donald Carol   
Cloud / Infrastructure Engineer

---

📌 Notes

This project is part of a hands-on PowerShell learning and automation practice, focused on real-world scenarios.
