if exist moveme.exe del moveme.exe
if errorlevel 1 goto error
if exist moveme.obj del moveme.obj
if errorlevel 1 goto error
if exist rsrc.res del rsrc.res
if errorlevel 1 goto error
if exist rsrc.obj del rsrc.obj
if errorlevel 1 goto error
\masm32\bin\rc /v rsrc.rc
if errorlevel 1 goto error
\masm32\bin\cvtres /machine:ix86 rsrc.res
if errorlevel 1 goto error

\masm32\bin\ml /c /coff "moveme.asm"
if errorlevel 1 goto error

\masm32\bin\PoLink /SUBSYSTEM:WINDOWS "moveme.obj" rsrc.res
if errorlevel 1 goto error

rem e:\masm32\bin\build.bat moveme

echo NOERROR
goto noerror
:error
rem ERROR
:noerror
pause


