echo off
REM Autor: Ricardo David Carrillo Sanchez
REM Objetivo: Generar ambiente
SET "SCRIPTS=C:\Users\CARRILLO RICARDo\Documents\GitHub\rhce"
echo "Generando idm"
call clonar-idm.bat idm
echo "Generando acceso1"
call clonar-acceso1.bat acceso1
echo "Generando cliente1"
call clonar-cliente1.bat cliente1
echo "Generando cliente2"
call clonar-cliente2.bat cliente2
echo "Generando AD"
call clonar-ad.bat ad
