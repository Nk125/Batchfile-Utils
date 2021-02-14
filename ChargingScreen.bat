@echo off

:subroutine
:: %1 = Time between points

:: %2 = Loops to charge, example: 1 sec between points + 1 loop = 5 secs charging

if "%1" EQU "" (
set "secs=1"
) else (
set "secs=%1"
)
if "%2" EQU "" (
set "loops=1"
) else (
set "loops=%2
)
:loop

set /a loop+=1

cls

echo Please wait .

timeout /t %secs% /nobreak>nul

cls

echo Please wait  .

timeout /t %secs% /nobreak>nul

cls

echo Please wait   .

timeout /t %secs% /nobreak>nul

cls

echo Please wait    .

timeout /t %secs% /nobreak>nul

cls

echo Please wait     .

timeout /t %secs% /nobreak>nul

if not %loop%==%loops% goto loop
