CREATE OR REPLACE PROCEDURE Pro_Autocompile_Entry(Proc_Code IN CLOB) AUTHID CURRENT_USER IS
  /************************************************************************
  函数中文名：综合监管系统自动执行存储过程入口过程
  功能描述：减少综合监管后台存储过程部署工作量、手工部署错误
            针对Oracle 11G数据库,可以直接执行 execute immediate proc_crod
  编写人：zhengmzh
  编写日期：2013-04-15 
  *************************************************************************/
BEGIN
  DECLARE
    l_Sql    Dbms_Sql.Varchar2a;
    l_Cursor NUMBER;
    --l_Rows   NUMBER;
    l_Len    NUMBER; --待执行存储过程总长度
    l_Pos    NUMBER; --循环次数
    v_Maxlen NUMBER; --plsql执行时最大处理字符串
    my_Exception Exception;
  BEGIN
    IF Proc_Code is null THEN
      RAISE my_Exception;
    END IF;
    l_Cursor := Dbms_Sql.Open_Cursor;
    v_Maxlen := 10000; --Dbms_Lob.Substr返回的是字符,l_Sql存的是字节,防止存储过程中因带有中文执行报错
    l_Len    := Dbms_Lob.Getlength(Proc_Code);
    l_Pos    := Ceil(l_Len / v_Maxlen);
  
    FOR i IN 1 .. l_Pos LOOP
      l_Sql(i) := Dbms_Lob.Substr(Proc_Code,
                                  v_Maxlen,
                                  (i - 1) * v_Maxlen + 1);
    END LOOP;
  
    Dbms_Sql.Parse(c             => l_Cursor,
                   STATEMENT     => l_Sql,
                   Lb            => l_Sql.First,
                   Ub            => l_Sql.Last,
                   Lfflg         => FALSE,--必须要为false,防止新增一行引起的编译问题
                   Language_Flag => Dbms_Sql.Native);
  
    --l_Rows := Dbms_Sql.Execute(l_Cursor);
    Dbms_Sql.Close_Cursor(l_Cursor);
  Exception
    when my_Exception then
      dbms_output.put_line('this is an error:' || SQLERRM);
  END;

END Pro_Autocompile_Entry;
