# Drive Icon Customizer Script

## Overview
This batch script allows you to customize drive icons in Windows by applying `.ico` files from specially named folders in the script's directory. It modifies the Windows Registry to set custom icons for drive letters (A-Z) based on the folder structure and icon files provided.

## Prerequisites
- **Windows Operating System**: The script is designed for Windows environments.
- **Administrative Privileges**: The script requires elevated permissions to modify the Windows Registry.
- **Icon Files**: You need `.ico` files placed in appropriately named folders (see below).

## How It Works
1. **Checks for Admin Privileges**: The script verifies if it is running with administrative rights. If not, it relaunches itself with elevated permissions using a temporary VBScript.
2. **Warns the User**: Displays a warning about resetting drive icons to Windows defaults and allows the user to cancel by pressing the ESC key.
3. **Deletes Existing Icons**: Removes any existing custom drive icon configurations from the Registry under `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\DriveIcons`.
4. **Scans for Configuration Folders**: Looks for folders in the script's directory named after single drive letters (e.g., `A`, `B`, `C`, etc.).
5. **Applies New Icons**: For each valid folder containing an `.ico` file, the script updates the Registry to set the icon for the corresponding drive letter.
6. **Feedback**: Provides feedback on the number of icons deleted, folders found, and icons applied, including any errors.

## Folder Structure
To customize a drive's icon, create a folder in the same directory as the script named after the drive letter (e.g., `A`, `B`, etc.). Place a single `.ico` file inside that folder. For example:
```
script_directory/
├── A/
│   └── custom_icon.ico
├── B/
│   └── another_icon.ico
├── script.bat
└── README.md
```
- The script will use the first `.ico` file found in each folder.
- If no `.ico` file is found in a folder, that drive's icon will not be modified.
- If no valid folders are found, the script will reset all drive icons to Windows defaults.

## Usage
1. Place the script (`apply icons.bat`) in a directory.
2. Create folders named after the drive letters you want to customize (e.g., `A`, `B`, etc.).
3. Place one `.ico` file in each folder.
4. Run the script by double-clicking it or executing it from the Command Prompt.
5. Follow the on-screen prompts:
   - Press any key to continue or ESC to cancel.
6. The script will process the folders, update the Registry, and display the results.

## Example
Suppose you have the following setup:
```
C:\DriveIcons\
├── C/
│   └── drive_c.ico
├── D/
│   └── drive_d.ico
├── script.bat
└── README.md
```
Running `script.bat` will:
- Delete any existing custom icons for drives A-Z in the Registry.
- Detect folders `C` and `D` with their respective `.ico` files.
- Set the icon for drive `C` to `drive_c.ico` and drive `D` to `drive_d.ico` in the Registry.

## Notes
- **Backup**: Modifying the Registry can affect system behavior. Back up the Registry or create a system restore point before running the script.
- **Single Icon per Folder**: The script uses the first `.ico` file found in each folder. Ensure only one `.ico` file is present to avoid ambiguity.
- **Error Handling**: If an error occurs while setting an icon, the script will notify you to rerun it.
- **Default Icons**: If no configuration folders are found, all drive icons revert to Windows defaults.
- **Timeout**: The script includes brief pauses (10ms) to ensure smooth execution and readability. These can be adjusted in the `:wait` subroutine if needed.

## Troubleshooting
- **Script Doesn't Run**: Ensure you have administrative privileges. The script will attempt to elevate itself, but you may need to right-click and select "Run as administrator."
- **Icons Not Applied**: Verify that:
  - The folders are named correctly (single letters A-Z).
  - Each folder contains a valid `.ico` file.
  - The script has write access to the Registry.
- **Errors in Registry**: If errors occur, try running the script again or check the Registry manually at `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\DriveIcons`.

## Disclaimer
This script modifies the Windows Registry, which can impact system functionality if used incorrectly. Use it at your own risk. The author is not responsible for any damage or data loss caused by running this script.

## License
This script is provided as-is, with no warranty. You are free to use, modify, and distribute it under the [MIT License](https://opensource.org/licenses/MIT).