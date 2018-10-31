echo off
REM Autor: Ricardo David Carrillo Sanchez
REM Objetivo: Generar ambiente
SET "RUTA=F:\My Virtual  Machines"
REM SET "SCRIPTS=C:\Users\CARRILLO RICARDo\Documents\scripts\"
SET "SCRIPTS=C:\Users\CARRILLO RICARDo\Documents\GitHub\rhce"
cd "%SCRIPTS%"

REM echo "Borrando idm"
del /s /f /q "%RUTA%\idm"
rmdir "%RUTA%\idm" /s /q

REM echo "Borrando acceso1"
del /s /f /q "%RUTA%\acceso1"
rmdir "%RUTA%\acceso1" /s /q

REM echo "Borrando cliente1"
del /s /f /q "%RUTA%\cliente1"
rmdir "%RUTA%\cliente1" /s /q

REM echo "Borrando cliente2"
del /s /f /q "%RUTA%\cliente2"
rmdir "%RUTA%\cliente2" /s /q

echo "Borrando AD"
del /s /f /q "%RUTA%\ad"
rmdir "%RUTA%\ad" /s /q
cd "%SCRIPTS%"
