@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

REM Pliki i katalogi
SET INPUT_FILE=npm-depends.txt
SET OUTPUT_DIR=npm-tarballs
SET FAILED_FILE=failed-downloads.txt
SET SUCCESS_FILE=successful-downloads.txt

REM Tworzymy katalogi i czyscimy pliki
IF NOT EXIST "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"
IF EXIST "%FAILED_FILE%" del "%FAILED_FILE%"
IF EXIST "%SUCCESS_FILE%" del "%SUCCESS_FILE%"

echo Pobieranie paczek z %INPUT_FILE% ...

FOR /F "usebackq delims=" %%A IN ("%INPUT_FILE%") DO (
    SET "url=%%A"
    REM pomijamy puste linie
    IF NOT "!url!"=="" (
        FOR %%F IN ("!url!") DO SET "filename=%%~nxF"
        echo Pobieram !filename! z !url!

        REM pobieranie z retry, timeout, przekierowaniem i ignorowaniem certyfikatu SSL
        wget --tries=3 --timeout=30 --max-redirect=10 --no-check-certificate -O "%OUTPUT_DIR%\!filename!" "!url!"
        
        IF ERRORLEVEL 1 (
            echo Nie udało sie pobrać !url!
            echo !url!>>"%FAILED_FILE%"
        ) ELSE (
            echo !url!>>"%SUCCESS_FILE%"
        )
    )
)

echo Pobieranie zakończone.
IF EXIST "%FAILED_FILE%" (
    echo Niektóre pobrania się nie powiodły. Sprawdź plik: %FAILED_FILE%
) ELSE (
    echo Wszystkie paczki pobrane poprawnie.
)

ENDLOCAL
pause
