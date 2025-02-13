@echo off
setlocal enabledelayedexpansion

:: ͨ����� PATH ������������ Anaconda ·��
for %%a in ("%PATH:;=" "%") do (
    set "current_path=%%~a"
    :: ���·�����Ƿ���� Anaconda/Miniconda ��������ļ�
    if exist "!current_path!\conda.exe" (
        set "conda_path=!current_path!"
        goto found
    )
    if exist "!current_path!\conda.bat" (
        set "conda_path=!current_path!"
        goto found
    )
)

:: �������·���Ҳ���������ע����ѯ����������û���װ�������
for /f "skip=2 tokens=2,*" %%a in ('reg query "HKLM\SOFTWARE\Python\ContinuumAnalytics\Anaconda3" /v InstallPath 2^>nul') do (
    set "conda_path=%%b"
    goto found
)

:not_found
echo Anaconda δ�ҵ�����ȷ���Ѱ�װ���������ϵͳ��������
pause
exit /b 1

:found
rem anaconda �İ�װĿ¼ 
:: ��ȡ����װ·����ȥ�� Scripts/condabin ��Ŀ¼��
set "conda_path=!conda_path:\Scripts=!"
set "conda_path=!conda_path:\condabin=!"
echo ��⵽ Anaconda ��װ·��Ϊ: %conda_path%

rem ���ô����Ļ�������
set conda_env_name=chanlun
rem ���� conda.exe ��ִ���ļ���·��
set conda_exe=%conda_path%\Scripts\conda.exe
rem ����������� pip ��ַ
set conda_pip=%conda_path%\envs\%conda_env_name%\Scripts\pip.exe

echo Anaconda ��װ·����%conda_path%
echo �����������ƣ�%conda_env_name%

%conda_exe% init

rem ɾ������
%conda_exe% remove -n %conda_env_name% -y --all

echo ���� %conda_env_name% ��������װ����
%conda_exe% create -y -n %conda_env_name% python=3.11
%conda_exe% activate %conda_env_name%
%conda_pip% config set global.index-url https://mirrors.aliyun.com/pypi/simple/
%conda_pip% install package/ta_lib-0.4.25-cp311-cp311-win_amd64.whl
%conda_pip% install package/pytdx-1.72r2-py3-none-any.whl
%conda_pip% install -r requirements.txt

echo �ű�ִ�����,�� Enter ���˳�...
set /p dummy=
