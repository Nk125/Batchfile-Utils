@echo off
chcp 1252 1>nul 2>nul
title NK125 Eraser v1.0
setlocal enabledelayedexpansion enableextensions
echo NK125 Eraser
:prompt
set /p "dir=Ingresa el directorio a eliminar: "
dir !dir! 1>nul 2>nul
if "!errorlevel!" NEQ "0" (
echo Ingrese un directorio válido
goto prompt
)
pushd "%dir%"
echo Contando archivos...
for /f "tokens=* delims=" %%A in ('dir /a-d /b /s ^| find /v /c ""') do set filecount=%%A
if "!filecount!"=="0" (
echo No se encontró algún archivo en la carpeta.
goto dir
)
echo Borrando...
title Borrando [!filecount!] archivos
call :initProgressBar "/" " "
for /F "tokens=* delims=" %%b in ('dir * /a-d /b /s') do (
set /a dproc+=1
del "%%b" /F /S /Q 1>nul 2>&1
set /a total=100*dproc/filecount
call :drawProgressBar !total! "Total Borrado: !dproc!"
)
call :finalizeProgressBar
echo.
:dir
echo Contando Directorios...
for /f "tokens=* delims=" %%C in ('dir /a:d /b ^| find /v /c ""') do set dircount=%%C
if "!dircount!"=="0" (
echo No se encontró algún directorio en la carpeta.
goto fn
)
echo Borrando Directorios...
title Borrando [!dircount!] directorios.
call :initProgressBar "/" " "
for /F "tokens=* delims=" %%d in ('dir * /a:d /b') do (
set /a dirproc+=1
rd /S /Q "%%d" 1>nul 2>&1
set /a totaldir=100*dirproc/dircount
call :drawProgressBar !totaldir! "Total Borrado: !dirproc!"
)
call :finalizeProgressBar
echo.
:fn
title NK125 Eraser v1.0
popd
echo Finalizado, presione cualquier tecla para cerrar la ventana
pause > nul
exit
:drawProgressBar value [text]
    if "%~1"=="" goto :eof
    if not defined pb.barArea call :initProgressBar
    setlocal enableextensions enabledelayedexpansion
    set /a "pb.value=%~1 %% 101", "pb.filled=pb.value*pb.barArea/100", "pb.dotted=pb.barArea-pb.filled", "pb.pct=1000+pb.value"
    set "pb.pct=%pb.pct:~-3%"
    if "%~2"=="" ( set "pb.text=" ) else ( 
        set "pb.text=%~2%pb.back%" 
        set "pb.text=!pb.text:~0,%pb.textArea%!"
    )
    <nul set /p "pb.prompt=[!pb.fill:~0,%pb.filled%!!pb.dots:~0,%pb.dotted%!][ %pb.pct%%% ] %pb.text%!pb.cr!"
    endlocal
    goto :eof

:initProgressBar [fillChar] [dotChar]
    if defined pb.cr call :finalizeProgressBar
    for /f %%a in ('copy "%~f0" nul /z') do set "pb.cr=%%a"
    if "%~1"=="" ( set "pb.fillChar=#" ) else ( set "pb.fillChar=%~1" )
    if "%~2"=="" ( set "pb.dotChar=." ) else ( set "pb.dotChar=%~2" )
    set "pb.console.columns="
    for /f "tokens=2 skip=4" %%f in ('mode con') do if not defined pb.console.columns set "pb.console.columns=%%f"
    set /a "pb.barArea=pb.console.columns/2-2", "pb.textArea=pb.barArea-9"
    set "pb.fill="
    setlocal enableextensions enabledelayedexpansion
    for /l %%p in (1 1 %pb.barArea%) do set "pb.fill=!pb.fill!%pb.fillChar%"
    set "pb.fill=!pb.fill:~0,%pb.barArea%!"
    set "pb.dots=!pb.fill:%pb.fillChar%=%pb.dotChar%!"
    set "pb.back=!pb.fill:~0,%pb.textArea%!
    set "pb.back=!pb.back:%pb.fillChar%= !"
    endlocal & set "pb.fill=%pb.fill%" & set "pb.dots=%pb.dots%" & set "pb.back=%pb.back%"
    goto :eof

:finalizeProgressBar [erase]
    if defined pb.cr (
        if not "%~1"=="" (
            setlocal enabledelayedexpansion
            set "pb.back="
            for /l %%p in (1 1 %pb.console.columns%) do set "pb.back=!pb.back! "
            <nul set /p "pb.prompt=!pb.cr!!pb.back:~1!!pb.cr!"
            endlocal
        )
    )
    for /f "tokens=1 delims==" %%v in ('set pb.') do set "%%v="
    goto :eof