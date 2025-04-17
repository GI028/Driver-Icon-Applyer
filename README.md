# Drive Icon Customizer

## Overview
**Drive Icon Customizer** is a Windows batch script that customizes drive icons in File Explorer by assigning `.ico` files from single-letter folders (`A`, `B`, `C`, etc.) to their corresponding drives (`A:`, `B:`, `C:`, etc.). The script updates the Windows registry under `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\DriveIcons` to set the `(Default)` value of each drive’s `DefaultIcon` subkey to the path of the first `.ico` file found in the respective folder.

### Use Case
This script is designed for users who want to personalize the appearance of their drives in Windows File Explorer. For example:
- Assign a custom icon to drive `C:` by placing an `icon.ico` file in a folder named `C`.
- Automatically apply icons for multiple drives (`A:` to `Z:`) based on `.ico` files in corresponding folders.

The script is useful for system administrators, enthusiasts, or anyone managing multiple drives who wants a visual distinction for each drive.

## Prerequisites
- **Operating System**: Windows (tested on Windows 10/11; should work on Windows 7 and later).
- **Administrative Privileges**: The script requires Administrator rights to modify the registry (`HKEY_LOCAL_MACHINE`).
- **Folder Structure**: Single-letter folders (`A`, `B`, `C`, etc.) containing at least one `.ico` file each, located in the same directory as the script.
- **VBScript**: Enabled by default on Windows, used for self-elevation.

## Installation
1. **Download the Script**:
   - Save the script as `applyIcons.bat` (or any preferred name with a `.bat` extension).

2. **Set Up Folder Structure**:
   - Create a directory (e.g., `C:\ICONS`).
   - Place the script in this directory.
   - Create single-letter folders (`A`, `B`, `C`, etc.) in the same directory.
   - Add at least one `.ico` file to each folder corresponding to the drive you want to customize (e.g., `C:\ICONS\A\icon.ico` for drive `A:`).

3. **Verify `.ico` Files**:
   - Ensure the `.ico` files are valid icon files compatible with Windows File Explorer.

## Usage
1. **Run the Script**:
   - Double-click `applyIcons.bat`, or run it from a Command Prompt.
   - If not already elevated, a User Account Control (UAC) prompt will appear. Click **Yes** to grant administrative privileges.
   - Alternatively, right-click the script and select **Run as administrator**.

2. **What the Script Does**:
   - Checks for administrative privileges and self-elevates if needed.
   - Scans for single-letter folders (`A` to `Z`) in the script’s directory.
   - Deletes any existing registry keys under `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\DriveIcons` for each letter.
   - For each existing folder:
     - Finds the first `.ico` file.
     - Sets the `(Default)` value of `DriveIcons\<Letter>\DefaultIcon` to the `.ico` file path.
     - Records the folder name and `.ico` path in the `OBJ` variable.

3. **Apply Changes**:
   - Drive icon changes may not appear immediately. To apply them:
     - Restart File Explorer.
     - Alternatively, log off and log back on, or restart your computer.

## Folder Structure
The script expects the following directory layout:
```
C:\ICONS\
├── applyIcons.bat
├── A\
│   └── icon.ico
├── B\
│   └── test.ico
├── C\
│   └── (no .ico files, ignored for registry)
...
```
- Each single-letter folder (`A`, `B`, `C`, etc.) corresponds to a drive letter.
- The first `.ico` file in each folder is used for the drive’s icon.
- Non-existent folders or folders without `.ico` files are skipped.

## Example Output
Assuming the script is in `C:\ICONS\` with folders `A` (containing `icon.ico`), `B` (containing `test.ico`), and `C` (no `.ico` files), the output might look like:
```
Running with administrative privileges.
The operation completed successfully.
The operation completed successfully.
The operation completed successfully.
Icons applied successfully.
Exiting...

```

## Troubleshooting
- **UAC Prompt Not Appearing**:
  - Ensure VBScript is enabled (default on Windows).
  - Run the script manually as Administrator by right-clicking and selecting **Run as administrator**.
- **No Folders Processed**:
  - Verify the script is in the correct directory (e.g., `C:\Scripts`).
  - Run `dir C:\ICONS
\* /a:d` in a Command Prompt to confirm single-letter folders exist.
- **Registry Errors**:
  - Check if the script is running as Administrator.
  - Open `regedit` and navigate to `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\DriveIcons` to verify key changes.
  - If “ERROR: Failed to set (Default) value” appears, ensure the `.ico` file path is valid and accessible.
- **Icons Not Updating**:
  - Restart File Explorer or reboot the system to apply registry changes.
  - Ensure `.ico` files are valid icon files (test by manually setting a drive icon in `regedit`).
- **Unexpected Output**:
  - Share the script’s console output with support for diagnosis.

## Notes
- **Registry Backup**: Before running, consider backing up the registry:
  - Open `regedit`, navigate to `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\DriveIcons`, right-click, and select **Export**.
- **Delimiter Usage**: The script uses `;` to separate folder-icon pairs and `|` to separate folder names from paths in the `OBJ` variable.
- **Performance**: The script processes 26 letters (`A` to `Z`), but only existing folders are counted and processed, ensuring efficiency.
- **Safety**: Modifying the registry can affect system behavior. Ensure `.ico` paths are correct to avoid broken drive icons.

## License
This script is provided as-is without a formal license. You are free to use, modify, and distribute it for personal or commercial purposes. Please ensure you understand the script’s actions before running it.

## Support
For issues, questions, or feature requests, please share:
- The script’s console output.
- The folder structure (`dir C:\ICONS\* /a:d` and `dir C:\ICONS\*\*.ico` results).
- Your Windows version (e.g., Windows 10, 11).

Contact the script author or post an issue on the repository (if hosted).

---
*Generated on April 17, 2025*