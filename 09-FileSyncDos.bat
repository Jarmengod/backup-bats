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


:: set directorio=C:\Users\jarmengo\Documents\15-git\backup-bats
set directorio=C:\Users\jarmengo\OneDrive - Hewlett-Packard\15-git\backup-bats
set dirtemp=C:\temp

if exist E:\prsnl_bckp set other="%directorio%\diskE_fichero.csv"
if exist F:\prsnl_bckp set other="%directorio%\diskF_fichero.csv"
if exist G:\prsnl_bckp set other="%directorio%\diskG_fichero.csv"

:: set other="%directorio%\fichero.csv"
set file=%dirtemp%\fichero.csv
set vari=00
set comentVariable=##
set logfile=c:\temp\09-FileSyncDos_log.txt



::###############   Main

::-------------------  Inicio del proceso, toma de hora de inicio

echo  Start procces day %date% and hour %time% 
rem The format of %TIME% is HH:MM:SS,CS for example 23:59:59,99
set STARTTIME=%TIME%

if exist %logfile%  del %logfile%
if exist %file% del %file%
echo start  %STARTTIME% 
					if %reporttxt% EQU %true% echo start %STARTTIME% >%logfile%

					if %verbose% == 1 echo %VRBS%  Verbose activado

					if %verbose% == 1 echo %VRBS%  el fichero csv es el %other%
					if %verbose% == 1 echo %VRBS%  y ira a %file%

copy %other% %file%


echo   WARNING:  Conecta el HD externo
				if %verbose% == 1 echo %VRBS%  fichero config en %file%  
				if %verbose% == 1 echo %VRBS%  y en variable other %other%
pause

::---------------  copiar pst de emails - trabajo 

call:ExistFileCSV
 
::---------------  comprobar los directorios del fichero 

CLS
echo fichero csv de configuracion %file%
				if %verbose% == 1 echo %VRBS% Inicio bucle de recogida info fichero config
				if %verbose% == 1 pause
for /F "tokens=*" %%a in (%file%) do (
				if %verbose% == 1 echo %VRBS% variable 1 %%a 
				if %verbose% == 1 pause
	call:proceso "%%a"
	CLS
	)
		
del %file%
::--------------- Fin de compression: calculo de tiempo 

call:timeCalcul

::---------------  Report time


cls
rem outputing

echo START BAT TIME: %DATE% %STARTTIME% 
echo END BAT TIMD:   %DATE% %ENDTIME% 
echo DURATION BAT:  %DURATION% in centiseconds and in time format %DURATIONH%:%DURATIONM%:%DURATIONS%,%DURATIONHS% >> %logfile% && type %logfile%

echo
echo final 

pause  

if %reporttxt% EQU %true% (START notepad.exe %logfile% )

endlocal

goto :EOF

:No_fichero
echo No existe el fichero csv con los datos %notFile%
pause

:exit
:: echo saliendo
exit

::---------------------------
::  Function section 
:: --------------------------

::---------------------  subroutina ExistFileCSV
::  -----------    comprueba que el fichero existe
:ExistFileCSV     - comprueba que tenemos el fichero de directorios a revisar
CLS
title Comprobando fichero csv
echo inicio subroutina ExistFileCSV
set notFile=""

if not exist %file% (
	set notFile=%file%
	goto :No_fichero
) 
			if %verbose% == 1 pause
goto:eof

::---------------------  subroutina proceso
::  -----------    compruebahace mirror 
::	----------        le pasa una linea del fichero si nos es comentario hace el robocopy /mir

:proceso [%1 - param]
	echo ###########inside proceso procedimiento
	set vari=%~1
    echo entra %1% 
							::	set vari=%1%
		set comentario=%vari:~0,2%
						if %verbose% == 1 echo %VRBS% la variable a es %1%  
						if %verbose% == 1 echo %VRBS% la variable b es %2%
						if %verbose% == 1 echo %VRBS% variable vari1  %vari%
						if %verbose% == 1 echo %VRBS% variable comentario %comentario%
						if %verbose% == 1 pause
 if %comentario%==%comentVariable% (
echo linea de comentario %comentario% y de variable %1%
) else (
		for /F "tokens=1-2 delims=;" %%a in ("%vari%") do (
			echo  copi from %%a   to %%b 
						if %verbose% == 1  pause
			if %reporttxt% EQU %true% (
				ROBOCOPY  "%%a" "%%b"  /mir >> %logfile%
			) else ( 
				ROBOCOPY  "%%a" "%%b"  /mir)
				   )	
			

			
			echo comentario #%comentario%#
			echo #####################
			
			if %verbose% == 1 echo %VRBS% fin del ROBOCOPY MIR
			if %verbose% == 1 pause
			
			)
		)

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
