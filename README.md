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

Before running the patch:

> **⚠️ Close the Note 3 program completely before applying the patch ⚠️**

Then, run the following command in **PowerShell (Admin)** to download and apply the patch:

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

## 📸 Results

### Before – Persistent Time Display Always Visible

<img alt="image" src="https://github.com/user-attachments/assets/1e6c5d44-ce74-41a9-bc06-df1d23cd5345" />

---

### After – Time Display Hidden

<img alt="image" src="https://github.com/user-attachments/assets/53e4ff21-317c-4f5e-b263-5c229262dc3f" />

---

### New Settings Entry – Toggle for Persistent Time

<img alt="image" src="https://github.com/user-attachments/assets/99e94544-4f29-43bd-a7dc-28c998643a85" />

---

## 🛡 Disclaimer

This patch is provided **as-is** without warranty.
Use it at your own risk and always back up your original DLL files before applying.
