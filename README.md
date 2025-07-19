# EFHSDiagnostics

EFHSDiagnostics is a desktop application for quickly assessing the health and performance of your computer, made to be easy for students to use. Built with Electron, it provides a fast, user-friendly graphical interface to view detailed hardware and system diagnostics—all in one place.

**Made by students, for students:** EFHSDiagnostics is designed specifically with middle and high school computer technicians in mind. Our goal is to make it easy for students to see everything about a computer in one place, providing all the essential diagnostics and system information through a simple, unified interface.

## What's New in v4.1.3
- **Dark/Light Theme Toggle:** Switch between themes with a bouncy animated button in the top-right corner.
- **Theme Persistence:** Your theme preference is automatically saved and restored.

## Features
- **Cross-platform GUI**: Sleek, easy-to-use interface (Windows .exe and Linux .deb prebuilt; other platforms coming soon)
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
1. Download the latest `.exe` package from the [Releases](https://github.com/PossiblySlater/EFHSDiagnostics/releases) section of the repository.
2. Run the installer and follow the prompts to install EFHSDiagnostics.
3. Once installed, launch EFHSDiagnostics from your Start Menu.

### Linux
> **Warning:** The prepackaged Linux .deb file has **not** been tested in a native Linux environment. It has only been tested in a WSL Ubuntu environment in Windows. Use at your own risk.
1. Download the latest `.deb` package from the [Releases](https://github.com/PossiblySlater/EFHSDiagnostics/releases) section.
2. Open a terminal and navigate to the folder where you downloaded the file.
3. Install the package using:
   ```bash
   sudo dpkg -i EFHSDiagnostics.Setup.*.*.*.deb
   ```
4. If you encounter missing dependencies, run:
   ```bash
   sudo apt-get install -f
   ```
5. Launch EFHSDiagnostics from your applications menu or by running `efhsdiagnostics-electron` in the terminal.

## Usage
- Open EFHSDiagnostics and use the tabs to navigate between Diagnostics, Network Tests, About, and Updates.
- View detailed results for each hardware and system category in the main window.
- Run a network speed test in the Network Tests tab.
- Read about the app in the About tab.
- Check for updates and view patch notes in the Updates tab.

> **Recommended:** For the best experience, run EFHSDiagnostics in a maximized window to ensure all information is clearly visible.

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
