@ECHO OFF&(CD /D "%~DP0")&(>NUL 2>&1 REG QUERY "HKU\S-1-5-19")||(powershell -Command "Start-Process '%~snx0' -Verb RunAs"&&exit)

taskkill /f /im YunDetectSer* >NUL 2>NUL
taskkill /f /im BaiduNetdisk* /t >NUL 2>NUL

regsvr32 /s /u npYunWebDetect.dll
regsvr32 /s /u YunShellExt.dll
regsvr32 /s /u YunShellExt64.dll
regsvr32 /s /u YunOfficeAddin.dll
regsvr32 /s /u YunOfficeAddin64.dll
if exist "%~dp0HelpUtility.exe" start /B HelpUtility.exe -cmd import_removablediskfile -uninstall
if exist "%~dp0YunDetectService.exe" start /B YunDetectService.exe unreg
if exist "%~dp0BaiduNetdiskHost.exe" ren BaiduNetdiskHost.exe  BaiduNetdiskHost.bak >NUL 2>NUL
if exist "%~dp0YunDetectService.exe" ren YunDetectService.exe  YunDetectService.bak >NUL 2>NUL
if exist "%~dp0BaiduNetdiskRender.exe" ren BaiduNetdiskRender.exe BaiduNetdiskRender.bak >NUL 2>NUL
echo y|icacls "%~dp0Autoupdate" /c /grant "Everyone:f" >NUL 2>NUL
echo y|icacls "%~dp0kernel.dll" /c /grant "Everyone:f" >NUL 2>NUL
echo y|icacls "%~dp0module\KernelCom" /c /grant "Everyone:f" >NUL 2>NUL

del AppProperty.xml >NUL 2>NUL
del AppSettingApp.dat >NUL 2>NUL
rd /s /q "%TEMP%\baidu" 2>NUL
rd /s /q "%TEMP%\baiduyunguanjia" 2>NUL
rd /s /q "%TEMP%\bdyunguanjiaskinres" 2>NUL
rd /s /q "%AppData%\Baidu\BaiduNetdisk" 2>NUL
rd /s /q "%AppData%\BaiduYunGuanjia" 2>NUL
rd /s /q "%AppData%\BaiduYunKernel" 2>NUL
del "%UserProfile%\桌面\百度网盘.lnk" >NUL 2>NUL
del "%UserProfile%\Desktop\百度网盘.lnk" >NUL 2>NUL
rd/s/q "%UserProfile%\「开始」菜单\程序\百度网盘"2>NUL
rd/s/q "%AllUsersProfile%\「开始」菜单\程序\百度网盘"2>NUL
rd/s/q "%AppData%\Microsoft\Windows\Start Menu\Programs\百度网盘"2>NUL
rd/s/q "%ProgramData%\Microsoft\Windows\Start Menu\Programs\百度网盘"2>NUL

reg delete "HKCR\BaiduYunGuanjia.torrent" /f >NUL 2>NUL
reg delete "HKCU\Software\Baidu\BaiduYunGuanjia" /f >NUL 2>NUL
reg delete "HKLM\SOFTWARE\Baidu\BaiduYunGuanjia" /f >NUL 2>NUL
reg delete "HKLM\SOFTWARE\Classes\Baiduyunguanjia" /f >NUL 2>NUL
reg delete "HKLM\SOFTWARE\Classes\BaiduYunGuanjia.torrent" /f >NUL 2>NUL
reg delete "HKLM\SOFTWARE\Wow6432Node\Baidu\BaiduYunGuanjia" /f >NUL 2>NUL

reg delete "HKCR\CLSID\{679F137C-3162-45da-BE3C-2F9C3D093F64}" /f >NUL 2>NUL
reg delete "HKLM\SOFTWARE\Classes\CLSID\{679F137C-3162-45da-BE3C-2F9C3D093F64}" /f >NUL 2>NUL
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "BaiduYunDetect" /f >NUL 2>NUL
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "BaiduYunGuanjia" /f >NUL 2>NUL
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "BaiduYunDetect" /f >NUL 2>NUL
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "BaiduYunGuanjia" /f >NUL 2>NUL
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{679F137C-3162-45da-BE3C-2F9C3D093F64}" /f >NUL 2>NUL
for /f "delims=" %%a in ('wmic userAccount where "Name='%userName%'" get SID /value') do call set "%%a" >nul
reg delete "HKU\%SID%\SOFTWARE\Classes\CLSID\{679F137C-3162-45da-BE3C-2F9C3D093F64}" /f >NUL 2>NUL
reg delete "HKU\%SID%\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{679F137C-3162-45da-BE3C-2F9C3D093F64}" /f >NUL 2>NUL
reg delete "HKU\%SID%\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "BaiduYunDetect" /f >NUL 2>NUL
reg delete "HKU\%SID%\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "BaiduYunGuanjia" /f >NUL 2>NUL

rd/s/q skin 2>NUL
rd/s/q sounds 2>NUL
rd/s/q module 2>NUL
rd/s/q download 2>NUL
rd/s/q browserres 2>NUL
rd/s/q kernel.dll 2>NUL
rd/s/q kernelbasis.dll 2>NUL
rd/s/q kernelUpdate.exe 2>NUL
rd/s/q kernelpromote.dll 2>NUL
del /f Autoupdate >NUL 2>NUL
for /f "delims=" %%i in ('dir /b /a-d *.*^|findstr /i /v "!)卸载.bat %~nx0"') do (del /f/q "%%i" >NUL 2>NUL)

ver|findstr "5\.[0-9]\.[0-9][0-9]*" > nul && (goto WinXP)
ver|findstr "\<6\.[0-9]\.[0-9][0-9]*\> \<10\.[0-9]\.[0-9][0-9]*\>" > nul && (goto Win7+)

:WinXP
ECHO.&ECHO 完成！保留用户数据目录？
ECHO.&ECHO 是关闭窗口，否敲任意键！&PAUSE>NUL
taskkill /f /im explorer.exe && start explorer.exe
cd .. & rd/s/q "%~dp0"
EXIT

:Win7+
ECHO.&ECHO 完成！保留用户数据目录？
ECHO.&ECHO 是关闭窗口，否敲任意键！&PAUSE>NUL
Call :_RestartExplorer
goto :eof
:_RestartExplorer
(
  echo Dim arrURL^(^), strURL, oShell, oWin, n
  echo n = -1
  echo Set oShell = CreateObject^("Shell.Application"^)
  echo For Each oWin In oShell.Windows
  echo   If Instr^(1, oWin.FullName, "\explorer.exe", vbTextCompare^) Then
  echo     n = n + 1
  echo     ReDim Preserve arrURL^(n^)
  echo     arrURL^(n^) = oWin.LocationURL
  echo   End If
  echo Next
  echo CreateObject^("WScript.Shell"^).run "tskill explorer", 0, True
  echo For Each strURL In arrURL
  echo   oShell.Explore strURL
  echo Next
)>"%temp%\RestartExplorer.vbs"
  CScript //NoLogo "%temp%\RestartExplorer.vbs"
  del "%temp%\RestartExplorer.vbs" >NUL 2>NUL & cd .. & rd/s/q "%~dp0"2>NUL
  goto :eof