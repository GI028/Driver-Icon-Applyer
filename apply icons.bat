@echo off
setlocal enabledelayedexpansion

:: -----------------------------------
:: Check for Admin Privileges
:: -----------------------------------
net session >nul 2>&1
if %errorlevel% equ 0 (
  echo Running with administrative privileges.
  goto :run_script
)

:: If not elevated, create a VBScript to relaunch as admin
echo Requesting administrative privileges...
set "VBS_FILE=%temp%\elevate_%random%.vbs"
(
echo Set UAC = CreateObject^("Shell.Application"^)
echo UAC.ShellExecute "cmd.exe", "/c ""%~f0""", "", "runas", 1
) > "%VBS_FILE%"

:: Run the VBScript and exit
cscript //nologo "%VBS_FILE%"
del "%VBS_FILE%"
exit /b

:: -----------------------------------
:: Main Script
:: -----------------------------------
:run_script

:: Wanrning the user before processing
cls
echo.
echo Do you want to continue?
echo.
echo.
echo This script will delete all icon information in the Registry.
echo Deleting this information means that icons will initially revert to the default icons chosen by Windows.
echo Running this script will apply only the configurations related to the folders in this script's directory.
echo.
echo For more information, read the README.md file.
echo.
echo.
echo Press any key to continue, or press ESC to cancel...

:: Read a key using PowerShell
for /f %%k in ('powershell -nologo -command ^ "$key = $host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown'); $key.VirtualKeyCode"') do set key=%%k

:: Check if ESC was pressed (ASCII code 27)
if "%key%"=="27" (
  echo You pressed ESC. Exiting...
  call :wait
  goto end
  ) else (
  echo Continuing...
  call :wait
  cls
)

echo.
echo Running the Script...

:: Initialize variables
set "CURRENT_DIR=%~dp0"
set "DRIVE_ICON_PAIRS="
set "REG_KEY=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\DriveIcons"
set "VALID_LETTERS=A B C D E F G H I J K L M N O P Q R S T U V W X Y Z"

:: -----------------------------------
:: Delet existing default icons in the register
:: -----------------------------------
set deletedIconCount=0
call :wait
echo.
echo.
echo Deleting previously applied icons...
for %%L in (%VALID_LETTERS%) do (
  reg delete "%REG_KEY%\%%L" /f >nul 2>&1
  if !errorlevel! equ 0 (
    set /a deletedIconCount+=1
    call :wait
    echo    Old icon for: %%L deleted
  )
)
if %deletedIconCount%==0 (
  call :wait
  echo    No previously applied icons found.
)

:: -----------------------------------
:: Process Single-Letter Folders
:: -----------------------------------
set configFolderCount=0
call :wait
echo.
echo.
echo Scanning the current directory...
for %%L in (%VALID_LETTERS%) do (
  if exist "%CURRENT_DIR%\%%L\" (
    set "ICO_PATH="
    :: Find the first .ico file
    for %%I in ("%CURRENT_DIR%%%L\*.ico") do (
      if not defined ICO_PATH (
        set "ICO_PATH=%%~fI"
      )
    )
    :: Saving found values
    if defined ICO_PATH (
      set /a configFolderCount+=1
      if defined DRIVE_ICON_PAIRS (
        set "DRIVE_ICON_PAIRS=!DRIVE_ICON_PAIRS!;%%L^|!ICO_PATH!"
        ) else (
        set "DRIVE_ICON_PAIRS=%%L^|!ICO_PATH!"
      )
    )
  )
)

call :wait
if %configFolderCount%==0 (
  echo    No configuration folders found. Default icons will be applied.
  call :exit
) else if %configFolderCount%==1 (
  echo    Found !configFolderCount! configuration folder.
) else (
  echo    Found !configFolderCount! configuration folders.
)

:: -----------------------------------
:: Apply new icons in the register
:: -----------------------------------
call :wait
echo.
echo.
echo Applying icons based on configuration folders...
for %%R in (!DRIVE_ICON_PAIRS!) do (
  :: Split each record into DRIVER_LETTER and ICO_PATH using the | delimiter
  for /f "tokens=1,2 delims=|" %%A in ("%%R") do (
    call :wait
    set "DRIVER_LETTER=%%A"
    set "ICO_PATH=%%B"
    reg add "%REG_KEY%\!DRIVER_LETTER!\DefaultIcon" /ve /t REG_SZ /d "!ICO_PATH!" /f>nul 2>&1

    if errorlevel 1 (
      echo    Error occurred while changing the icon for !DRIVER_LETTER!. Try rerunning t
    ) else (
      echo    Icon for drive !DRIVER_LETTER! successfully changed.
    )

  )
)
call :wait
:exit
echo.
echo.
echo Exiting...
endlocal
timeout /t 4 /nobreak >nul
exit /b 0

:wait
@REM timeout /t 1 /nobreak >nul
powershell -command "Start-Sleep -Milliseconds 10"
