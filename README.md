# EFHSDiagnostics

EFHSDiagnostics is a modern desktop application for quickly assessing the health and performance of your computer. Built with Electron, it provides a fast, user-friendly graphical interface to view detailed hardware and system diagnostics—all in one place.

This tool was made by a student, for students. It is meant to be an easy and accessible program to check the status and details of hardware in a computer. It is for students in computer service technician classes who may want to check a computer's status. 

## Features
- **Cross-platform GUI**: Sleek, easy-to-use interface (Windows .exe prebuilt; other platforms coming soon)
- **Comprehensive Diagnostics**:
  - **Operating System**: Name, version, uptime, and hostname
  - **CPU**: Model, core count, logical processors, and frequency
  - **RAM**: Total capacity, type, and manufacturer details
  - **Storage**: Drive list, capacity, and usage
  - **Graphics Cards**: Model and VRAM
  - **Network**: Adapter list, IP/MAC addresses, and internet connectivity check
  - **Sound Devices**: Card list and manufacturer
  - **Battery**: Charge level and status (if applicable)
- **One-click Diagnostics**: Instantly gather and display all system info
- **Export Results**: Save a full diagnostic report to a text file

## Installation
### Windows
1. Go to the [Releases](https://github.com/PossiblySlater/EFHSDiagnostics/releases) section of this repository.
2. Download the latest `EFHSDiagnostics.exe` file.
3. Double-click to launch—no installation required!

### Other Platforms
- Native builds for macOS and Linux are planned.

## Usage
- Launch the app and click **Run Diagnostics**.
- View detailed results for each hardware and system category in the main window.

## Contributing
Contributions are welcome! To run from source:
1. Clone this repository.
2. Install dependencies:
   ```bash
   npm install
   ```
3. Start the app:
   ```bash
   npm start
   ```

## License
EFHSDiagnostics is licensed under the GNU General Public License v3.0. See the [LICENSE](./LICENSE) file for details.

---

**Created by Slater Feistner and the EFHSDiagnostics Team**
