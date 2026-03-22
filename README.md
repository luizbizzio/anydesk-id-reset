# AnyDesk ID Reset 🪪

A safe, one-click tool to reset your AnyDesk ID and remove "Commercial Use Detected" warnings without losing your saved data.

This tool performs a "surgical" reset, modifying only the necessary identity files. Your Recent Sessions, Favorites, and Settings remain 100% intact (Zero Data Loss).

---

## ⚙️ Quick Start (One-Liner)

Open **Command Prompt (CMD)** or **PowerShell** as Administrator and paste the command below:

```powershell
powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/luizbizzio/anydesk-id-reset/main/anydesk_id_reset.ps1 | iex"
```

---

## ✨ Why use this tool?

* **Stop "Commercial Use Detected" Popups:** This is the primary fix for the annoying nag screens, 20-second countdowns (later 100 seconds), and "Time Limit" warnings that block your connection.
* **Bypass Connection Blocks:** Restores your ability to connect to remote PCs when AnyDesk flaggs your ID as professional/commercial.
* **Keep Your Saved PCs:** Your Recent Sessions, and favorites stay exactly where they are, no manual backup needed.
* **Settings Stay Intact:** Your language, custom names, and theme preferences won't be wiped.
* **Total Automation:** Works for both **Installed** and **Portable** versions with a single click.

## 🛠️ How it works (The Safe Way)

Unlike other scripts that delete everything, this tool is "surgical", it only touches what it needs to:
1.  **Locates AnyDesk:** Automatically finds where your AnyDesk is hidden, even if it's on your Desktop or Downloads folder.
2.  **Safe Shutdown:** Properly closes AnyDesk so no data gets corrupted during the process.
3.  **Identity Reset:** Deletes only the secret files that hold your old ID and "commercial use" flags.
4.  **Smart Cleaning:** Scans your configuration files to wipe out the old license data while leaving your list of saved PCs untouched.
5.  **Fresh Identity:** Cleans the Windows cache and restarts AnyDesk with a brand-new ID.

## ⚠️ Disclaimer 

This project is an independent, unofficial utility and is **not affiliated with, endorsed by, or supported by AnyDesk Software GmbH**.
It is provided **as is**, without warranties or guarantees of any kind, whether express or implied, including but not limited to merchantability, fitness for a particular purpose, or non-infringement.
By using this project, you accept full responsibility for reviewing the source code, understanding its behavior, and determining whether it is appropriate for your environment. You are also responsible for complying with the terms, policies, and licensing conditions of any third-party software involved.
The author is **not liable** for data loss, service interruption, configuration issues, account or device problems, software misuse, or any direct or indirect damages resulting from the use of this project.
Use this project only on systems you own or are explicitly authorized to administer, and only in lawful, controlled environments.

## 📄 License

This project is licensed under the [MIT License](./LICENSE).
