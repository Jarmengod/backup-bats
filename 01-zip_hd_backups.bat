::#########################################################
:: fichero Bat: 01-zip_hd_backups.bat
:: comprime en formato 7z los ficheros del disco duro de wrk 
:: Metodo con bucle buscador de directorios
:: rev 2: con llamadas a funciones 
::##########################################################


@echo off
cls
setlocal
::##############   Variables 
::----------------  directorio del bat y path del fichero actual
::----------------  nota:  fichero con path %~f0 directorio del fichero %~dp0
set true=1
set false=0

set verbose=%true%
set VRBS=.................... 
set reporttxt=%false%


set diskBck=E:

if exist E:\prsnl_bckp set diskBck=E:
if exist F:\prsnl_bckp set diskBck=F:
if exist G:\prsnl_bckp set diskBck=G:


:: set diskBck=F:
set workDir=%diskBck%\wrk_bckp
set prsnlDir=%diskBck%\prsnl_bckp
set zipProgram=%diskBck%\Zip7z




::---------------- directorios a no comprimir
		
set dirRepositorio=zz_repositorio
set dirOldBackups=zzz_olds_bck

set logfile=c:\temp\01-clean_defrag-log.txt

::###############   Main

::----------------  Inicio del proceso, toma de hora de inicio

echo  Start procces day %date% and hour %time% 
		:: The format of %TIME% is HH:MM:SS,CS for example 23:59:59,99
set STARTTIME=%TIME%
echo start  %STARTTIME% 
					if %reporttxt% EQU %true% echo start %STARTTIME% >%logfile%	

					if %verbose% == 1 echo %VRBS%  Verbose activado 


::----------------  Accion de comprobar que existen los directorios
call:Exitsfiles

::---------------- Accion sobre directorio de workDir
call:compWorkDir

::---------------- Accion sobre directorio de workDir   
  
call:compPrsnlDir
 
::---------------- Fin de compression: calculo de tiempo 

call:timeCalcul

::----------------  Report time

cls
rem outputing

echo STARTTIME: %DATE% %STARTTIME% 
echo ENDTIME:   %DATE% %ENDTIME% 
echo DURATION:  %DURATION% in centiseconds and in time format %DURATIONH%:%DURATIONM%:%DURATIONS%,%DURATIONHS% >> %logfile% && type %logfile%

echo
echo final 

pause  

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
echo inicio subroutina Exitsfiles 
			if %reporttxt% EQU %true%  echo inicio subroutina Exitsfiles >> %logfile% && type %logfile%
set notFile=""
 
if not exist %workDir% ( 
			set notFile=%workDir%
			goto :No_fichero
)


if not exist %prsnlDir% (
			set notFile=%prsnlDir%
			goto :No_fichero 
)


if not exist %zipProgram% (
			set notFile=%zipProgram%
			goto :No_fichero 
) 

echo fin subroutina de Existsfiles
::  pause

goto:eof 

::---------------   Subroutina compWorkDir:  
::---------------		 Comprime del diectorio %workDir% todos los directorios en formato 7z 
::---------------		 menos los %dirOldBackups% y %dirRepositorio%. No devuelve nada 	

:compWorkDir		- funcion que comprime los directorios del wrk_bckp

title comprimiendo pst %workDir%

			if %verbose% == 1 echo %VRBS%  tendriamos que ir a %workDir%
%diskBck%
cd %workDir%
			if %verbose% == 1 echo %VRBS%  Current dir "%CD%" 
:: pause
::-----  Bucle de busqueda de directorios y compresion de todos menos zz_dirs				
					
for /D %%d in (*.*) do ( 
				if %verbose% == %true% echo %VRBS%  %%d i  %%~nd 
	  if not "%%d"=="%dirOldBackups%" (
		if not "%%d"=="%dirRepositorio%" (
			echo comprimiendo %%d con %zipProgram%
						if %reporttxt% EQU %true% ( echo comprimiendo %%d con %zipProgram% >> %logfile% && type %logfile% )
 		  
				if %reporttxt% EQU %false%	( %zipProgram%\7z a -t7z %%~nd.7z %%d )
				)
			
		
		
		)
				
		)
	  
  
:: pause 
goto:eof


::---------------   Subroutina compPrsnlDir
::---------------		 Comprime del diectorio %prsnlDir% todos los directorios en formato 7z 
::---------------		 menos el %dirRepositorio%. No devuelve nada 	         

:compPrsnlDir		- funcion que comprime los directorios del prsn_bckp

  
title comprimiendo pst %prsnlDir%

cd %prsnlDir%
				if %verbose% == 1 echo %VRBS%    Current dir "%CD%" 

::---- Bucle de busqueda de directorios y compresion de todos menos zz_dirs

for /D %%x in (*) do ( 
		if not "%%x"=="%dirOldBackups%" (
			echo  comprimiendo %%x 	 >> %logfile% && type %logfile%
			 if %reporttxt% EQU %true% ( %zipProgram%\7z a -t7z %%x.7z %%x >> %logfile% && type %logfile% )
			 if %reporttxt% EQU %false%	(  %zipProgram%\7z a -t7z %%x.7z %%x )
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