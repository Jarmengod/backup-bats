::#########################################################
:: fichero Bat: 19-zip-pst-onedrive.bat
:: comprime en formato zip los ficheros pst del onedrive - HP
:: Metodo con bucle buscador de directorios
:: rev 2: con llamadas a funciones 
::##########################################################


:: 
@echo off
cls
setlocal
::##############   Variables 
::-------------------  directorio del bat y path del fichero actual
::-------------------  nota:  fichero con path %~f0 directorio del fichero %~dp0

set diskBck="C:\Users\jarmengo\OneDrive - Hewlett-Packard"
set workDir="%diskBck%\emails
set prsnlDir=%diskBck%\emails_nowork
set zipProgram="C:\Program Files\7-Zip\"



::###############   Main

::-------------------  Inicio del proceso, toma de hora de inicio

echo  Start procces day %date% and hour %time% 
rem The format of %TIME% is HH:MM:SS,CS for example 23:59:59,99
set STARTTIME=%TIME

::---------------  Compresion pst de emails - trabajo 

call:comprimirEmails
 
::---------------  Compresion pst de emails - trabajo 

call:comprimirEmailsNOWork

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


: exit
::echo saliendo
exit



:: ---------------------------------------
::   Function section
:: ----------------------------------------

::-------------################################################################

:comprimirEmails		- Comprime los pst del folder emails de 
cls


title comprimiendo pst %workDir%


cd %workDir%

::---------------  Borrar los zip

if exist *.zip del *.zip
				
::---------------  Busca pst y comprime

for %%x in (*.pst) do ( 
  echo  comprimiendo %%x
  %zipProgram%\7z a -tzip %%~nx.zip %%x
  echo comprimido %%x en %%~nx.zip 

  )

::---------------  Borra los pst 

if exist *.pst del *.pst  
goto:eof


::-------------################################################################

:comprimirEmailsNOWork 			- Comprime los pst del folder email_nowork

title comprimiendo pst %prsnlDir%

cd %prsnlDir%

::---------------  Borrar los zip

if exist *.zip del *.zip
				
::---------------  Busca pst y comprime

for %%x in (*.pst) do ( 
  echo  comprimiendo %%x
  %zipProgram%\7z a -tzip %%~nx.zip %%x
  echo comprimido %%x en %%~nx.zip 

  )

::---------------  Borra los pst 

if exist *.pst del *.pst  
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
