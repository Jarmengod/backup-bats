:: fichero Bat: 
:: Copy el fichero notes_prsnl.txt en disco de backup, google drive and ubuntu one

:: rev 2.0 copia en directorio Ubuntu One pasa a ser comentario (Ubuntu One a desaparecido)
@ECHO OFF


set verbose=0
set VRBS=.................... 



set fichero=notes_prsnl
set folder=backup_hd
set folder2=Google Drive
set folder3=Ubuntu One

:: echo prueba directorio ubuntu one 
:: dir "C:\Users\jarmengo\Ubuntu One"
if %verbose% == 1 echo %VRBS%  Verbose activado

cls
title Backup fichero de Notas personales
echo.
echo. 
echo Comprobando existencia de fichero %fichero%

if not exist "C:\Users\jarmengo\Dropbox\notes_prsnl.txt" goto :No_fichero
echo Existe fichero 
echo. 
echo. 


echo Iniciando copia fichero %fichero% en folder %folder% 
echo.
if exist "E:\prsnl_bckp\notes_prsnl.txt" del "E:\prsnl_bckp\notes_prsnl.txt"
copy "C:\Users\jarmengo\Dropbox\notes_prsnl.txt"  E:\prsnl_bckp\notes_prsnl.txt

pause
echo.
echo.
echo.

echo Iniciando copia fichero %fichero% en folder %folder2% 
echo. 
echo.
echo.

if exist "C:\Users\jarmengo\Google Drive\notes_prsnl.txt" del "C:\Users\jarmengo\Google Drive\notes_prsnl.txt"
copy C:\Users\jarmengo\Dropbox\notes_prsnl.txt  "C:\Users\jarmengo\Google Drive\notes_prsnl.txt"
pause
goto :exit

:: pause
:: echo.
:: echo.
:: echo.
:: echo Iniciando copia fichero %fichero% en folder %folder3% 
:: if exist "C:\Users\jarmengo\Ubuntu One\notes_prsnl.txt" del "C:\Users\jarmengo\Ubuntu One\notes_prsnl.txt" 
:: copy C:\Users\jarmengo\Dropbox\notes_prsnl.txt  "C:\Users\jarmengo\Ubuntu One\notes_prsnl.txt"
:: pause 
:: goto :exit

:No_fichero
echo No existe fichero "C:\Users\jarmengo\Dropbox\notes_prsnl.txt"
pause

: exit
echo saliendo
exit

:: fin