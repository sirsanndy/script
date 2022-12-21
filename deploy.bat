@echo off
setlocal ENABLEDELAYEDEXPANSION

set projectname=project_name
set appservicename=Service_Name

set datenow=%date:~-4%%date:~4,2%%date:~7,2%
set source=F:\folder_name\%projectname%\%datenow%\
set target=F:\folder_name\%projectname%\run\
set file=%projectname%.jar
set filenew=0
set servicename=%projectname%.exe

if exist %source%%file% (
	echo Source File exist..
	
    if exist %target%%file% (
		echo Target File exist..
		
		xcopy /L /D /Y %source%%file% %target%%file%|findstr /B /C:"1 " && set filenew=1
	) else (
		echo Target File doesn't exist..
		set filenew=1
	)
	
	if !filenew! == 1 (
		echo Source is Newer..
		echo START DEPLOYING JAR..
		
		net stop "%appservicename%"
		
		xcopy /S /Q /Y /F %source%%file% %target%
		
		%target%%servicename% install
		%target%%servicename% start
	) else (
		echo Old and Boring..
		timeout 10>NUL
	)
) else (
    echo Source File doesn't exist
)
