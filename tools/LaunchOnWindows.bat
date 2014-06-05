@if not "%PROCESSOR_ARCHITEW6432%" == "" start $$LIBDIR\Windows_x86_64\$$FILENAME.exe exit
@if %PROCESSOR_ARCHITECTURE% == x86 start $$LIBDIR\Windows_x86\$$FILENAME.exe exit
@if %PROCESSOR_ARCHITECTURE% == AMD64 start $$LIBDIR\Windows_x86_64\$$FILENAME.exe exit
@if %PROCESSOR_ARCHITECTURE% == IA64 start $$LIBDIR\Windows_x86_64\$$FILENAME.exe exit

