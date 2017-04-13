::#########################################################
:: fichero Bat: 02-copy_folders_hd_backups.bat
:: Renombrar los folders, copiar los folders y borrar vieos folders
:: Metodo con bucle buscador de directorios y con llamadas a funciones
::    
::##########################################################


@echo off
cls
setlocal
::##############   Variables 
::----------------  directorio del bat y path del fichero actual
::----------------  nota:  fichero con path %~f0 directorio del fichero %~dp0


set Hdisk=C:
set documents=%Hdisk%\Users\jarmengo\Documents
set dropbox=%Hdisk%\Users\jarmengo\Dropbox


:: set diskBck=D:
set diskBck=E:
set workDir=%diskBck%\wrk_bckp
set prsnlDir=%diskBck%\prsnl_bckp
::  set zipProgram=%diskBck%\Zip7z

::---------------- directorios a no comprimir
		
set dirRepositorio=zz_repositorio
set dirOldBackups=zzz_olds_bck


::###############   Main

::----------------  Inicio del proceso, toma de hora de inicio

echo  Start procces day %date% and hour %time% 
		:: The format of %TIME% is HH:MM:SS,CS for example 23:59:59,99
set STARTTIME=%TIME%

cls

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
echo DURATION:  %DURATION% in centiseconds and in time format %DURATIONH%:%DURATIONM%:%DURATIONS%,%DURATIONHS%

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
set notFile=""
 
if not exist %workDir% ( 
			set notFile=%workDir%
			goto :No_fichero
)


if not exist %prsnlDir% (
			set notFile=%prsnlDir%
			goto :No_fichero 
)


:: if not exist %zipProgram% ( 			set notFile=%zipProgram%; 			goto :No_fichero  ) 

echo fin subroutina de Existsfiles
::  pause

goto:eof 

::---------------   Subroutina compWorkDir:  
::---------------		 Comprime del diectorio %workDir% todos los directorios en formato 7z 
::---------------		 menos los %dirOldBackups% y %dirRepositorio%. No devuelve nada 	

:compWorkDir		- funcion que comprime los directorios del wrk_bckp

title comprimiendo pst %workDir%

echo tendriamos que ir a %workDir%
%diskBck%
cd %workDir%
echo  Current dir "%CD%" 
:: pause
::-----  Bucle de busqueda de directorios y compresion de todos menos zz_dirs				
	
for /D %%d in (%workDir%\*.*) do ( 
	echo "%%d"
	  :: pause 
 	   for /D %%a in (%documents%\*.*) do (
			   if "%%~nd"=="%%~na" (
							:: echo Si existe 
						ren  "%%~nd" "%%~nd_old"
						PING 1.1.1.1 -n 1 -w 1000 >NUL
						echo "%%a"  "%%d"
						PING 1.1.1.1 -n 1 -w 1000 >NUL
						robocopy /e "%%a" "%%d"
						'xcopy /s /y /v /e "%%a" "%%d"
						PING 1.1.1.1 -n 1 -w 1000 >NUL
						echo Borrando "%%~nd_old"
						rd /s /q "%%~nd_old"
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
echo  Current dir "%CD%" 

::---- Bucle de busqueda de directorios y compresion de todos menos zz_dirs

for /D %%d in (%prsnlDir%\*.*) do ( 
	echo "%%d"
		:: pause 
 	   for /D %%a in (%dropbox%\*.*) do (
			   if "%%~nd"=="%%~na" (
							:: echo Si existe 
						ren  "%%~nd" "%%~nd_old"
						PING 1.1.1.1 -n 1 -w 1000 >NUL
						echo "%%a"  "%%d"
						PING 1.1.1.1 -n 1 -w 1000 >NUL
						robocopy /e "%%a" "%%d"
						PING 1.1.1.1 -n 1 -w 1000 >NUL
						echo Borrando "%%~nd_old"
						rd /s /q "%%~nd_old"
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
echo START TIME: %STARTTIME%
echo END TIME: %ENDTIME%



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