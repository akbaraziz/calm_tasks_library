# Install VSCode
Invoke-WebRequest 'https://code.visualstudio.com/sha/download?build=stable&os=win32-x64' -OutFile 'C:\VisualStudioCodeSetup.exe'
Start-Process -FilePath 'C:\VisualStudioCodeSetup.exe' -ArgumentList "/verysilent /norestart" -NoNewWindow -Wait