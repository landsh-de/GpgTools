@echo off & SETLOCAL & SETLOCAL ENABLEDELAYEDEXPANSION & CLS & echo.

REM :: Version 1.8 by Veit Berwig in 07/2024
REM :: 
REM :: --- encoded in utf-8 ---
REM :: 

REM :: debug
REM :: echo on

REM :: -------------------- config block ----------------------- BEGIN
REM :: SET DIMENSIONS
REM :: No scroll-buffer possible, when lines are defined
REM :: mode con cols=120 lines=40

set INSTALLER=gpgtools-3.3.2.1.exe
SET ERRORLEVEL=0
REM :: -------------------- config block -----------------------  END

REM :: Relocate myself
set SCRIPTNAME=%~nx0
echo.=================================================================
echo.SCRIPTNAME: %SCRIPTNAME%
echo.=================================================================
echo.

REM :: Normalize DIR-output
set DIRCMD=/O:GNE

REM :: =====================================================================
REM :: Check admin-rights
REM :: =====================================================================
openfiles >nul 2>&1 || goto norights

IF "X%TEMP%" == "X" (
    if "X%SYSTEMDRIVE%" == "X" set TEMP=C:\Windows\Temp
    if NOT "X%SYSTEMDRIVE%" == "X" set TEMP=%SYSTEMDRIVE%\Windows\Temp
)
echo."%%TEMP%%".....ist: "%TEMP%"

IF "X%TMP%" == "X" (
    if "X%SYSTEMDRIVE%" == "X" set TMP=C:\Windows\Temp
    if NOT "X%SYSTEMDRIVE%" == "X" set TMP=%SYSTEMDRIVE%\Windows\Temp
)
echo."%%TMP%%"......ist: "%TMP%"

:cont0
REM :: relative path to absolute path -DRIVE-
set drive=%~d0
set drivep=%drive%
If $#\#$==$#%drive:~-1%#$ set drivep=%drive:~0,-1%
set drivename=%drivep%

REM :: relative path to absolute path -PATH-
set pathn=%~p0
set pathp=%pathn%
If $#\#$==$#%pathn:~-1%#$ set pathp=%pathn:~0,-1%
set pathname=%pathp%

set HOMEDRIVE=%drivename%
set HOMEPATH=%pathname%
set EXEDIR=%HOMEDRIVE%%HOMEPATH%
set DIRCMD=/O:GNE

REM :: ###############################################################
REM :: # Some coding hints ... BEGIN
REM :: ###############################################################
REM ::
REM :: # Example for ENABLEDELAYEDEXPANSION
REM :: ####################################
REM ::
REM :: set VAR=vorher
REM ::     if "%VAR%" == "vorher" (
REM ::         set VAR=nachher
REM ::         if "!VAR!" == "nachher" @echo Es funktioniert!
REM ::     )
REM ::     set LISTE=
REM ::     for %%i in (*) do set LISTE=!LISTE! %%i
REM ::     echo %LISTE%
REM :: 
REM :: # MessageBox by powershell Popup Method
REM :: #######################################
REM :: https://learn.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/windows-scripting/x83z1d9f(v=vs.84)
REM :: 
REM :: Chartables in VBA (0 - 127)
REM :: https://docs.microsoft.com/de-de/office/vba/language/reference/user-interface-help/character-set-0127
REM :: Chartables in VBA (128–255)
REM :: https://docs.microsoft.com/de-de/office/vba/language/reference/user-interface-help/character-set-128255
REM :: 
REM :: Syntax:
REM :: - intButton = object.Popup(strText,[nSecondsToWait],[strTitle],[nType])
REM :: 
REM :: Remarks:
REM :: - The Popup method displays a message box regardless of which
REM ::   host executable file is running (WScript.exe or CScript.exe).
REM :: - If "nSecondsToWait" equals zero (the default), the pop-up
REM ::   message box remains visible until closed by the user. If 
REM ::   "nSecondsToWaitis" is greater than zero, the pop-up message
REM ::   box closes after "nSecondsToWait" seconds.
REM :: - If you do not supply the argument "strTitle", the title of
REM ::   the pop-up message box defaults to "Windows Script Host."
REM :: 
REM :: Arguments:
REM :: - object
REM ::   WshShell object.
REM :: - strText
REM ::   String value that contains the text you want to appear in the
REM ::   pop-up message box.
REM :: - nSecondsToWait
REM ::   Optional. Numeric value indicating the maximum number of
REM ::   seconds you want the pop-up message box displayed. If
REM ::   "nSecondsToWait" is zero (the default), the pop-up message
REM ::   box remains visible until closed by the user.
REM :: - strTitle
REM ::   Optional. String value that contains the text you want to
REM ::   appear as the title of the pop-up message box.
REM :: - nType
REM ::   Optional. Numeric value indicating the type of buttons and
REM ::   icons you want in the pop-up message box. These determine how
REM ::   the message box is used.
REM :: - intButton
REM ::   Integer value indicating the number of the button the user
REM ::   clicked to dismiss the message box. This is the value
REM ::   returned by the Popup method.
REM :: 
REM :: BACKSPACE Chr(8)    / TAB     Chr(9)
REM :: LINEFEED  Chr(10)   / RETURN  Chr(13)
REM :: 
REM :: 196 Ä     Chr(196)  / 228 ä   Chr(228)
REM :: 213 Ö     Chr(213)  / 246 ö   Chr(246)
REM :: 220 Ü     Chr(220)  / 252 ü   Chr(252)
REM :: 223 ß     Chr(223)  / 128 €   Chr(128)
REM ::
REM :: MsgBox-constants
REM :: ====================================================
REM :: Button Types
REM :: Dec     Hex      Description
REM :: ====================================================
REM :: 0       0x0      Show OK button.
REM :: 1       0x1      Show OK and Cancel buttons.
REM :: 2       0x2      Show Abort, Retry, and Ignore buttons.
REM :: 3       0x3      Show Yes, No, and Cancel buttons.
REM :: 4       0x4      Show Yes and No buttons.
REM :: 5       0x5      Show Retry and Cancel buttons.
REM :: 6       0x6      Show Cancel, Try Again, and Continue buttons.
REM :: ====================================================
REM :: Icon Types
REM :: Dec     Hex      Description
REM :: ====================================================
REM :: 16      0x10     Show "Stop Mark" icon.
REM :: 32      0x20     Show "Question Mark" icon.
REM :: 48      0x30     Show "Exclamation Mark" icon.
REM :: 64      0x40     Show "Information Mark" icon.
REM :: ===============================================================
REM :: Other Type Values
REM :: Dec     Hex      Description
REM :: ===============================================================
REM :: 256     0x100    The second button is the default button.
REM :: 512     0x200    The third button is the default button.
REM :: 4096    0x1000   The message box is a system modal message box
REM ::                  and appears in a topmost window.
REM :: 524288  0x80000  The text is right-justified.
REM :: 1048576 0x100000 The message and caption text display in
REM ::                  right-to-left reading order, which is useful
REM ::                  for some languages.
REM :: ===============================================================
REM :: Return Value
REM :: The return value intButton is the number of the button that the
REM :: user clicked, or is -1 if the message box timed out. The
REM :: following table lists possible return values.
REM :: 
REM :: Dec     Description
REM :: ===============================================================
REM :: -1      The user did not click a button before "nSecondsToWait"
REM ::         seconds elapsed.
REM ::  1      OK button
REM ::  2      Cancel button
REM ::  3      Abort button
REM ::  4      Retry button
REM ::  5      Ignore button
REM ::  6      Yes button
REM ::  7      No button
REM ::  10     Try Again button
REM ::  11     Continue button
REM :: 
REM :: Example 1 MessageBox by wscript ComObject:
REM :: powershell.exe -ep Bypass -noprofile -command (new-object -ComObject wscript.shell).Popup('Systemh' + $([char]228) + 'rtung mittels Decrapifier beginnt ... ' + $([char]10) + $([char]13) + $([char]10) + $([char]13) + 'Diese Mitteilung wartet 10 Sekunden ...',10,'Information ...',0x0 + 0x40 + 0x1000) >nul 2>&1
REM :: Example 2 MessageBox by wscript ComObject with Return Value
REM :: (clicked button) to "stdout":
REM :: powershell.exe -ep Bypass -noprofile -command "(new-object -ComObject wscript.shell).Popup('Systemh' + $([char]228) + 'rtung mittels Decrapifier beginnt ... ' + $([char]10) + $([char]13) + $([char]10) + $([char]13) + 'Diese Mitteilung wartet 10 Sekunden ...',10,'Information ...',0x02 + 0x20 + 0x1000); exit $LASTEXITCODE"
REM :: 
REM :: ###############################################################
REM :: # Some coding hints ... END
REM :: ###############################################################

echo."%%EXEDIR%%"...ist: "%EXEDIR%"

:cont1
REM :: Check Installer-exe ...
if not exist "%EXEDIR%\%INSTALLER%"    goto installererror

echo.
REM :: Run Innosetup-Installer Package.
echo.Starte INSTALLER, bitte warten ...
start /wait "" "%EXEDIR%\%INSTALLER%" /LANG=German /TYPE=fullpol /VERYSILENT /BASSSOUND- /NORESTART /LOG

goto end

:tmperror
SET ERRORLEVEL=1
echo.
echo FEHLER:
echo Die Variable fuer das Temp-Verzeichnis existiert nicht,
echo oder keine Schreibrechte in "TEMP" oder "TMP".
echo.
goto end

:installererror
SET ERRORLEVEL=1
echo.
echo FEHLER: "%INSTALLER%" nicht im Pfad gefunden, bitte ueberpruefen.
echo.
goto end

:installercfgerror
SET ERRORLEVEL=1
echo.
echo FEHLER: "%INSTALLERCFG%" nicht im Pfad gefunden, bitte ueberpruefen.
echo.
goto end

:norights
SET ERRORLEVEL=1
echo.
echo FEHLER:
echo. Sie besitzen KEINE administrativen Rechte.
goto end

:end
echo ERRORLEVEL: %ERRORLEVEL%
echo (%SCRIPTNAME%) beendet.
REM :: echo Bitte Taste ...
REM :: pause >nul
EXIT /B %ERRORLEVEL%
