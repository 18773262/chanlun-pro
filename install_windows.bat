@echo off

rem anaconda �İ�װĿ¼ 
set conda_path=%USERPROFILE%\anaconda3
rem ���ô����Ļ�������
set conda_env_name=chanlun
rem ���� conda.exe ��ִ���ļ���·��
set conda_exe=%conda_path%\Scripts\conda.exe
rem ����������� pip ��ַ
set conda_pip=%conda_path%\envs\%conda_env_name%\Scripts\pip.exe

rem ����ļ��Ƿ����
if not exist %conda_path% (
  echo ����:δ�ҵ� conda ��װĿ¼���ɱ༭���ļ����޸� conda_path Ϊ Anaconda ��ʵ�ʰ�װ·��
  echo %conda_path%
  set /p dummy=
) else (
   echo Anaconda ��װ·����%conda_path%
   echo �����������ƣ�%conda_env_name%

   rem ɾ������
   %conda_exe% remove -n %conda_env_name% -y --all
    
   echo ���� %conda_env_name% ��������װ����
   %conda_exe% create -y -n %conda_env_name% python=3.10
   %conda_exe% activate %conda_env_name%
   %conda_exe% install -y -c conda-forge ta-lib
   %conda_pip% config set global.index-url https://mirrors.aliyun.com/pypi/simple/
   %conda_pip% install -r requirements.txt
   %conda_pip% install wheel
   %conda_pip% install package/pytdx-1.72r2-py3-none-any.whl

   echo �ű�ִ�����,�� Enter ���˳�...
   set /p dummy=
)