function getWindowsVersion(release) {
  const build = parseInt(release.split('.')[2] || "0", 10);
  if (build >= 22000) return "Windows 11";
  if (build >= 10240) return "Windows 10";
  if (build >= 9600) return "Windows 8.1";
  if (build >= 9200) return "Windows 8";
  if (build >= 7600) return "Windows 7";
  return "Windows (Unknown Version)";
}

function formatUptime(seconds) {
  const days = Math.floor(seconds / 86400);
  const hours = Math.floor((seconds % 86400) / 3600);
  const minutes = Math.floor((seconds % 3600) / 60);
  return `${days} days, ${hours} hours, ${minutes} minutes`;
}

async function runDiagnostics() {
  document.getElementById('os-info').textContent = "Loading...";
  document.getElementById('cpu-info').textContent = "Loading...";
  document.getElementById('ram-info').textContent = "Loading...";
  document.getElementById('net-info').textContent = "Loading...";
  document.getElementById('storage-info').textContent = "Loading...";
  document.getElementById('gpu-info').textContent = "Loading...";
  document.getElementById('sound-info').textContent = "Loading...";
  document.getElementById('battery-info').textContent = "Loading...";

  // OS Info
  const osInfo = window.diagnosticsAPI.getOSInfo();
  let versionText = osInfo.platform;
  if (osInfo.platform === "win32") {
    versionText = getWindowsVersion(osInfo.release);
  }
  document.getElementById('os-info').innerHTML = `
    <strong>Version:</strong> ${versionText}<br>
    <strong>Release:</strong> ${osInfo.release}<br>
    <strong>Uptime:</strong> ${formatUptime(osInfo.uptime)}<br>
    <strong>Hostname:</strong> ${osInfo.hostname}
  `;

  // CPU Info (detailed)
  const cpuDetails = await window.diagnosticsAPI.getCpuDetails();
  const logicalCores = cpuDetails.cores;
  const physicalCores = cpuDetails.physicalCores || "Unknown";
  const speed = cpuDetails.speed; // in GHz
  document.getElementById('cpu-info').innerHTML = `
    <strong>Model:</strong> ${cpuDetails.manufacturer} ${cpuDetails.brand}<br>
    <strong>Physical Cores:</strong> ${physicalCores}<br>
    <strong>Logical Cores:</strong> ${logicalCores}<br>
    <strong>Frequency:</strong> ${speed} GHz
  `;

  // RAM Info (detailed)
  const memLayout = await window.diagnosticsAPI.getMemoryLayout();
  const ramTypes = [...new Set(memLayout.map(m => m.type).filter(Boolean))];
  const ramManufacturers = [...new Set(memLayout.map(m => m.manufacturer).filter(Boolean))];
  const totalGB = Math.floor(memLayout.reduce((sum, m) => sum + (m.size || 0), 0) / (1024 * 1024 * 1024));

  document.getElementById('ram-info').innerHTML = `
    <strong>Total RAM:</strong> ${totalGB} GB<br>
    <strong>Type:</strong> ${ramTypes.length ? ramTypes.join(', ') : 'Unknown'}<br>
    <strong>Manufacturer(s):</strong> ${ramManufacturers.length ? ramManufacturers.join(', ') : 'Unknown'}
  `;

  // Network Info
  const netInfo = await window.diagnosticsAPI.getNetworkInterfaces();
  const internet = await window.diagnosticsAPI.checkInternet();
  let netHtml = `<strong></strong> <span class="${internet ? 'status-ok' : 'status-failed'}">${internet ? '' : ''}</span>`;
  netHtml += `<strong>Adapters:</strong><br>`;
  netInfo.forEach((nic, idx, arr) => {
    netHtml += `<div>
      <strong>${nic.ifaceName || nic.iface}</strong> (${nic.type || 'Unknown'})<br>`;
    if (nic.ip4) netHtml += `&nbsp;&nbsp;IPv4: ${nic.ip4}<br>`;
    if (nic.ip6) netHtml += `&nbsp;&nbsp;IPv6: ${nic.ip6}<br>`;
    if (nic.mac) netHtml += `&nbsp;&nbsp;MAC: ${nic.mac}<br>`;
    netHtml += `</div>`;
    if (idx < arr.length - 1) netHtml += `<hr style="border:0;border-top:1px solid #444;margin:6px 0;">`;
  });
  document.getElementById('net-info').innerHTML = netHtml;

  // Storage Info
  const disks = await window.diagnosticsAPI.getDiskLayout();
  const fsList = await window.diagnosticsAPI.getFsSize();
  let storageHtml = '';
  let totalCapacity = 0;
  fsList.forEach(fs => {
    storageHtml += `<div>
      <strong>${fs.fs}</strong> (${fs.mount || 'N/A'})<br>
      Capacity: ${(fs.size / (1024 ** 3)).toFixed(1)} GB
    </div>`;
    totalCapacity += fs.size;
  });
  storageHtml += `<hr style="border:0;border-top:1px solid #444;margin:6px 0;"><strong>Total Capacity:</strong> ${(totalCapacity / (1024 ** 3)).toFixed(1)} GB`;
  document.getElementById('storage-info').innerHTML = storageHtml;

  // Graphics Cards Info
  document.getElementById('gpu-info').textContent = "Loading...";
  const graphics = await window.diagnosticsAPI.getGraphics();
  let gpuHtml = "";
  graphics.controllers.forEach((gpu, idx, arr) => {
    gpuHtml += `<div>
      <strong>${gpu.model}</strong><br>
      VRAM: ${gpu.vram ? gpu.vram + " MB" : "Unknown"}
    </div>`;
    if (idx < arr.length - 1) gpuHtml += `<hr style="border:0;border-top:1px solid #444;margin:6px 0;">`;
  });
  document.getElementById('gpu-info').innerHTML = gpuHtml || "No graphics cards found.";

  // Sound Cards Info
  document.getElementById('sound-info').textContent = "Loading...";
  const audio = await window.diagnosticsAPI.getAudio();
  let soundHtml = "";
  audio.forEach((card, idx, arr) => {
    soundHtml += `<div>
      <strong>${card.name || "Unknown"}</strong><br>
      Manufacturer: ${card.manufacturer || "Unknown"}
    </div>`;
    if (idx < arr.length - 1) soundHtml += `<hr style="border:0;border-top:1px solid #444;margin:6px 0;">`;
  });
  document.getElementById('sound-info').innerHTML = soundHtml || "No sound cards found.";

  // Battery Info
  document.getElementById('battery-info').textContent = "Loading...";
  const battery = await window.diagnosticsAPI.getBattery();
  if (battery.hasBattery) {
    document.getElementById('battery-info').innerHTML = `
      <strong>Charge:</strong> ${battery.percent}%<br>
      <strong>Status:</strong> ${battery.isCharging ? "Charging" : "Discharging"}
    `;
  } else {
    document.getElementById('battery-info').textContent = "No battery detected.";
  }
}

function switchTab(tab) {
  document.getElementById('tab-diagnostics').classList.remove('active');
  document.getElementById('tab-network').classList.remove('active');
  document.getElementById('tab-about').classList.remove('active');
  document.getElementById('tab-updates').classList.remove('active');
  document.getElementById('diagnostics-content').style.display = 'none';
  document.getElementById('network-content').style.display = 'none';
  document.getElementById('about-content').style.display = 'none';
  document.getElementById('updates-content').style.display = 'none';

  if (tab === 'diagnostics') {
    document.getElementById('tab-diagnostics').classList.add('active');
    document.getElementById('diagnostics-content').style.display = '';
    runDiagnostics();
  } else if (tab === 'network') {
    document.getElementById('tab-network').classList.add('active');
    document.getElementById('network-content').style.display = '';
  } else if (tab === 'about') {
    document.getElementById('tab-about').classList.add('active');
    document.getElementById('about-content').style.display = '';
  } else if (tab === 'updates') {
    document.getElementById('tab-updates').classList.add('active');
    document.getElementById('updates-content').style.display = '';
  }
}

// Add at the top:
// const marked = require('marked'); // For Node context, but in browser use CDN or expose via preload if needed

window.addEventListener('DOMContentLoaded', () => {
  switchTab('diagnostics');
  // Load ABOUT.md into About tab and render as Markdown
  fetch('./ABOUT.md')
    .then(res => res.text())
    .then(text => {
      // Use marked to render Markdown to HTML
      if (window.marked) {
        document.getElementById('about-readme').innerHTML = window.marked.parse(text);
      } else {
        document.getElementById('about-readme').textContent = text + '\n\n[Markdown renderer not loaded]';
      }
    });
  // Check for updates
  const currentVersion = 'v4.1.2';
  const statusDiv = document.getElementById('update-status');
  fetch('https://api.github.com/repos/PossiblySlater/EFHSDiagnostics/releases/latest')
    .then(res => res.json())
    .then(release => {
      const latestVersion = release.tag_name || '';
      if (compareVersions(currentVersion, latestVersion) > 0) {
        statusDiv.textContent = `You are running a development version (${currentVersion}).`;
        document.getElementById('patchnotes-md')?.remove();
      } else if (compareVersions(latestVersion, currentVersion) > 0) {
        statusDiv.innerHTML = `An update is available: <b>${latestVersion}</b>.<br><a href=\"https://github.com/PossiblySlater/EFHSDiagnostics\" target=\"_blank\">Go to GitHub Releases</a>`;
        // Fetch and render PATCHNOTES.md from GitHub repo
        fetch('https://raw.githubusercontent.com/PossiblySlater/EFHSDiagnostics/main/PATCHNOTES.md')
          .then(res => res.text())
          .then(md => {
            let patchDiv = document.getElementById('patchnotes-md');
            if (!patchDiv) {
              patchDiv = document.createElement('div');
              patchDiv.id = 'patchnotes-md';
              patchDiv.className = 'about-readme';
              statusDiv.insertAdjacentElement('afterend', patchDiv);
            }
            patchDiv.innerHTML = window.marked ? window.marked.parse(md) : md;
          });
      } else {
        statusDiv.textContent = `You are running the latest version (${currentVersion}).`;
        document.getElementById('patchnotes-md')?.remove();
      }
    })
    .catch(() => {
      statusDiv.textContent = 'Unable to check for updates.';
    });
});

// Simple version comparison: returns 1 if v1>v2, -1 if v1<v2, 0 if equal
function compareVersions(v1, v2) {
  const a = v1.replace(/^v/, '').split('.').map(Number);
  const b = v2.replace(/^v/, '').split('.').map(Number);
  for (let i = 0; i < Math.max(a.length, b.length); i++) {
    const n1 = a[i] || 0, n2 = b[i] || 0;
    if (n1 > n2) return 1;
    if (n1 < n2) return -1;
  }
  return 0;
}
