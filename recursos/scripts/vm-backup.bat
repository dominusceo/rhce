echo off
REM Autor: Ricardo David Carrillo Sanchez
REM Goal: Export VM to OVA on vmware Workstation
SET "arg1=%~1"
SET "RUTA=F:\My Virtual Machines"
SET "SCRIPTS=C:\Users\CARRILLO RICARDo\Documents\GitHub\rhce\recursos\scripts"
SET "OVABIN=C:\Program Files (x86)\VMware\VMware Workstation\OVFTool"
SET "OVAPATH=F:\ovas"
SET "OVATPL=%arg1%.ova"
SET "DOMAIN=example.org"
SET "RPLANTILLA=plantilla-%arg1%.%DOMAIN%"
SET "PLANTILLA=plantilla-%arg1%.%DOMAIN%.vmx"
SET "DBACKUP=%RUTA%\%RPLANTILLA%"
SET "CMDS=c:\Program Files (x86)\VMware\VMware Workstation"
if "%arg1%"=="" ( goto :Use ) ELSE ( goto :Backup )

:Use
echo Uso: vm-backup.bat "cliente1" & BREAK=ON

:Backup
IF EXIST "%DBACKUP%" (
  echo Borrando respaldo %OVAPATH%
  del /s /f /q %OVAPATH%\%OVATPL%
  cd "%CMDS%"
  vmrun -T ws stop "%DBACKUP%\%PLANTILLA%"
  echo Respaldando %arg1%
  cd "%OVABIN%"
  ovftool.exe --compress=9 "%DBACKUP%\%PLANTILLA%" "%OVAPATH%\%arg1%.ova"
  cd "%CMDS%"
  REM vmrun -T ws start "%DBACKUP%\%PLANTILLA%"
  REM echo Iniciando %arg1%
  REM vmware.exe "%DBACKUP%\%PLANTILLA%"
) ELSE (
  echo No se hace nada %arg1%
)
cd "%SCRIPTS%"
