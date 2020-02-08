@echo off

REM 循环获得当前目录下的所有*_zh_CN.txt文件名，然后调用ConvEncode.bat来转码
for %%f in ( ./*_zh_CN.txt ./exception.txt ) do ConvEncode.bat %%f
