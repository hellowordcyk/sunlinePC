@echo off
REM 将当前目录下ISO编码的comm_zh_CN.txt文件转换成gb2312编码的comm_zh_CN.properties文件。
REM 请在更新comm_zh_CN.txt文件后使用该命令重新生成comm_zh_CN.properties文件。

REM 要处理的.txt文件
set txtFile=%1

if [%txtFile%] == [] goto :end

REM 将文件最后的.txt换成.properties
set proFile=%txtFile:~0,-3%properties

REM 若.properties则删除
if exist %proFile% del %proFile%

REM 进行native2ascii转码
native2ascii -encoding gb2312 %txtFile% %proFile%

:end
