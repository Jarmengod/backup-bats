::#########################################################
:: fichero Bat: 125-zip-onenote_bck-onedrive.bat
:: comprime en formato zip los directorios onenote bck del Documents 
:: y copio los zips en Onedrive Hp Inc
:: Metodo con bucle buscador de directorios y llamada a funciones 
::##########################################################


:: 
@echo off
cls
setlocal
::##############   Variables 

::-------------------  

set true=1
set false=0

set verbose=%true%
set VRBS=.................... 
set reporttxt=%false%
set filename=%CD%

::------------------- Variables de Directorios

set DirOriginal="C:\Users\jarmengo\Documents\98-onenote-backup"
set DirTemp="C:\Temp"
set NameDirTemp=%DirTemp%\98-bck
set prsnlDir=%diskBck%\emails_nowork
set DirFinal="C:\Users\jarmengo\Onedrive - HP Inc\98-onenote-backup"
set zipProgram="C:\Program Files\7-Zip\"
set actualDir=%cd%


::###############   Main

::-------------------  Inicio del proceso, toma de hora de inicio

echo  Start procces day %date% and hour %time% 
rem The format of %TIME% is HH:MM:SS,CS for example 23:59:59,99
set STARTTIME=%TIME%

					if %verbose% == 1 echo %VRBS%  Verbose activado 

::---------------- Comprobar directorios y sino crear

call:ifnotexist

::---------------  Copiar de Directorio original al directorio de trabajo  

call:copiarDirectorioTrabajo

::---------------  Compresion pst de emails - trabajo 

					if %verbose% == 1 echo %VRBS%  Llamada a comprimir
call:comprimir
					if %verbose% == 1 echo %VRBS%  fin llamada comprimir

::---------------  Mover los ficheros zip a Directorio final  

					if %verbose% == 1 echo %VRBS%  Llamada a Move a directoriofinal
:: call:moveDirFinal
					if %verbose% == 1 echo %VRBS%  fin llamada Move a directoriofinal

					
::--------------- vaciado papelera de reciclado 

					if %verbose% == 1 echo %VRBS%  Llamada a emptyRecycleBin
call:emptyRecycleBin
					if %verbose% == 1 echo %VRBS%  fin llamada a emptyRecycleBin



::--------------- Fin de compression: calculo de tiempo 

call:timeCalcul

::---------------  Report time

cls
rem outputing

echo STARTTIMD: %DATE% %STARTTIME% 
echo ENDTIMD:   %DATE% %ENDTIME% 
echo DURATION:  %DURATION% in centiseconds and in time format %DURATIONH%:%DURATIONM%:%DURATIONS%,%DURATIONHS%

echo
echo final 

pause  

endlocal
goto :EOF
:: ----------------   #########  Fin progrma MAin ##########------------
:: ---------------------------------------------------------------------

:No_fichero
echo No existe directorio %notFile%
pause


: exit
::echo saliendo
exit



:: ---------------------------------------
::   Function section
:: ----------------------------------------

::-------------###########################################
:ifnotexist             - Comprueba directorios
title  %filename%   section ifnotexist

					if %verbose% == 1 echo %VRBS%  Estoy en ifnoexist 

if not exist %DirOriginal% ( 
			set notFile=%DirOriginal%
			goto :No_fichero
)

if not exist %DirFinal% mkdir %DirFinal%

if not exist %NameDirTemp% mkdir %NameDirTemp%

goto:eof

::-------------################################################################

:copiarDirectorioTrabajo
cls
title  %filename%     section copiarDirectorioTrabajo
					if %verbose% == 1 echo %VRBS%  Copian en directorio temp

robocopy /MIR 	%DirOriginal% 	%NameDirTemp%			
		

goto:eof

::-------------################################################################
:comprimir		- Comprime los directorios del folder auxiliar
cls
title %filename%  comprimiendo %NameDirTemp%  
					if %verbose% == 1 echo %VRBS%  Estoy en comprimirDirectorios


cd %NameDirTemp%

					if %verbose% == 1 echo %VRBS%  Estoy en directorio %cd%

for /D %%d in (*.*) do (
					if %verbose% == 1 echo directorio %%d  comprimido con nombre %%~nd.zip
	:: %zipProgram%\7z a -tzip %%~nd.zip %%d
	pause
	                     )
:: pause				
cd %actualDir%	

goto:eof

::-------------################################################################

:moveDirFinal
::---------------  Mover los fichero zip del temp al onedrive - hp
cls
title %filename%  moviendo zip a %DirFinal%

cd %NameDirTemp%
			if %verbose% == 1 echo %VRBS%  Estoy en directorio %cd%

robocopy %NameDirTemp% %DirFinal% *.zip /MOV

cd ..

rd /S /Q %NameDirTemp%


cd %actualDir%	

goto:eof


	

::-------------################################################################
:emptyRecycleBin                Vacia la papelera de reciclado 
cls 
title  %filename%  vaciando papelera de reciclado (Recycle bin)

del /q /s %systemdrive%\$Recycle.bin\*


goto:eof


::-------------################################################################

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
