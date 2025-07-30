# SC-Fusion-Script

**One backup, one config - for LIVE, PTU, EPTU and more.**

---

## What it does

SC-Fusion-Script keeps **all your Star Citizen builds** (LIVE, PTU, EPTU, TECH‑PREVIEW, HOTFIX, or any other folder you list) pointing to **one shared backup** for :

* **Screenshots**
* **Control Mappings (Keybinds you have saved)** (`user\client\0\Controls\Mappings`)
* **Custom Characters (avatars you have saved)** (`user\client\0\CustomCharacters`)
* **Profile (your gamne settings)** (`user\client\0\Profiles`)

It copies each real folder to `_Backup\..`, replaces it with a directory symlink, and prints a compact status line:

```cmd
== LIVE ==
Screenshots .......... BKP:OK  LNK:OK
Mappings ............. BKP:SKIP LNK:OK
CustomCharacters ..... BKP:OK  LNK:OK
Profiles ............. BKP:OK  LNK:OK
```

* **BKP** - files backed-up (first run) or **SKIP** when nothing changed.
* **LNK** - symbolic link created, **SKIP** if already present, **ERR** on failure.

Run it as many times as you like - the script is **idempotent**: it never duplicates data and only copies what is missing.

---

## Installation

1. **Download `setup_links.bat`.**
2. Place it **next to your build folders**, e.g.:

   ```txt
   C:\Program Files\Roberts Space Industries\StarCitizen\
   ├─ LIVE
   ├─ PTU
   ├─ EPTU
   ├─ TECH-PREVIEW
   └─ setup_links.bat
   ```
3. **Right-click -> Run as administrator.**
4. *(Optional but recommended)* Make a manual copy of your build folders the first time you run the script.

> 💡 The terminal stays open (`pause`) so you can read the results.

---

## Running it again

* Re-running the script is safe.
* Existing files are **not duplicated** - `xcopy /Y` silently overwrites when names match.
* If you delete a build folder later, the other builds keep working because they all point to the same `_Backup` directory.

---

## Advanced - editing `DIRS`

Open the BAT in a text editor and change the line:

```bat
set "DIRS=LIVE EPTU PTU HOTFIX TECH-PREVIEW"
```

Add or remove folder names as needed (space-separated). Any name not found on disk is skipped automatically.

---

## Requirements

* tested on Windows 10 / Windows 11
* Administrator rights (needed for `mklink /D`)

---

## License

**Creative Commons Attribution‑NonCommercial 4.0 International (CC BY‑NC 4.0)**
Feel free to share, adapt, and fork as long as you credit the original author and keep it non‑commercial.

---

Happy flying, and no more lost keybinds! ✈️
