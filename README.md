# EasiNote-Fix – Persistent Time Display Patch

## 📌 Overview

This project contains a set of **patched DLL files** for the program **"Note 3"**.
The patch enables a hidden setting that allows you to **turn off the persistent time display** in the software.

By applying this patch, you can enjoy a cleaner interface without the constant on-screen clock.

---

## ⚙ How It Works

The patch replaces the original DLL files in the `Note 3` installation directory with modified versions.
The modified files are sourced from this repository and automatically copied to the correct location.

---

## 🚀 Automatic Installation

Run the following command in **PowerShell (Admin)** to automatically download and apply the patch:

```powershell
irm 'https://raw.githubusercontent.com/doas-ice/EasiNote-Fix/main/install.ps1' | iex
```

> ⚠ **Important:** You must run PowerShell **as Administrator** so the script can write to the installation directory.

---

## 📂 Target Directory

The patched files are copied to:

```
C:\Program Files (x86)\ShiRui\Note\Main
```

---

## 🛡 Disclaimer

This patch is provided **as-is** without warranty.
Use it at your own risk and always back up your original DLL files before applying.
