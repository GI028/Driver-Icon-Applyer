@echo off
setlocal enabledelayedexpansion

:: -----------------------------------
:: Check for Administrative Privileges
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
:: Initialize variables
set "CURRENT_DIR=%~dp0"
set "OBJ="
set "REG_KEY=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\DriveIcons"
set "VALID_LETTERS=A B C D E F G H I J K L M N O P Q R S T U V W X Y Z"

:: -----------------------------------
:: Process Single-Letter Folders
:: -----------------------------------
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
      if defined OBJ (
        set "OBJ=!OBJ!;%%L^|!ICO_PATH!"
        ) else (
        set "OBJ=%%L^|!ICO_PATH!"
      )
    )
  )
)

:: -----------------------------------
:: Delet existing default icons in the register
:: -----------------------------------
for %%L in (%VALID_LETTERS%) do (
  reg delete "%REG_KEY%\%%L" /f >nul 2>&1
)

:: -----------------------------------
:: Apply new icons in the register
:: -----------------------------------
if defined OBJ (
  for %%R in (!OBJ!) do (
    :: Split each record into DRIVER_LETTER and ICO_PATH using the | delimiter
    for /f "tokens=1,2 delims=|" %%A in ("%%R") do (
      call :wait
      set "DRIVER_LETTER=%%A"
      set "ICO_PATH=%%B"
      reg add "%REG_KEY%\!DRIVER_LETTER!\DefaultIcon" /ve /t REG_SZ /d "!ICO_PATH!" /f
    )
  )
  ) else (
  echo Nothing to iterate.
)

call :wait
if %errorlevel% equ 0 (
  echo Icons applied successfully.
  ) else (
  echo Errors happened. Try to rerun the program.
)
echo Exiting...
endlocal
timeout /t 3 /nobreak >nul
exit /b 0

:wait
timeout /t 1 /nobreak >nul
