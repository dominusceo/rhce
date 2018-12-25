echo off
REM Autor: Ricardo David Carrillo Sanchez
REM Goal: Import  OVAfir on vmware Workstation
SET "RUTA=F:\My Virtual Machines"
REM SET "SCRIPTS=C:\Users\CARRILLO RICARDo\Documents\scripts\"
SET "SCRIPTS=C:\Users\CARRILLO RICARDo\Documents\GitHub\rhce\recursos\scripts"
SET "OVABIN=C:\Program Files (x86)\VMware\VMware Workstation\OVFTool\"
SET "OVAPATH=F:\ovas\"
SET "OVATPL=template.ova"
cd "%SRIPTS%"
%OVABIN%ovftool.exe -tt=vmx  %OVAPATH%\%OVATPL% %RUTA%
cd "%SCRIPTS%"
c:\Program Files (x86)\VMware\VMware Workstation\OVFTool>
