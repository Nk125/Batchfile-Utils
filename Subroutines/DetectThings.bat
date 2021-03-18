@echo off
:set
set /p "var=user input: "
:: OR
set "var=var data"
echo %var% | findstr /I /C:""">var
if exist var (
      del var /f /s /q
      goto set
)
if "%var%"=="" goto set
:: This can be used to detect "artifacts" in variables (like | & ^ etc.)
