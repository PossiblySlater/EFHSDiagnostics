const { contextBridge, net } = require('electron');
const os = require('os');
const { exec } = require('child_process');
const fetch = require('node-fetch');
const si = require('systeminformation');
const dns = require('dns');

console.log("preload.js loaded");

contextBridge.exposeInMainWorld('diagnosticsAPI', {
  getOSInfo: () => ({
    platform: os.platform(),
    release: os.release(),
    uptime: os.uptime(),
    hostname: os.hostname()
  }),

  getCPUInfo: () => os.cpus(),

  getRAMInfo: () => ({
    totalMem: os.totalmem(),
    freeMem: os.freemem()
  }),

  // New: Get detailed CPU info
  getCpuDetails: async () => {
    return await si.cpu();
  },

  // New: Get detailed RAM info (array of sticks)
  getMemoryLayout: async () => {
    return await si.memLayout();
  },

  getNetworkInterfaces: async () => {
    return await si.networkInterfaces();
  },
  getDiskLayout: async () => {
    return await si.diskLayout();
  },
  getFsSize: async () => {
    return await si.fsSize();
  },

  checkInternet: async () => {
    // Try HTTP HEAD first
    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), 3000);

    try {
      const response = await fetch('http://example.com', {
        method: 'HEAD',
        signal: controller.signal
      });
      clearTimeout(timeout);
      if (response.ok) return true;
    } catch (e) {
      clearTimeout(timeout);
    }

    // Fallback: DNS lookup
    return new Promise((resolve) => {
      dns.lookup('google.com', (err) => {
        resolve(!err);
      });
    });
  },
  getGraphics: async () => {
    return await si.graphics();
  },
  getAudio: async () => {
    return await si.audio();
  },
  getBattery: async () => {
    return await si.battery();
  },
});
