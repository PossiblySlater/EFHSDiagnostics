# EFHSDiagnostics

EFHSDiagnostics is a diagnostic tool designed for the EFHS Computer Service Technician Class. This script provides a comprehensive overview of the computer's hardware and system status, all in one place. It is a useful utility for quickly assessing the health and performance of a computer.

## Features
### Diagnostics
   - **CPU Diagnostics**: Displays CPU name, core count, logical processors, clock speed, and status.
   - **Operating System Information**: Shows the OS name, version, and system uptime.
   - **RAM Details**: Lists installed RAM capacity, speed, type, and manufacturer for each module.
   - **Storage Information**: Provides details about internal drives, including size, type, and health status.
   - **GPU Information**: Displays details about installed graphics cards, including VRAM and status.
   - **Network Diagnostics**: Displays active network adapters, IP addresses, MAC addresses, and tests internet connectivity.
   - **Sound Device Information**: Lists installed sound devices, their status, and plays a sound test.
   - **Battery Information**: Displays battery status, charge level, and estimated runtime (if applicable).

### Formatted Output
Choose between a table output:
   ```
   === Operating System ===
+------------------------------------------+--------------------------------------------------------------+
| Property                                 | Value                                                        |
+------------------------------------------+--------------------------------------------------------------+
| OS                                       | Microsoft Windows 11 Home                                    |
| Version                                  | 10.0.22621                                                   |
| Uptime                                   | 0 days, 13 hours, 0 minutes                                  |
+------------------------------------------+--------------------------------------------------------------+
   ```
Or a list output:
   ```
=== Operating System ===
OS         : Microsoft Windows 11 Home
Version    : 10.0.22621
Uptime     : 0 days, 13 hours, 2 minutes
   ```

## How to Use
Depending on your system and permissions, the script may not run without making sure these prerequisites are met:

1. **PowerShell Execution Policy**: If the script fails to run, open a new PowerShell prompt and execute the following command:
   ```powershell
   Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted -Force
   ```

To use the EFHS Diagnostics tool, either:
1. Right click `EFHSDiagnostic.ps1` and click **Run in PowerShell.**

2. Open a new PowerShell window, navigate to the EFHSDiagnostics directory, and run `./EFHSDiagnostic.ps1`.

## License
This project is licensed under the GNU General Public License 3.0. See the [LICENSE](https://github.com/PossiblySlater/EFHSDiagnostics/blob/main/LICENSE) file for details.

Created by Slater Feistner
