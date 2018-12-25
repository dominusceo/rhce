echo off
REM Autor: Ricardo David Carrillo Sanchez
REM Objetivo: Clonar una maquina virtual a partir de una plantilla
REM Variable que define la plantilla de cual se va a clonar
SET "RUTA=F:\My Virtual Machines"
SET "CMDS=c:\Program Files (x86)\VMware\VMware Workstation\"
SET "SCRIPTS=C:\Users\CARRILLO RICARDo\Documents\GitHub\rhce\recursos\scripts"
SET "RPLANTILLA=plantilla-cliente1.example.org"
SET "PLANTILLA=plantilla-cliente1.example.org.vmx"
SET "DOMAIN=example.org"
SET "arg1=%~1"
if "%arg1%"=="" ( goto :Use ) ELSE ( goto :Create )

:Use
echo Uso: clonar-mv-ws.bat "general" & BREAK=ON

:Create
REM Creando directorio %arg1% y clonando maquina
IF NOT EXIST "%RUTA%\%arg1%" (
  echo Creando directorio "%arg1%"
  cd "%CMDS%"
  mkdir  "%RUTA%\%arg1%"
  REM Clonando maquina %arg1%
  echo Clonando maquina "%arg1%"
  vmrun -T ws clone "%RUTA%\%RPLANTILLA%\%PLANTILLA%" "%RUTA%\%arg1%\%arg1%.vmx" full -cloneName="%arg1%"
  vmware.exe "%RUTA%\%arg1%\%arg1%.vmx"
  vmrun -T ws start "%RUTA%\%arg1%\%arg1%.vmx"
) ELSE IF EXIST "%RUTA%\%arg1%\" (
  cd "%CMDS%"
  vmrun -T ws stop "%RUTA%\%arg1%\%arg1%.vmx"
  del /s /f /q "%RUTA%\%arg1%"
  rmdir "%RUTA%\%arg1%\" /s /q
) ELSE (
  echo No se hace nada %arg1%
)
cd "%SCRIPTS%"

REM --ipAllocationPolicy
REM --net:s1=t1
REM --powerOn
REM ovftool vmxs/Nostalgia.vmx ovfs/Nostalgia.ova
REM ovftool --machineOutput source target
REM ovftool.exe --compress=9 "F:\My Virtual Machines\acceso1\acceso1.vmx" "F:\ovas\acceso.ova"
