@echo off

set PORTABLE=ShareazaPortable

if not "%~dpnx0" == "%~d0\%PORTABLE%\%~nx0"  goto msg1
if not exist "%~d0\%PORTABLE%\Shareaza\Shareaza.exe" goto msg2
goto run

:msg1
echo 1. create folder "%~d0\%PORTABLE%\"
echo 2. copy "%~nx0" to "%~d0\%PORTABLE%\"

:msg2
echo 3. install Shareaza
echo 4. copy folder "C:\Program Files\Shareaza" to "%~d0\%PORTABLE%\"
echo 5. uninstall Shareaza
echo 6. run "%~d0\%PORTABLE%\%~nx0"

pause
exit

:run
cd /D %~dp0

rem --------------------------------
echo 1. Save local settings

regedit /ea "%TEMP%\ShareazaSaveLocal.reg" HKEY_CURRENT_USER\Software\Shareaza

rem --------------------------------
echo 2. Clear local settings

echo REGEDIT4> "%TEMP%\ShareazaDelOld.reg"

echo [-HKEY_CURRENT_USER\Software\Shareaza]>> "%TEMP%\ShareazaDelOld.reg"

regedit -s "%TEMP%\ShareazaDelOld.reg"

del "%TEMP%\ShareazaDelOld.reg" > nul

if not exist %PORTABLE%.reg goto next_step

rem -------------------------------------
echo 3. Restore portable settings

regedit -s %PORTABLE%.reg

:next_step

rem -------------------------------------
echo 4. Set portable path

echo REGEDIT4> "%TEMP%\Portable.reg"

echo [HKEY_CURRENT_USER\Software\Shareaza]>> "%TEMP%\Portable.reg"

echo [HKEY_CURRENT_USER\Software\Shareaza\Shareaza]>> "%TEMP%\Portable.reg"
echo "Path"="%~d0\\%PORTABLE%\\Shareaza">> "%TEMP%\Portable.reg"
echo "UserPath"="%~d0\\%PORTABLE%\\Application Data">> "%TEMP%\Portable.reg"

echo [HKEY_CURRENT_USER\Software\Shareaza\Shareaza\BitTorrent]>> "%TEMP%\Portable.reg"
echo "TorrentCreatorPath"="%~d0\\%PORTABLE%\\Shareaza\\TorrentWizard.exe">> "%TEMP%\Portable.reg"

echo [HKEY_CURRENT_USER\Software\Shareaza\Shareaza\Downloads]>> "%TEMP%\Portable.reg"
echo "CollectionPath"="%~d0\\%PORTABLE%\\Application Data\\Collections">> "%TEMP%\Portable.reg"
echo "CompletePath"="%~d0\\%PORTABLE%\\Shareaza Downloads">> "%TEMP%\Portable.reg"
echo "IncompletePath"="%~d0\\%PORTABLE%\\Application Data\\Incomplete">> "%TEMP%\Portable.reg"
echo "TorrentPath"="%~d0\\%PORTABLE%\\Application Data\\Torrents">> "%TEMP%\Portable.reg"

regedit -s "%TEMP%\Portable.reg"
del "%TEMP%\Portable.reg" > nul

rem -------------------------------------
echo 5. Run portable Shareaza

Shareaza\Shareaza.exe

rem -------------------------------------
echo 6. Save portable settings

regedit /ea %PORTABLE%.reg HKEY_CURRENT_USER\Software\Shareaza

rem -------------------------------------
echo 7. Clear portable settings

echo REGEDIT4> "%TEMP%\ShareazaDelOld.reg"

echo [-HKEY_CURRENT_USER\Software\Shareaza]>> "%TEMP%\ShareazaDelOld.reg"

regedit -s "%TEMP%\ShareazaDelOld.reg"

del "%TEMP%\ShareazaDelOld.reg" > nul

if not exist "%TEMP%\ShareazaSaveLocal.reg" exit

rem -------------------------------------
echo 8. Restore local settings

regedit -s "%TEMP%\ShareazaSaveLocal.reg"

del "%TEMP%\ShareazaSaveLocal.reg" > nul

exit
