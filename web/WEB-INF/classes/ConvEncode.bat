@echo off
REM ����ǰĿ¼��ISO�����comm_zh_CN.txt�ļ�ת����gb2312�����comm_zh_CN.properties�ļ���
REM ���ڸ���comm_zh_CN.txt�ļ���ʹ�ø�������������comm_zh_CN.properties�ļ���

REM Ҫ�����.txt�ļ�
set txtFile=%1

if [%txtFile%] == [] goto :end

REM ���ļ�����.txt����.properties
set proFile=%txtFile:~0,-3%properties

REM ��.properties��ɾ��
if exist %proFile% del %proFile%

REM ����native2asciiת��
native2ascii -encoding gb2312 %txtFile% %proFile%

:end
