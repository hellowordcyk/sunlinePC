@echo off

REM ѭ����õ�ǰĿ¼�µ�����*_zh_CN.txt�ļ�����Ȼ�����ConvEncode.bat��ת��
for %%f in ( ./*_zh_CN.txt ./exception.txt ) do ConvEncode.bat %%f
