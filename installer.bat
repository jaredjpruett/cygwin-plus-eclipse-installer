:: Make the prompt look a little less ugly ::::::::::::::::::::::::::::::::::::
@echo off
echo Initializing...
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::



:: Assert elevated command prompt :::::::::::::::::::::::::::::::::::::::::::::
net session >nul 2>&1

if not %errorLevel% == 0 (
	echo Installer must be run with administrative rights. Restart installer with proper permission.
	PAUSE
	EXIT
)
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::



:: Set runtime variables ::::::::::::::::::::::::::::::::::::::::::::::::::::::
set USERPROFILE="%USERPROFILE%"
set mirror=http://cygwin.parentingamerica.com
set file=%USERPROFILE%\workspace\.metadata\.plugins\org.eclipse.core.runtime\.settings\org.eclipse.cdt.ui.file

if exist "C:\Program Files (x86)" (
	set progfiles="C:\Program Files (x86)"
	set eclipse="C:\Program Files (x86)\Eclipse"
	set old="C:\Program Files (x86)\Eclipse.OLD"
	set shortcut="C:\Program Files (x86)\Eclipse\Eclipse-64.lnk"
	set unused="C:\Program Files (x86)\Eclipse\Eclipse-32.lnk"
) else (
	set progfiles="C:\Program Files"
	set eclipse="C:\Program Files\Eclipse"
	set old="C:\Program Files\Eclipse.OLD"
	set shortcut="C:\Program Files\Eclipse\Eclipse-32.lnk"
	set unused="C:\Program Files\Eclipse\Eclipse-64.lnk"
)
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::



:: Install Cygwin and update PATH environment variable ::::::::::::::::::::::::
if exist C:\CYGWIN move /Y C:\CYGWIN C:\CYGWIN.OLD
echo Installing Cygwin...
setup-x86.exe -d -n -q -X -R C:\CYGWIN -s %mirror% -P gcc-core -P gcc-g++ -P gdb -P gettext-devel -P make

if not exist C:\CYGWIN\bin\g++.exe (
	echo Cygwin installation seems to have failed. Trying again...
	rd /S /Q C:\CYGWIN
	setup-x86.exe -d -n -q -X -R C:\CYGWIN -s %mirror% -P gcc-core -P gcc-g++ -P gdb -P gettext-devel -P make
	
	if not exist C:\CYGWIN\bin\g++.exe (
		echo Cygwin installation failed. Ensure you are connected to the internet and run the installer again.
		PAUSE
		EXIT
	)
)

echo Appending to path...
setx PATH /m "%PATH%;C:\CYGWIN\bin"
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::



:: Install Java, "install" Eclipse, "create" desktop shortcut :::::::::::::::::
if not exist %progfiles%\Java\jre7\bin\java.exe	(
	echo Did not detect static 32-bit JRE installation.
	echo Installing 32-bit static JRE...
	jre-7u45-windows-i586.exe /s STATIC=1
)

if exist %USERPROFILE%\.eclipse move /Y %USERPROFILE%\.eclipse.OLD
if exist %eclipse% move /Y %eclipse% %old%

echo Installing Eclipse...
xcopy /i /e /v /r /h /k /y eclipse %eclipse%
xcopy /i /e /v /r /h /k /y workspace %USERPROFILE%\workspace\
::if exist %file% move /Y %file% %file%\org.eclipse.cdt.ui.file.OLD
move /Y %shortcut% %USERPROFILE%\Desktop\Eclipse.lnk
del %unused%
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::



:: FIN ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo.
echo Installation complete.
echo.
PAUSE
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::