echo off
REM Autor: Ricardo David Carrillo Sanchez
REM Objetivo: Importar OVA en Workstation
SET "RUTA=F:\My Virtual  Machines"
REM SET "SCRIPTS=C:\Users\CARRILLO RICARDo\Documents\scripts\"
SET "SCRIPTS=C:\Users\CARRILLO RICARDo\Documents\GitHub\rhce"
SET "OVABIN=C:\Program Files (x86)\VMware\VMware Workstation\OVFTool\"
SET "OVAPATH=F:\ovas\"
cd "%SRIPTS%"
%OVABIN%ovftool.exe -tt=vmx  %OVAPATH%\webmail-inter-n2.ova %RUTA%
cd "%SCRIPTS%"
