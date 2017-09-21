::#########################################################
:: fichero Bat: 00-copy_folders_hd_backups
:: Renombrar los folders, copiar los folders y borrar vieos folders
:: Metodo con bucle buscador de directorios y con llamadas a funciones
:: pruebas de defrag y cleanup
::    
::##########################################################


@echo off
cls
setlocal
::##############   Variables 
::----------------  directorio del bat y path del fichero actual
::----------------  nota:  fichero con path %~f0 directorio del fichero %~dp0
set verbose=0
set VRBS=.................... 




set Hdisk=C:
:: set documents=%Hdisk%\Users\jarmengo\Documents
:: set dropbox=%Hdisk%\Users\jarmengo\Dropbox
set programsPath=%Hdisk%\windows\SYSTEM32\


::  busca en que unidad logica esta el HD de backup
set diskBck=E:

if exist E:\prsnl_bckp set diskBck=E:
if exist F:\prsnl_bckp set diskBck=F:
if exist G:\prsnl_bckp set diskBck=G:


:: set workDir=%diskBck%\wrk_bckp
:: set prsnlDir=%diskBck%\prsnl_bckp
::  set zipProgram=%diskBck%\Zip7z

::---------------- directorios a no comprimir
		
:: set dirRepositorio=zz_repositorio
:: set dirOldBackups=zzz_olds_bck

set logfile=c:\temp\03-clean_defrag-log.txt


::###############   Main

::----------------  Inicio del proceso, toma de hora de inicio

echo  Start procces day %date% and hour %time% 
		:: The format of %TIME% is HH:MM:SS,CS for example 23:59:59,99
set STARTTIME=%TIME%

if exist %logfile%  del %logfile%
echo start  %STARTTIME%
echo start  %STARTTIME% >%logfile%


cls
					if %verbose% == 1 echo %VRBS%  Verbose activado 
					

					if %verbose% == 1 echo %VRBS%  fichero log en %logfile%
					pause



::---------------- Accion sobre HD de backup   Borrar definitivamente el disco duro
call:cleanupDiskBck

::---------------- Accion sobre HD de Backup    Defragmentar el HD
  
call:defragDiskBck
 
::---------------- Fin de compression: calculo de tiempo 

call:timeCalcul

::----------------  Report time

cls
rem outputing

echo STARTTIME: %DATE% %STARTTIME% 
echo ENDTIME:   %DATE% %ENDTIME% 
echo DURATION:  %DURATION% in centiseconds and in time format %DURATIONH%:%DURATIONM%:%DURATIONS%,%DURATIONHS%
echo DURATION:  %DURATION% in centiseconds and in time format %DURATIONH%:%DURATIONM%:%DURATIONS%,%DURATIONHS% >> %logfile% && type %logfile%

echo
echo final 

pause  

START notepad.exe %logfile%

endlocal
goto :EOF




: exit
::echo saliendo
exit



:: ---------------------------------------
::   Function section
:: ----------------------------------------



::---------------   Subroutina cleanupDiskBck:  
::---------------		 Deberia vaciar la recicle bin
::---------------		 	

:cleanupDiskBck		- Accion sobre HD de backup   Borrar definitivamente el disco duro

title Vaciando papelera de  %diskBck%

				if %verbose% == 1 echo %VRBS%   tendriamos que ir a %diskBck%
%diskBck%
cd %workDir%
echo Current dir "%CD%" 
 pause
::-----  Bucle de busqueda de directorios y compresion de todos menos zz_dirs				
	:: c:\windows\SYSTEM32\cleanmgr.exe /dF: 
	
	
	
if exist E:\prsnl_bckp c:\windows\SYSTEM32\cleanmgr.exe /dE: 
if exist F:\prsnl_bckp c:\windows\SYSTEM32\cleanmgr.exe /dF: 
if exist G:\prsnl_bckp c:\windows\SYSTEM32\cleanmgr.exe /dG:

:: pause 
goto:eof


::---------------   Subroutina defragDiskBck
::---------------		 defragmenta el disco duro de Backup 
::---------------		 menos el %dirRepositorio%. No devuelve nada 	         

:defragDiskBck		- Accion sobre HD de Backup    Defragmentar el HD

  
title Defragmentando %diskBck%


%Hdisk%
cd %programsPath%
echo  Current dir "%CD%" 


::---- Bucle de busqueda de directorios y compresion de todos menos zz_dirs

	defrag.exe %diskBck% /U /V 
	:: >> %logfile%
	:: >> %logfile% && type %logfile%

 pause 
goto:eof 


::---------------   Subroutina timeCalcul
::---------------     Toma el tiempo final del proceso y calcula duracion en centisegundos y en HH:MM:SS

:timeCalcul

set ENDTIME=%TIME%
::--------------- output as time
echo STARTTIME: %STARTTIME%
echo ENDTIME: %ENDTIME%



::--------------- convert STARTTIME and ENDTIME to centiseconds
set /A STARTTIMEC=(1%STARTTIME:~0,2%-100)*360000 + (1%STARTTIME:~3,2%-100)*6000 + (1%STARTTIME:~6,2%-100)*100 + (1%STARTTIME:~9,2%-100)
set /A ENDTIMEC=(1%ENDTIME:~0,2%-100)*360000 + (1%ENDTIME:~3,2%-100)*6000 + (1%ENDTIME:~6,2%-100)*100 + (1%ENDTIME:~9,2%-100)

::--------------- calculating the duratyion is easy
set /A DURATION=%ENDTIMEC%-%STARTTIMEC%

::--------------- now break the centiseconds down to hors, minutes, seconds and the remaining centiseconds
set /A DURATIONH=%DURATION% / 360000
set /A DURATIONM=(%DURATION% - %DURATIONH%*360000) / 6000
set /A DURATIONS=(%DURATION% - %DURATIONH%*360000 - %DURATIONM%*6000) / 100
set /A DURATIONHS=(%DURATION% - %DURATIONH%*360000 - %DURATIONM%*6000 - %DURATIONS%*100)

goto:eof