@ECHO OFF&(CD /D "%~DP0")&(>NUL 2>&1 REG QUERY "HKU\S-1-5-19")||(powershell -Command "Start-Process '%~snx0' -Verb RunAs"&&exit)

taskkill /f /im YunDetectSer* >NUL 2>NUL
taskkill /f /im BaiduNetdisk* /t >NUL 2>NUL

::������ز����ļ�
rd /s /q "%TEMP%\baidu" 2>NUL
rd /s /q "%TEMP%\bdyunguanjiaskinres" 2>NUL
rd /s /q "%AppData%\BaiduYunKernel" 2>NUL
rd /s /q "%AppData%\BaiduYunGuanjia" 2>NUL
rd /s /q "%AppData%\Baidu\BaiduNetdisk" 2>NUL
rd /s /q "%AppData%\Baidu\BaiduYunKernel" 2>NUL

::����˵�����ٶ����̿�ݷ�ʽ��BT���ӹ�����
reg delete "HKLM\SOFTWARE\Classes\Baiduyunguanjia" /f >NUL 2>NUL
reg delete "HKLM\SOFTWARE\Classes\BaiduYunGuanjia.torrent" /f >NUL 2>NUL
reg delete "HKCR\CLSID\{679F137C-3162-45da-BE3C-2F9C3D093F64}" /f >NUL 2>NUL
reg delete "HKLM\SOFTWARE\Classes\CLSID\{679F137C-3162-45da-BE3C-2F9C3D093F64}" /f >NUL 2>NUL
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{679F137C-3162-45da-BE3C-2F9C3D093F64}" /f >NUL 2>NUL
for /f "delims=" %%a in ('wmic userAccount where "Name='%userName%'" get SID /value') do call set "%%a" >NUL
reg delete "HKU\%SID%\SOFTWARE\Classes\CLSID\{679F137C-3162-45da-BE3C-2F9C3D093F64}" /f >NUL 2>NUL
reg delete "HKU\%SID%\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{679F137C-3162-45da-BE3C-2F9C3D093F64}" /f >NUL 2>NUL

::��ֹ��̨�ϴ�
echo y|icacls "%~dp0Autoupdate" /c /grant "Everyone:(R,RX)" /inheritance:r >NUL 2>NUL
echo y|icacls "%~dp0kernel.dll" /c /grant "Everyone:(R,RX)" /inheritance:r >NUL 2>NUL
if exist "%~dp0module\KernelCom" attrib +r +a +s +h +x "%~dp0module\KernelCom" >NUL 2>NUL
if exist "%~dp0BaiduNetdiskHost.exe" ren BaiduNetdiskHost.exe BaiduNetdiskHost.bak >NUL 2>NUL
if exist "%~dp0YunDetectService.exe" ren YunDetectService.exe YunDetectService.bak >NUL 2>NUL
if exist "%~dp0BaiduNetdiskRender.exe" ren BaiduNetdiskRender.exe BaiduNetdiskRender.bak >NUL 2>NUL

::�������λ��
reg add "HKCU\Software\Baidu\BaiduYunGuanjia" /f /v "installDir" /d "%~dp0\" >NUL 2>NUL
if /i %PROCESSOR_IDENTIFIER:~0,3%==x86 (
reg add "HKLM\SOFTWARE\Baidu\BaiduYunGuanjia" /f /v "installDir" /d "%~dp0\" >NUL 2>NUL
) else (
reg add "HKLM\SOFTWARE\Wow6432Node\Baidu\BaiduYunGuanjia" /f /v "installDir" /d "%~dp0\" >NUL 2>NUL
)

::������ݷ�ʽ
mshta VBScript:Execute("Set a=CreateObject(""WScript.Shell""):Set b=a.CreateShortcut(a.SpecialFolders(""Desktop"") & ""\�ٶ�����.lnk""):b.TargetPath=""%~dp0BaiduNetdisk.exe"":b.WorkingDirectory=""%~dp0"":b.Save:close")

:Menu
Echo.&Echo  �Ѿ���ɣ����������������ѡ��
Echo.&Echo  1�����ýӹ���������ض��̵�����
Echo.&Echo  2����Ƶ�ļ������߲��ż�������
Echo.&Echo  3��PDF�Ķ�����΢��OFFICE������
Echo.&Echo  4�������Դ�������Ҽ��ϴ�������
ECHO.
set /p choice=���������ûس�����
if not "%choice%"=="" set choice=%choice:~0,1%
if /i "%choice%"=="1" Goto AddMenuExt
if /i "%choice%"=="2" Goto AddHostEXE
if /i "%choice%"=="3" Goto AddRender
if /i "%choice%"=="4" Goto AddShellExt
ECHO ������Ч &PAUSE>NUL&CLS&GOTO MENU

:AddMenuExt
regsvr32 /s npYunWebDetect.dll
if exist "%~dp0YunDetectService.bak" ren YunDetectService.bak YunDetectService.exe >NUL 2>NUL
if exist "%~dp0YunDetectService.exe" start /b YunDetectService.exe reg
if exist "%~dp0YunDetectService.exe" start YunDetectService.exe
ECHO.&ECHO ��ɣ����������! &PAUSE>NUL&CLS&GOTO MENU

:AddHostEXE
if exist "%~dp0BaiduNetdiskHost.bak" ren BaiduNetdiskHost.bak BaiduNetdiskHost.exe >NUL 2>NUL
ECHO:&ECHO ��ɣ����������! &PAUSE>NUL&CLS&GOTO MENU

:AddRender
if /i %PROCESSOR_IDENTIFIER:~0,3%==x86 (
regsvr32 /s YunOfficeAddin.dll
) else (
regsvr32 /s YunOfficeAddin.dll
regsvr32 /s YunOfficeAddin64.dll
)
if exist "%~dp0BaiduNetdiskRender.bak" ren BaiduNetdiskRender.bak BaiduNetdiskRender.exe >NUL 2>NUL
ECHO:&ECHO ��ɣ����������! &PAUSE>NUL&CLS&GOTO MENU

:AddShellExt
if /i %PROCESSOR_IDENTIFIER:~0,3%==x86 (
regsvr32 /s YunShellExt.dll
) else (
regsvr32 /s YunShellExt64.dll
)
ECHO.&ECHO ��ɣ����������! &PAUSE>NUL&CLS&GOTO MENU