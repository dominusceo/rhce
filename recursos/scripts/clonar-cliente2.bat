echo off
REM Autor: Ricardo David Carrillo Sanchez
REM Objetivo: Clonar una maquina virtual a partir de una plantilla
REM Variable que define la plantilla de cual se va a clonar
SET "RUTA=F:\My Virtual Machines"
SET "CMDS=c:\Program Files (x86)\VMware\VMware Workstation\"
SET "SCRIPTS=C:\Users\CARRILLO RICARDo\Documents\GitHub\rhce\recursos\scripts"
SET "RPLANTILLA=plantilla-cliente2.example.org\"
SET "PLANTILLA=plantilla-cliente2.example.org.vmx"
SET "DOMAIN=example.org"
SET "arg1=%~1"
if "%arg1%"=="" ( goto :Use ) ELSE ( goto :Create )

:Use
echo Uso: clonar-mv-ws.bat "cliente1" & BREAK=ON

:Create
REM Creando directorio %arg1% y clonando maquina
IF NOT EXIST "%RUTA%\%arg1.%DOMAIN%" (
  echo Creando directorio "%arg1%"
  cd "%CMDS%"
  mkdir  "%RUTA%\%arg1%.%DOMAIN%"
  REM Clonando maquina %arg1%
  echo Clonando maquina "%arg1%"
  vmrun -T ws clone "%RUTA%\%RPLANTILLA%\%PLANTILLA%" "%RUTA%\%arg1%.%DOMAIN%\%arg1%.%DOMAIN%.vmx" full -cloneName="%arg1%.%DOMAIN%"
  vmware.exe "%RUTA%\%arg1%.%DOMAIN%\%arg1%.%DOMAIN%.vmx"
  vmrun -T ws start "%RUTA%\%arg1%.%DOMAIN%\%arg1%.%DOMAIN%.vmx"
) ELSE IF EXIST "%RUTA%\%arg1%.%DOMAIN%\" (
  cd "%CMDS%"
  vmrun -T ws stop "%RUTA%\%arg1%.%DOMAIN%\%arg1%.%DOMAIN%.vmx"
  del /s /f /q "%RUTA%\%arg1%.%DOMAIN%"
  rmdir "%RUTA%\%arg1%.%DOMAIN%\" /s /q
) ELSE (
  echo No se hace nada %arg1%
)
cd "%SCRIPTS%"
