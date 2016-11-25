:: fichero Bat: 01-zip_hd_backups.bat
:: comprime en formato 7z los ficheros del disco duro de wrk 
:: Metodo con bucle buscador de directorios

:: 
@echo off
cls
setlocal

		::  directorio del bat y path del fichero actual
		::  fichero con path %~f0 directorio del fichero %~dp0

set diskBck=D:
set workDir=%diskBck%\wrk_bckp
set prsnlDir=%diskBck%\prsnl_bckp
set zipProgram=%diskBck%\Zip7z

set dirRepositorio=zz_repositorio
set dirOldBackups=zzz_olds_bck

::  Inicio del proceso, toma de hora de inicio

echo  Start procces day %date% and hour %time% 
		:: The format of %TIME% is HH:MM:SS,CS for example 23:59:59,99
set STARTTIME=%TIME%


cls


::####  Accion sobre directorio de workDir

title comprimiendo pst %workDir%

echo tendriamos que ir a %workDir%
%diskBck%
cd %workDir%
echo  Current dir "%CD%" 
:: pause
::####  Bucle de busqueda de directorios y compresion de todos menos zz_dirs				
					
for /D %%d in (*.*) do ( 
	 
  if not "%%d"=="%dirOldBackups%" (
		if not "%%d"=="%dirRepositorio%" (
			echo comprimiendo %%d con %zipProgram%
 		    %zipProgram%\7z a -t7z %%~nd.7z %%d
		) 
     		
    ) 
)
:: pause 

::####  Accion sobre directorio de workDir   
  
title comprimiendo pst %prsnlDir%

cd %prsnlDir%
echo  Current dir "%CD%" 

::#### Bucle de busqueda de directorios y compresion de todos menos zz_dirs

for /D %%x in (*) do ( 
		if not "%%x"=="%dirOldBackups%" (
			echo  comprimiendo %%x 	
			%zipProgram%\7z a -t7z %%x.7z %%x
			) 
		  )
	
 pause 
 
 
::####  Fin de compression: calculo de tiempo 
 
set ENDTIME=%TIME%

rem output as time
echo STARTTIME: %STARTTIME%
echo ENDTIME: %ENDTIME%



rem convert STARTTIME and ENDTIME to centiseconds
set /A STARTTIMEC=(1%STARTTIME:~0,2%-100)*360000 + (1%STARTTIME:~3,2%-100)*6000 + (1%STARTTIME:~6,2%-100)*100 + (1%STARTTIME:~9,2%-100)
set /A ENDTIMEC=(1%ENDTIME:~0,2%-100)*360000 + (1%ENDTIME:~3,2%-100)*6000 + (1%ENDTIME:~6,2%-100)*100 + (1%ENDTIME:~9,2%-100)

rem calculating the duratyion is easy
set /A DURATION=%ENDTIMEC%-%STARTTIMEC%

rem now break the centiseconds down to hors, minutes, seconds and the remaining centiseconds
set /A DURATIONH=%DURATION% / 360000
set /A DURATIONM=(%DURATION% - %DURATIONH%*360000) / 6000
set /A DURATIONS=(%DURATION% - %DURATIONH%*360000 - %DURATIONM%*6000) / 100
set /A DURATIONHS=(%DURATION% - %DURATIONH%*360000 - %DURATIONM%*6000 - %DURATIONS%*100)

cls
rem outputing

echo STARTTIME: %DATE% %STARTTIME% 
echo ENDTIME:   %DATE% %ENDTIME% 
echo DURATION:  %DURATION% in centiseconds and in time format %DURATIONH%:%DURATIONM%:%DURATIONS%,%DURATIONHS%

echo
echo final 

pause  

endlocal
goto :EOF

:No_fichero
::echo No existe fichero "C:\Users\jarmengo.AUTH\Dropbox\notes_prsnl.txt"
:: pause

: exit
::echo saliendo
exit

:: fin