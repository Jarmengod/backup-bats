:#########################################################
:: fichero Bat: 08-fileSync.bat
:: Ejecuta FreefileSync tomando los ficheros *.ffs_batch
:: Metodo con bucle buscador de directorio
:: rev 2: con llamadas a funciones 
::##########################################################
:: log
:: issue 170504  Nuevo directorio de trabajo principal Onedrive - Hewlett-Packard
::                cambio variable ffsbatchDir
:: issue 180801  quitar evernote y eclipse  poner 15-git\backup-bats


@echo off
cls
setlocal
::##############   Variables 
::---------------   directorio del bat y path del fichero actual
::---------------   nota:  fichero con path %~f0 directorio del fichero %~dp0

set verbose=0
set VRBS=.................... 


set diskBck=C:
set FFSdir="C:\Program Files\FreeFileSync"

if exist E:\prsnl_bckp set ffsbatchDir="C:\Users\jarmengo\OneDrive - Hewlett-Packard\15-git\backup-bats\E_ffs_bat"
if exist F:\prsnl_bckp set ffsbatchDir="C:\Users\jarmengo\OneDrive - Hewlett-Packard\15-git\backup-bats\F_ffs_bat"
if exist G:\prsnl_bckp set ffsbatchDir="C:\Users\jarmengo\OneDrive - Hewlett-Packard\15-git\backup-bats\G_ffs_bat"
:: set ffsbatchDir="C:\Users\jarmengo\OneDrive - Hewlett-Packard\15-git\backup-bats"
set zipProgram=%diskBck%\Zip7z
:: set prsnlDir=%diskBck%\prsnl_bckp
set logfile=c:\temp\08-fileSync-log.txt





::###############   Main

::---------------   Inicio del proceso, toma de hora de inicio

echo  Start procces day %date% and hour %time% 
		:: The format of %TIME% is HH:MM:SS,CS for example 23:59:59,99
set STARTTIME=%TIME%
echo start  %STARTTIME% >%logfile%


cls

					if %verbose% == 1 echo %VRBS%  Verbose activado 

if exist %logfile%  del %logfile%

::----------------  Accion de comprobar que existen los directorios
call:Exitsfiles


::--------------- sincronizacion de batch
call:syncFile


 
::---------------  Fin de compression: calculo de tiempo 

call:timeCalcul

::---------------   Report time

cls
rem outputing

echo STARTTIME: %DATE% %STARTTIME% 
echo ENDTIME:   %DATE% %ENDTIME% 
echo DURATION:  %DURATION% in centiseconds and in time format %DURATIONH%:%DURATIONM%:%DURATIONS%,%DURATIONHS% >> %logfile% && type %logfile%

echo
echo final 

pause  

START notepad.exe %logfile%

endlocal
goto :EOF

:No_fichero
echo No existe directorio %notFile%
pause


: exit
::echo saliendo
exit

:: ---------------------------------------
::   Function section
:: ----------------------------------------


::---------------   Subroutina Exitsfiles:  
::---------------      comprueba que los directorios a trabajar existen, devuelve el directorio no existente 

:Exitsfiles          - comprobacion de que existen directorios 

title Comprobando directorios 

echo inicio subroutina Exitsfiles >> %logfile% && type %logfile%
set notFile=""
 
if not exist %FFSdir% ( 
			set notFile=%FFSdir%
			goto :No_fichero
)


if not exist %ffsbatchDir% (
			set notFile=%ffsbatchDir%
			goto :No_fichero 
)


echo fin subroutina de Existsfiles
::  pause

goto:eof 
		
::---------------   Subroutina syncFile
::---------------     Subroutina que toma los ficheros ffs_batch de ffsbatchDir y los ejecuta con FreeFileSync
::---------------     La accion final es sincronizar directorios   

:syncFile		

title sincronizando folders 

echo tendriamos que ir a %ffsbatchDir%
%diskBck%
cd %ffsbatchDir%
					if %verbose% == 1 echo %VRBS%  Current dir "%CD%" 
:: pause
::-----  Bucle de busqueda de directorios y compresion de todos menos zz_dirs				
					
for %%f in (*.ffs_batch) do ( 
	 
 			echo sincronizando %%f con FreeFileSyn
 		    %FFSdir%\FreeFileSync.exe %%f >> %logfile% && type %logfile%
		) 
     		
    ) 
)
:: pause 
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