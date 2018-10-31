echo off
REM Autor: Ricardo David Carrillo Sanchez
REM Objetivo: Clonar una maquina virtual a partir de una plantilla
REM Variable que define la plantilla de cual se va a clonar
SET "RUTA=F:\My Virtual  Machines"
REM SET "SCRIPTS=C:\Users\CARRILLO RICARDo\Documents\scripts\"
SET "SCRIPTS=C:\Users\CARRILLO RICARDo\Documents\GitHub\rhce"
SET "RPLANTILLA=plantilla-centos-idm-example.org\"
SET "PLANTILLA=plantilla-centos-idm-example.org.vmx"
SET "arg1=%~1"
if "%arg1%"=="" ( goto :Use ) ELSE ( goto :Create )

:Use
echo Uso: clonar-centos-idm.bat "cliente1" & BREAK=ON

:Create
REM Creando directorio %arg1% y clonando maquina
IF NOT EXIST "%RUTA%\%arg1%" (
  echo Creando directorio "%arg1%"
  cd "c:\Program Files (x86)\VMware\VMware Workstation"
  mkdir  "%RUTA%\%arg1%"
  REM Clonando maquina %arg1%
  echo Clonando maquina "%arg1%"
  vmrun -T ws clone "%RUTA%\%RPLANTILLA%\%PLANTILLA%"  "%RUTA%\%arg1%\%arg1%.vmx" full -cloneName="%arg1%.example.org"
  vmware.exe "%RUTA%\%arg1%\%arg1%.vmx"
  vmrun -T ws start "%RUTA%\%arg1%\%arg1%.vmx"
) ELSE (
  del /s /f /q "%RUTA%\%arg1%"
  rmdir "%RUTA%\%arg1%" /s /q
)
cd "%SCRIPTS%"
