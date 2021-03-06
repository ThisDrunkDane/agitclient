@echo off
setlocal
set OTM=agc.otm
set SRC=src/main.odin
if %2 EQU 1 ( 
    set DEBUG=-debug
)

if not exist "build" ( mkdir build )

otime.exe -begin %OTM%
echo Compiling with opt=%1...
if %2 EQU 1 ( echo Compiling with debug )
odin build %SRC% -opt=%1 %DEBUG%
set ERR=%ERRORLEVEL%

if %ERR%==0 ( goto :build_success ) else ( goto :build_failed )


:build_success
    mv -f ./src/*.exe ./build 2> nul
    mv -f ./src/*.pdb ./build 2> nul
    if not exist ./build/git2.dll ( 
        echo Moving DLLs...
        xcopy .\external\git2.dll .\build\ /Y > nul
        xcopy .\external\libssh2.dll .\build\ /Y > nul
    )
    rm src/*.lib > nul
    rm src/*.exp > nul
    echo Build Success
    goto :end

:build_failed
    echo Build Failed
    goto :end

:end
    otime -end %OTM% %ERR%