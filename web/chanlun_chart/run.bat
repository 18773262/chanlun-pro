@echo off
setlocal enabledelayedexpansion

:: ��һ�׶� - ����Anaconda��װ·��
echo ���ڶ�λAnaconda��װ·��...

:: ͨ����� PATH ������������ Anaconda ·��
for %%a in ("%PATH:;=" "%") do (
    set "current_path=%%~a"
    :: ���·�����Ƿ���� Anaconda/Miniconda ��������ļ�
    if exist "!current_path!\conda.exe" (
        set "conda_path=!current_path!"
        goto validate_conda_path
    )
    if exist "!current_path!\conda.bat" (
        set "conda_path=!current_path!"
        goto validate_conda_path
    )
)

:: �������·���Ҳ���������ע����ѯ����������û���װ�������
for /f "skip=2 tokens=2,*" %%a in ('reg query "HKLM\SOFTWARE\Python\ContinuumAnalytics\Anaconda3" /v InstallPath 2^>nul') do (
    set "conda_path=%%b"
    goto validate_conda_path
)

:: ����3������û�Ŀ¼�µĳ�����װλ��
if exist "%USERPROFILE%\Anaconda3\conda.exe" (
    set "conda_path=%USERPROFILE%\Anaconda3"
    goto validate_conda_path
)

echo ����δ�ҵ�Anaconda��װ����ȷ������ȷ��װ
pause
exit /b 1

:validate_conda_path
set "conda_path=!conda_path:\conda.exe=!"
set "conda_path=!conda_path:\Scripts=!"
set "conda_path=!conda_path:\condabin=!"
echo ��⵽Anaconda��Ŀ¼��!conda_path!

:: �ڶ��׶� - ����Ŀ�껷��
echo �������� [chanlun] ����...
set "env_found=false"

:: ���ҷ�ʽ1����׼����Ŀ¼
set "env_path=!conda_path!\envs\chanlun"
if exist "!env_path!\python.exe" (
    set "env_found=true"
    goto found_env
)

:: ���ҷ�ʽ2���û��Զ��廷��Ŀ¼
for /f "tokens=*" %%e in ('dir /s /b "%USERPROFILE%\.conda\envs\chanlun\python.exe" 2^>nul') do (
    set "env_path=%%~dpe\.."
    set "env_found=true"
    goto found_env
)

:: ���ҷ�ʽ3��ͨ��conda������Ϣ
if exist "!conda_path!\condabin\conda.bat" (
    for /f "delims=" %%i in ('""!conda_path!\condabin\conda.bat" env list --json"') do (
        set "json_output=%%i"
    )
    for /f "tokens=2 delims=:," %%j in ('echo !json_output! ^| findstr /C:"\"name\": \"chanlun\""') do (
        set "env_path=%%~j"
        set "env_path=!env_path:\"/=!"
        set "env_path=!env_path:"=!"
        if exist "!env_path!\python.exe" (
            set "env_found=true"
            goto found_env
        )
    )
)

if "!env_found!" == "false" (
    echo ����δ�ҵ� [chanlun] ���⻷������ȷ�ϣ�
    echo 1. ���������Ƿ���ȷ
    echo 2. �����Ƿ��Ѵ���
    pause
    exit /b 2
)

:found_env
echo �ҵ�����·����!env_path!

:: �����׶� - ִ��Python�ű�
set "python_exe=!env_path!\python.exe"
if not exist "!python_exe!" (
    echo ����Python������δ�ҵ� [!python_exe!]
    pause
    exit /b 3
)

echo ����ʹ�� [!python_exe!] ִ�� app.py...
"!python_exe!" "app.py"

if !errorlevel! neq 0 (
    echo ����ִ��app.pyʱ�������� (�����룺!errorlevel!)
    pause
    exit /b 4
)

echo ִ�����
pause