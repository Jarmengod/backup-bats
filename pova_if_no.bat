:: ####################
:: prueba de leer fichero los 
::
::#########################
@echo off
cls
setlocal EnableDelayedExpansion

set true=1
set false=0
set reporttxt=0

echo %reporttxt%


if %reporttxt% EQU %true% (
		echo "esto funciona"
		) else (
		echo no report
		)

 
endlocal

:proceso [%1 - param]
	echo ###########inside proceso procedimiento
	set vari=%~1
    echo entra %1% 
							::	set vari=%1%
		set comentario=%vari:~0,2%
					:: echo la variable a es %1%  
						:: echo la variable b es %2%
	 echo variable vari1  %vari%
	echo variable comentario %comentario%
 if %comentario%==%comentVariable% (
echo linea de comentario %comentario% y de variable %1%
) else (
		for /F "tokens=1-2 delims=;" %%a in ("%vari%") do (
			ROBOCOPY  %%a %%b  /mir
			:: echo ro %1% mir
			echo comentario #%comentario%#
			echo #####################
			)
		)


:: pause

:: echo #########################################
 
cls

goto:eof

:: ROBOCOPY %%a %%b /mir			

:comment
set directorio=C:\Users\jarmengo\Documents\15-git\backup-bats
set file=%directorio%\fichero.csv
set vari=##
set comentVariable=::

if not exist %file% (
	echo no existe el fichero %file%
	goto :No_fichero
) 
:: echo comprobacion fichero
:: pause
 

cls
:: echo prueba de dos variables por linea
:: echo variable %vari%

:: pause
cls
for /F "tokens=*" %%a in (%file%) do (
	echo variable 1 %%a 
	call:proceso "%%a"
	)
		
 
pause

:: endlocal
goto:eof
