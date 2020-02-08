CREATE OR REPLACE PROCEDURE Pro_Autocompile_Entry(Proc_Code IN CLOB) AUTHID CURRENT_USER IS
  /************************************************************************
  �������������ۺϼ��ϵͳ�Զ�ִ�д洢������ڹ���
  ���������������ۺϼ�ܺ�̨�洢���̲����������ֹ��������
            ���Oracle 11G���ݿ�,����ֱ��ִ�� execute immediate proc_crod
  ��д�ˣ�zhengmzh
  ��д���ڣ�2013-04-15 
  *************************************************************************/
BEGIN
  DECLARE
    l_Sql    Dbms_Sql.Varchar2a;
    l_Cursor NUMBER;
    --l_Rows   NUMBER;
    l_Len    NUMBER; --��ִ�д洢�����ܳ���
    l_Pos    NUMBER; --ѭ������
    v_Maxlen NUMBER; --plsqlִ��ʱ������ַ���
    my_Exception Exception;
  BEGIN
    IF Proc_Code is null THEN
      RAISE my_Exception;
    END IF;
    l_Cursor := Dbms_Sql.Open_Cursor;
    v_Maxlen := 10000; --Dbms_Lob.Substr���ص����ַ�,l_Sql������ֽ�,��ֹ�洢���������������ִ�б���
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
                   Lfflg         => FALSE,--����ҪΪfalse,��ֹ����һ������ı�������
                   Language_Flag => Dbms_Sql.Native);
  
    --l_Rows := Dbms_Sql.Execute(l_Cursor);
    Dbms_Sql.Close_Cursor(l_Cursor);
  Exception
    when my_Exception then
      dbms_output.put_line('this is an error:' || SQLERRM);
  END;

END Pro_Autocompile_Entry;
