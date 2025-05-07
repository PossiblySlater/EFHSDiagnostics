# EFHSDiagnostics

EFHSDiagnostics is a diagnostic tool designed for the EFHS Computer Service Technician Class. This script provides a comprehensive overview of the computer's hardware and system status, all in one place. It is a useful utility for quickly assessing the health and performance of a computer.

## Features

- **CPU Diagnostics**: Displays CPU name, core count, logical processors, clock speed, and load status.
- **Operating System Information**: Shows the OS name and version.
- **RAM Details**: Lists installed RAM capacity, speed, type, and manufacturer for each module.
- **Storage Information**: Provides details about internal drives, including size, type, and health status.
- **GPU Information**: Displays details about installed graphics cards, including VRAM and status.

## Prerequisites

Before running the script, ensure the following:

1. **PowerShell Execution Policy**: The script requires an unrestricted execution policy. If the script fails to run, open a new PowerShell prompt and execute the following command:
   ```powershell
   Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted -Force
   ```
2. **Administrator Privileges**: Some commands may require administrative privileges. Run PowerShell as an administrator if necessary.

## How to Use
To use the EFHS Diagnostics tool, either:
1. Right click `EFHSDiagnostic.ps1` and click *Run in PowerShell.*

2. Open a new PowerShell window, navigate to the EFHSDiagnostics directory, and run `./EFHSDiagnostic.ps1`.

## Troubleshooting
+*Script Fails to Run* Ensure the execution policy is set to unrestricted as described in the prerequisites.

## License
This project is licensed under the GNU General Public License 3.0. See the (LICENSE) file for details.

Created by Slater Feistner