echo off
REM Autor: Ricardo David Carrillo Sanchez
REM Goal: Export VM to OVA on vmware Workstation
SET "arg1=%~1"
SET "RUTA=F:\My Virtual Machines"
SET "SCRIPTS=C:\Users\CARRILLO RICARDo\Documents\GitHub\rhce\recursos\scripts"
SET "OVABIN=C:\Program Files (x86)\VMware\VMware Workstation\OVFTool"
SET "OVAPATH=F:\ovas"
SET "OVATPL=dstation.ova"
SET "DOMAIN=example.org"
SET "CMDS=c:\Program Files (x86)\VMware\VMware Workstation"
if "%arg1%"=="" ( goto :Use ) ELSE ( goto :Backup )


:Use
echo Uso: clonar-mv-ws.bat "cliente1" & BREAK=ON



:Backup
IF EXIST "%RUTA%\%arg1%.%DOMAIN%\" (
  echo Borrando respaldo %OVAPATH%
  del /s /f /q %OVAPATH%\%OVATPL%
  cd "%CMDS%"
  vmrun -T ws stop "%RUTA%\%arg1%.%DOMAIN%\%arg1%.%DOMAIN%.vmx"
  echo Respaldando "%arg1%.%DOMAIN%"
  cd "%OVABIN%"
  ovftool.exe --compress=9 "%RUTA%\%arg1%.%DOMAIN%\%arg1%.%DOMAIN%.vmx" "%OVAPATH%\%arg1%.ova"
  cd "%CMDS%"
  vmrun -T ws start "%RUTA%\%arg1%.%DOMAIN%\%arg1%.%DOMAIN%.vmx"
  echo Iniciando "%arg1%.%DOMAIN%"
  vmware.exe "%RUTA%\%arg1%\%arg1%.%DOMAIN%.vmx"
) ELSE (
  echo No se hace nada %arg1%
)
cd "%SCRIPTS%"
