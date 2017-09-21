::#########################################################
:: fichero Bat: 09-FileSyncDos.bat
:: mirroring de directorios usando Robocopy /mir
:: Metodo con bucle buscador de directorios
:: y con llamadas a funciones 
::##########################################################
::  log 
::  170504 Directorios de trabajo principal en OneDrive - Hewlett-Packard 
::         cambio en variable directorio, cambio en fichero.csv
::
::#############################################################


:: 
@echo off
cls
setlocal EnableDelayedExpansion
::##############   Variables 
::-------------------  directorio del bat y path del fichero donde estan los directorios a compararactual
::-------------------  

set verbose=0
set VRBS=.................... 

set true=1
set false=0
set reporttxt=0


set diskBck=E:

if exist E:\prsnl_bckp set diskBck=E:
if exist F:\prsnl_bckp set diskBck=F:
if exist G:\prsnl_bckp set diskBck=G:


set workDir=%diskBck%\wrk_bckp
set prsnlDir=%diskBck%\prsnl_bckp

:: set documents=%Hdisk%"\Users\jarmengo\OneDrive - Hewlett-Packard"
::  set dropbox=%Hdisk%\Users\jarmengo\Dropbox

:: if exist E:\prsnl_bckp set Hdisk=E:
::  if exist F:\prsnl_bckp set Hdisk=F:

:: set documents=%Hdisk%"\Users\jarmengo\OneDrive - Hewlett-Packard"
:: set dropbox=%Hdisk%\Users\jarmengo\Dropbox

echo el disco de backup es %diskBck% y el directorio de fichero de trabajo es  %workDir%
echo el disco de backup es %diskBck% y el directorio de fichero personal es %prsnlDir%


endlocal
goto :EOF



:USE_F
echo  trabajando con F
set Hdisk=F:
goto:eof
