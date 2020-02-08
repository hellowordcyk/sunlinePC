CREATE OR REPLACE PACKAGE Pkg_Sdls_Validator IS
  /************************************************************************
  ������������pkg_sdls_validator(�����ͳ�Ʊ�׼��ϵͳУ�鴦���)
  ����������
  ��д�ˣ�    zhengmzh
  ��д���ڣ�  2013-01-10
  �޸ļ�¼��
  *************************************************************************/
  g_Pkgname VARCHAR2(255) DEFAULT 'Pkg_Sdls_Validator';
  --У��������,����ʱ����ִ��
  PROCEDURE Pro_Chek_Main(i_Acctdt IN DATE, --��������
                          o_Logcod OUT VARCHAR2, --������־����
                          o_Logdes OUT VARCHAR2); --������־��Ϣ
  --У��ǰ̨����                          
  PROCEDURE Pro_Chek_Call(i_Acctdt IN DATE, --��������
                          i_Brchno IN VARCHAR2, --ҵ�����
                          i_Chektp IN VARCHAR2, --У������,������������������
                          i_Cheksp IN VARCHAR2, --У�����,��ϸУ�顢����У��
                          o_Logcod OUT VARCHAR2, --������־����
                          o_Logdes OUT VARCHAR2); --������־��Ϣ       
  --�������У��                               
  PROCEDURE Pro_Chek_Loaf(i_Acctdt IN DATE, --��������
                          i_Brchno IN VARCHAR2, --ҵ�����
                          i_Cheksp IN VARCHAR2); --У�����,��ϸУ�顢����У��
  --�������У��                               
  PROCEDURE Pro_Chek_Loab(i_Acctdt IN DATE, --��������
                          i_Brchno IN VARCHAR2, --ҵ�����
                          i_Cheksp IN VARCHAR2); --У�����,��ϸУ�顢����У��
  --������У��                               
  PROCEDURE Pro_Chek_Depb(i_Acctdt IN DATE, --��������
                          i_Brchno IN VARCHAR2, --ҵ�����
                          i_Cheksp IN VARCHAR2); --У�����,��ϸУ�顢����У��                                                     
END Pkg_Sdls_Validator;
/
CREATE OR REPLACE PACKAGE BODY Pkg_Sdls_Validator IS

  PROCEDURE Pro_Chek_Main(i_Acctdt IN DATE, --��������
                          o_Logcod OUT VARCHAR2, --������־����
                          o_Logdes OUT VARCHAR2) --������־��Ϣ
   AS
    /************************************************************************
    ����������������У��������
    ����������  ��Ϊ����������������������У����ȵ����
    ��д�ˣ�    zhengmzh
    ��д���ڣ�  2013-01-10
    �޸ļ�¼��
    *************************************************************************/
    l_Log    Pkg_Bdss_Constant.t_Log; --��־��Ϣ������
    v_Altime Bdss_Trlg.Bgtime%TYPE; --���̿�ʼʱ�䣬����׼ȷ�����������̵ĺķ�ʱ��
    v_Objtna Bdss_Trlg.Logdes%TYPE; --������������
    Err_Exception EXCEPTION; --�����쳣
    Warn_Exception EXCEPTION; --�����쳣
    --ֻ������ϸ����
    CURSOR c_Brch IS
      SELECT Deptcode
        FROM Pcmc_Dept a
       WHERE NOT EXISTS
       (SELECT 1 FROM Pcmc_Dept b WHERE a.Deptid = b.Pdeptid);
    v_Brch c_Brch%ROWTYPE;
  BEGIN
    --0 ��ʼ��
    v_Altime     := Systimestamp;
    l_Log.Logcod := Pkg_Bdss_Constant.Logcod_Ok;
    l_Log.Procna := 'Pro_chek_main';
    l_Log.Procna := g_Pkgname || '.' || l_Log.Procna;
    l_Log.Logobj := 'Pro_chek_main';
  
    v_Objtna     := '�����ͳ�Ʊ�׼��';
    l_Log.Logdes := v_Objtna || '����У��';
    --0.1 �Ǽǹ��̿�ʼ����־
    Pkg_Bdss_Util.Pro_Cm_Writelog(i_Acctdt => i_Acctdt,
                                  i_Subsys => Pkg_Sdls_Constant.g_Subsys,
                                  i_Logcod => l_Log.Logcod,
                                  i_Logdes => '���̿�ʼ-' || l_Log.Logdes,
                                  i_Procna => l_Log.Procna,
                                  i_Bgtime => v_Altime);
  
    BEGIN
      OPEN c_Brch;
      LOOP
        FETCH c_Brch
          INTO v_Brch;
        EXIT WHEN c_Brch%NOTFOUND;
        --����������
        Pro_Chek_Loaf(i_Acctdt, v_Brch.Deptcode, NULL);
        --����������
        Pro_Chek_Loab(i_Acctdt, v_Brch.Deptcode, NULL);
        --���������
        Pro_Chek_Depb(i_Acctdt, v_Brch.Deptcode, NULL);
      END LOOP;
      CLOSE c_Brch;
    EXCEPTION
      WHEN OTHERS THEN
        l_Log.Logcod := SQLCODE;
        l_Log.Logdes := Substr(l_Log.Logdes || '�쳣���쳣��Ϣ��' || SQLERRM,
                               1,
                               Pkg_Bdss_Constant.Length_Logdes);
        RAISE Err_Exception;
    END;
    COMMIT;
    --3.8 �Ǽ�����������ɵ���־
    Pkg_Bdss_Util.Pro_Cm_Writelog(i_Acctdt => i_Acctdt,
                                  i_Subsys => Pkg_Sdls_Constant.g_Subsys,
                                  i_Logcod => l_Log.Logcod,
                                  i_Logdes => '�������',
                                  i_Procna => l_Log.Procna,
                                  i_Bgtime => v_Altime);
  
    --3.9 ǰ�����д��붼�ɹ�ִ�к����¸�����o_logcod��o_logdes��ֵ
    o_Logcod := Pkg_Bdss_Constant.Logcod_Ok;
    o_Logdes := Pkg_Bdss_Constant.Logdes_Ok;
  
  EXCEPTION
    WHEN Err_Exception THEN
      ROLLBACK; --���ٶ�undo��ռ��ռ��
      Pkg_Bdss_Util.Pro_Cm_Writelog(i_Acctdt => i_Acctdt,
                                    i_Subsys => Pkg_Sdls_Constant.g_Subsys,
                                    i_Logcod => l_Log.Logcod,
                                    i_Logdes => l_Log.Logdes,
                                    i_Procna => l_Log.Procna,
                                    i_Bgtime => l_Log.Bgtime,
                                    i_Logobj => l_Log.Logobj,
                                    i_Logkey => l_Log.Logkey);
      o_Logcod := l_Log.Logcod;
      o_Logdes := l_Log.Logdes;
    WHEN Warn_Exception THEN
      --�����쳣 ������쳣�����������Ƿ񷵻���ȷ�ķ�����
      ROLLBACK;
      Pkg_Bdss_Util.Pro_Cm_Writelog(i_Acctdt => i_Acctdt,
                                    i_Subsys => Pkg_Sdls_Constant.g_Subsys,
                                    i_Logcod => Nvl(l_Log.Logcod,
                                                    Pkg_Bdss_Constant.Logcod_Warn_Break),
                                    i_Logdes => Nvl(l_Log.Logdes,
                                                    Pkg_Bdss_Constant.Logdes_Warn_Break),
                                    i_Procna => l_Log.Procna,
                                    i_Bgtime => l_Log.Bgtime,
                                    i_Logobj => l_Log.Logobj,
                                    i_Logkey => l_Log.Logkey,
                                    i_Rowcnt => l_Log.Rowcnt);
      o_Logcod := Pkg_Bdss_Constant.Logcod_Ok;
      o_Logdes := Pkg_Bdss_Constant.Logdes_Warn_Break || l_Log.Logdes;
  END Pro_Chek_Main;

  PROCEDURE Pro_Chek_Call(i_Acctdt IN DATE, --��������
                          i_Brchno IN VARCHAR2, --ҵ�����
                          i_Chektp IN VARCHAR2, --У������,������������������
                          i_Cheksp IN VARCHAR2, --У�����,��ϸУ�顢����У��
                          o_Logcod OUT VARCHAR2, --������־����
                          o_Logdes OUT VARCHAR2) --������־��Ϣ
   AS
    /************************************************************************
    ����������������У��������
    ����������  ����������
    ��д�ˣ�    zhengmzh
    ��д���ڣ�  2013-01-14
    �޸ļ�¼��
    *************************************************************************/
    l_Log    Pkg_Bdss_Constant.t_Log; --��־��Ϣ������
    v_Altime Bdss_Trlg.Bgtime%TYPE; --���̿�ʼʱ�䣬����׼ȷ�����������̵ĺķ�ʱ��
    v_Objtna Bdss_Trlg.Logdes%TYPE; --������������
    Err_Exception EXCEPTION; --�����쳣
    Warn_Exception EXCEPTION; --�����쳣
  BEGIN
    --0 ��ʼ��
    v_Altime     := Systimestamp;
    l_Log.Logcod := Pkg_Bdss_Constant.Logcod_Ok;
    l_Log.Procna := 'Pro_Chek_Call';
    l_Log.Procna := g_Pkgname || '.' || l_Log.Procna;
    l_Log.Logobj := 'Pro_Chek_Call';
  
    v_Objtna     := '�����ͳ�Ʊ�׼��';
    l_Log.Logdes := v_Objtna || '����У��';
    --0.1 �Ǽǹ��̿�ʼ����־
    Pkg_Bdss_Util.Pro_Cm_Writelog(i_Acctdt => i_Acctdt,
                                  i_Subsys => Pkg_Sdls_Constant.g_Subsys,
                                  i_Logcod => l_Log.Logcod,
                                  i_Logdes => '���̿�ʼ-' || l_Log.Logdes,
                                  i_Procna => l_Log.Procna,
                                  i_Bgtime => v_Altime);
  
    BEGIN
      IF i_Chektp IS NULL THEN
        --����������
        Pro_Chek_Loaf(i_Acctdt, i_Brchno, i_Cheksp);
        --����������
        Pro_Chek_Loab(i_Acctdt, i_Brchno, i_Cheksp);
        --���������
        Pro_Chek_Depb(i_Acctdt, i_Brchno, i_Cheksp);
      ELSIF i_Chektp = Pkg_Sdls_Constant.g_Repttp_Lnam THEN
        --����������
        Pro_Chek_Loaf(i_Acctdt, i_Brchno, i_Cheksp);
      ELSIF i_Chektp = Pkg_Sdls_Constant.g_Repttp_Lnbl THEN
        NULL;
        --����������
        Pro_Chek_Loab(i_Acctdt, i_Brchno, i_Cheksp);
      ELSIF i_Chektp = Pkg_Sdls_Constant.g_Repttp_Depb THEN
        NULL;
        --���������
        Pro_Chek_Depb(i_Acctdt, i_Brchno, i_Cheksp);
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        l_Log.Logcod := SQLCODE;
        l_Log.Logdes := Substr(l_Log.Logdes || '�쳣���쳣��Ϣ��' || SQLERRM,
                               1,
                               Pkg_Bdss_Constant.Length_Logdes);
        RAISE Err_Exception;
    END;
    COMMIT;
    --3.8 �Ǽ�����������ɵ���־
    Pkg_Bdss_Util.Pro_Cm_Writelog(i_Acctdt => i_Acctdt,
                                  i_Subsys => Pkg_Sdls_Constant.g_Subsys,
                                  i_Logcod => l_Log.Logcod,
                                  i_Logdes => '�������',
                                  i_Procna => l_Log.Procna,
                                  i_Bgtime => v_Altime);
  
    --3.9 ǰ�����д��붼�ɹ�ִ�к����¸�����o_logcod��o_logdes��ֵ
    o_Logcod := Pkg_Bdss_Constant.Logcod_Ok;
    o_Logdes := Pkg_Bdss_Constant.Logdes_Ok;
  
  EXCEPTION
    WHEN Err_Exception THEN
      ROLLBACK; --���ٶ�undo��ռ��ռ��
      Pkg_Bdss_Util.Pro_Cm_Writelog(i_Acctdt => i_Acctdt,
                                    i_Subsys => Pkg_Sdls_Constant.g_Subsys,
                                    i_Logcod => l_Log.Logcod,
                                    i_Logdes => l_Log.Logdes,
                                    i_Procna => l_Log.Procna,
                                    i_Bgtime => l_Log.Bgtime,
                                    i_Logobj => l_Log.Logobj,
                                    i_Logkey => l_Log.Logkey);
      o_Logcod := l_Log.Logcod;
      o_Logdes := l_Log.Logdes;
    WHEN Warn_Exception THEN
      --�����쳣 ������쳣�����������Ƿ񷵻���ȷ�ķ�����
      ROLLBACK;
      Pkg_Bdss_Util.Pro_Cm_Writelog(i_Acctdt => i_Acctdt,
                                    i_Subsys => Pkg_Sdls_Constant.g_Subsys,
                                    i_Logcod => Nvl(l_Log.Logcod,
                                                    Pkg_Bdss_Constant.Logcod_Warn_Break),
                                    i_Logdes => Nvl(l_Log.Logdes,
                                                    Pkg_Bdss_Constant.Logdes_Warn_Break),
                                    i_Procna => l_Log.Procna,
                                    i_Bgtime => l_Log.Bgtime,
                                    i_Logobj => l_Log.Logobj,
                                    i_Logkey => l_Log.Logkey,
                                    i_Rowcnt => l_Log.Rowcnt);
      o_Logcod := Pkg_Bdss_Constant.Logcod_Ok;
      o_Logdes := Pkg_Bdss_Constant.Logdes_Warn_Break || l_Log.Logdes;
  END Pro_Chek_Call;

  PROCEDURE Pro_Chek_Loaf(i_Acctdt IN DATE, --��������
                          i_Brchno IN VARCHAR2, --ҵ�����
                          i_Cheksp IN VARCHAR2 --У�����,��ϸУ�顢����У��
                          ) AS
    /************************************************************************
    �����������������������У��
    ����������  �����������У��
    ��д�ˣ�    zhengmzh
    ��д���ڣ�  2013-01-14
    �޸ļ�¼��
    *************************************************************************/
    /*o_Logcod VARCHAR2(255); -- ����ֵ��ʱ����
    o_Logdes VARCHAR2(255); -- ����ֵ��ʱ����*/
    l_Log    Pkg_Bdss_Constant.t_Log; --��־��Ϣ������
    v_Altime Bdss_Trlg.Bgtime%TYPE; --���̿�ʼʱ�䣬����׼ȷ�����������̵ĺķ�ʱ��
    v_Objtna Bdss_Trlg.Logdes%TYPE; --������������
    Err_Exception EXCEPTION; --�����쳣
    Warn_Exception EXCEPTION; --�����쳣
  BEGIN
    --0 ��ʼ��
    v_Altime     := Systimestamp;
    l_Log.Logcod := Pkg_Bdss_Constant.Logcod_Ok;
    l_Log.Procna := 'Pro_Chek_Loaf';
    l_Log.Procna := g_Pkgname || '.' || l_Log.Procna;
    l_Log.Logobj := 'Pro_Chek_Loaf';
  
    v_Objtna     := '�����ͳ�Ʊ�׼���������';
    l_Log.Logdes := v_Objtna || '����У��';
    --0.1 �Ǽǹ��̿�ʼ����־
    Pkg_Bdss_Util.Pro_Cm_Writelog(i_Acctdt => i_Acctdt,
                                  i_Subsys => Pkg_Sdls_Constant.g_Subsys,
                                  i_Logcod => l_Log.Logcod,
                                  i_Logdes => '���̿�ʼ-' || l_Log.Logdes,
                                  i_Procna => l_Log.Procna,
                                  i_Bgtime => v_Altime);
  
    BEGIN
    
      --�������У��
      l_Log.Logcod := Pkg_Bdss_Constant.Logcod_Ok;
      l_Log.Logkey := 'LOAF_CHECK';
      l_Log.Bgtime := Systimestamp;
      l_Log.Logdes := v_Objtna || 'У��';
    
      IF i_Brchno IS NULL THEN
        l_Log.Logdes := l_Log.Logdes || '��������Ϊ��';
        RAISE Err_Exception;
      END IF;
    
      IF i_Cheksp IS NULL OR i_Cheksp = Pkg_Sdls_Constant.g_Detailcheck THEN
        INSERT INTO Bdss_Chek_Rslt
          (Acctdt, Subsys, Brchno, Chektp, Chekvl, Cheksp, Relseg, Chekmg)
          SELECT i_Acctdt,
                 Pkg_Sdls_Constant.g_Subsys,
                 x.Brchno,
                 Pkg_Sdls_Constant.g_Repttp_Lnam,
                 x.Chekvl,
                 Pkg_Sdls_Constant.g_Detailcheck,
                 x.c.f_Relseg,
                 x.c.f_Errormsg
            FROM (SELECT a.Brchno,
                         To_Char(a.Acctdt,
                                 Pkg_Sdls_Constant.g_Dateformat_Long) ||
                         Pkg_Sdls_Constant.g_Cheksplt || a.Brchno ||
                         Pkg_Sdls_Constant.g_Cheksplt || a.Lncfno Chekvl,
                         Func_Sdls_Validator(Checkparam(Pkg_Sdls_Constant.g_Repttp_Lnam,
                                                        'acctdt=' ||
                                                        To_Char(a.Acctdt,
                                                                Pkg_Sdls_Constant.g_Dateformat) ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'brchno=' || a.Brchno ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'custtp=' || a.Custtp ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'custcd=' || a.Custcd ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'indutr=' || a.Indutr ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'admreg=' || a.Admreg ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'cphdsc=' || a.Cphdsc ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'cpsctp=' || a.Cpsctp ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'lncfno=' || a.Lncfno ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'prodtp=' || a.Prodtp ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'itemcd=' || a.Itemcd ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'lnrliv=' || a.Lnrliv ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'loandt=' ||
                                                        To_Char(a.Loandt,
                                                                Pkg_Sdls_Constant.g_Dateformat) ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'matudt=' ||
                                                        To_Char(a.Matudt,
                                                                Pkg_Sdls_Constant.g_Dateformat) ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'rlmtdt=' ||
                                                        To_Char(a.Rlmtdt,
                                                                Pkg_Sdls_Constant.g_Dateformat) ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'crcycd=' || a.Crcycd ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'rsdlpl=' || a.Rsdlpl ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'itrftp=' || a.Itrftp ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'inralv=' || a.Inralv ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'lngrtp=' || a.Lngrtp ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'loanst=' || a.Loanst ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'loantg=' || a.Loantg ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'acctna=' || a.Acctna)) c
                    FROM Sdls_Data_Lnam a,
                         TABLE(Pkg_Bdss_Util.Splitstr(i_Brchno,
                                                      Pkg_Sdls_Constant.g_Brchsplit)) b
                   WHERE a.Brchno = b.Column_Value
                     AND a.Acctdt = i_Acctdt) x
           WHERE x.c.f_Checkst = Pkg_Sdls_Constant.g_Checkfail;
        --ת��code����
        l_Log.Rowcnt := SQL%ROWCOUNT;
        --�ύ��������
        COMMIT;
        --�Ǽ���־��Ϣ
        Pkg_Bdss_Util.Pro_Cm_Writelog(i_Acctdt => i_Acctdt,
                                      i_Subsys => Pkg_Sdls_Constant.g_Subsys,
                                      i_Logcod => l_Log.Logcod,
                                      i_Logdes => l_Log.Logdes,
                                      i_Procna => l_Log.Procna,
                                      i_Bgtime => l_Log.Bgtime,
                                      i_Logobj => l_Log.Logobj,
                                      i_Logkey => l_Log.Logkey,
                                      i_Rowcnt => l_Log.Rowcnt);
      END IF;
    
    EXCEPTION
      WHEN OTHERS THEN
        l_Log.Logcod := SQLCODE;
        l_Log.Logdes := Substr(l_Log.Logdes || '�쳣���쳣��Ϣ��' || SQLERRM,
                               1,
                               Pkg_Bdss_Constant.Length_Logdes);
        RAISE Err_Exception;
    END;
    COMMIT;
    --3.8 �Ǽ�����������ɵ���־
    Pkg_Bdss_Util.Pro_Cm_Writelog(i_Acctdt => i_Acctdt,
                                  i_Subsys => Pkg_Sdls_Constant.g_Subsys,
                                  i_Logcod => l_Log.Logcod,
                                  i_Logdes => '�������',
                                  i_Procna => l_Log.Procna,
                                  i_Bgtime => v_Altime);
  
    /*--3.9 ǰ�����д��붼�ɹ�ִ�к����¸�����o_logcod��o_logdes��ֵ
    o_Logcod := Pkg_Bdss_Constant.Logcod_Ok;
    o_Logdes := Pkg_Bdss_Constant.Logdes_Ok;*/
  
  EXCEPTION
    WHEN Err_Exception THEN
      ROLLBACK; --���ٶ�undo��ռ��ռ��
      Pkg_Bdss_Util.Pro_Cm_Writelog(i_Acctdt => i_Acctdt,
                                    i_Subsys => Pkg_Sdls_Constant.g_Subsys,
                                    i_Logcod => l_Log.Logcod,
                                    i_Logdes => l_Log.Logdes,
                                    i_Procna => l_Log.Procna,
                                    i_Bgtime => l_Log.Bgtime,
                                    i_Logobj => l_Log.Logobj,
                                    i_Logkey => l_Log.Logkey);
      /*o_Logcod := l_Log.Logcod;
      o_Logdes := l_Log.Logdes;*/
    WHEN Warn_Exception THEN
      --�����쳣 ������쳣�����������Ƿ񷵻���ȷ�ķ�����
      ROLLBACK;
      Pkg_Bdss_Util.Pro_Cm_Writelog(i_Acctdt => i_Acctdt,
                                    i_Subsys => Pkg_Sdls_Constant.g_Subsys,
                                    i_Logcod => Nvl(l_Log.Logcod,
                                                    Pkg_Bdss_Constant.Logcod_Warn_Break),
                                    i_Logdes => Nvl(l_Log.Logdes,
                                                    Pkg_Bdss_Constant.Logdes_Warn_Break),
                                    i_Procna => l_Log.Procna,
                                    i_Bgtime => l_Log.Bgtime,
                                    i_Logobj => l_Log.Logobj,
                                    i_Logkey => l_Log.Logkey,
                                    i_Rowcnt => l_Log.Rowcnt);
      /*o_Logcod := Pkg_Bdss_Constant.Logcod_Ok;
      o_Logdes := Pkg_Bdss_Constant.Logdes_Warn_Break || l_Log.Logdes;*/
  END Pro_Chek_Loaf;

  PROCEDURE Pro_Chek_Loab(i_Acctdt IN DATE, --��������
                          i_Brchno IN VARCHAR2, --ҵ�����
                          i_Cheksp IN VARCHAR2 --У�����,��ϸУ�顢����У��
                          ) AS
    /************************************************************************
    �����������������������У��
    ����������  �����������У��
    ��д�ˣ�    zhengmzh
    ��д���ڣ�  2013-01-14
    �޸ļ�¼��
    *************************************************************************/
    /*o_Logcod VARCHAR2(255); -- ����ֵ��ʱ����
    o_Logdes VARCHAR2(255); -- ����ֵ��ʱ����*/
    l_Log    Pkg_Bdss_Constant.t_Log; --��־��Ϣ������
    v_Altime Bdss_Trlg.Bgtime%TYPE; --���̿�ʼʱ�䣬����׼ȷ�����������̵ĺķ�ʱ��
    v_Objtna Bdss_Trlg.Logdes%TYPE; --������������
    Err_Exception EXCEPTION; --�����쳣
    Warn_Exception EXCEPTION; --�����쳣
  BEGIN
    --0 ��ʼ��
    v_Altime     := Systimestamp;
    l_Log.Logcod := Pkg_Bdss_Constant.Logcod_Ok;
    l_Log.Procna := 'Pro_Chek_Loab';
    l_Log.Procna := g_Pkgname || '.' || l_Log.Procna;
    l_Log.Logobj := 'Pro_Chek_Loab';
  
    v_Objtna     := '�����ͳ�Ʊ�׼���������';
    l_Log.Logdes := v_Objtna || '����У��';
    --0.1 �Ǽǹ��̿�ʼ����־
    Pkg_Bdss_Util.Pro_Cm_Writelog(i_Acctdt => i_Acctdt,
                                  i_Subsys => Pkg_Sdls_Constant.g_Subsys,
                                  i_Logcod => l_Log.Logcod,
                                  i_Logdes => '���̿�ʼ-' || l_Log.Logdes,
                                  i_Procna => l_Log.Procna,
                                  i_Bgtime => v_Altime);
  
    BEGIN
    
      --�������У��
      l_Log.Logcod := Pkg_Bdss_Constant.Logcod_Ok;
      l_Log.Logkey := 'LOAB_CHECK';
      l_Log.Bgtime := Systimestamp;
      l_Log.Logdes := v_Objtna || 'У��';
    
      IF i_Brchno IS NULL THEN
        l_Log.Logdes := l_Log.Logdes || '��������Ϊ��';
        RAISE Err_Exception;
      END IF;
    
      IF i_Cheksp IS NULL OR i_Cheksp = Pkg_Sdls_Constant.g_Detailcheck THEN
        INSERT INTO Bdss_Chek_Rslt
          (Acctdt, Subsys, Brchno, Chektp, Chekvl, Cheksp, Relseg, Chekmg)
          SELECT i_Acctdt,
                 Pkg_Sdls_Constant.g_Subsys,
                 x.Brchno,
                 Pkg_Sdls_Constant.g_Repttp_Lnbl,
                 x.Chekvl,
                 Pkg_Sdls_Constant.g_Detailcheck,
                 x.c.f_Relseg,
                 x.c.f_Errormsg
            FROM (SELECT a.Brchno,
                         To_Char(a.Acctdt,
                                 Pkg_Sdls_Constant.g_Dateformat_Long) ||
                         Pkg_Sdls_Constant.g_Cheksplt || a.Brchno ||
                         Pkg_Sdls_Constant.g_Cheksplt || a.Lncfno Chekvl,
                         Func_Sdls_Validator(Checkparam(Pkg_Sdls_Constant.g_Repttp_Lnbl,
                                                        'acctdt=' ||
                                                        To_Char(a.Acctdt,
                                                                Pkg_Sdls_Constant.g_Dateformat) ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'brchno=' || a.Brchno ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'custtp=' || a.Custtp ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'custcd=' || a.Custcd ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'indutr=' || a.Indutr ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'admreg=' || a.Admreg ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'cphdsc=' || a.Cphdsc ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'cpsctp=' || a.Cpsctp ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'lncfno=' || a.Lncfno ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'prodtp=' || a.Prodtp ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'itemcd=' || a.Itemcd ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'lnrliv=' || a.Lnrliv ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'loandt=' ||
                                                        To_Char(a.Loandt,
                                                                Pkg_Sdls_Constant.g_Dateformat) ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'matudt=' ||
                                                        To_Char(a.Matudt,
                                                                Pkg_Sdls_Constant.g_Dateformat) ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'lpbgdt=' ||
                                                        To_Char(a.Lpbgdt,
                                                                Pkg_Sdls_Constant.g_Dateformat) ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'lpmtdt=' ||
                                                        To_Char(a.Lpmtdt,
                                                                Pkg_Sdls_Constant.g_Dateformat) ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'crcycd=' || a.Crcycd ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'rsdlpl=' || a.Rsdlpl ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'itrftp=' || a.Itrftp ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'inralv=' || a.Inralv ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'lngrtp=' || a.Lngrtp ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'asselv=' || a.Asselv ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'loanst=' || a.Loanst ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'acctna=' || a.Acctna)) c
                    FROM Sdls_Data_Lnbl a,
                         TABLE(Pkg_Bdss_Util.Splitstr(i_Brchno,
                                                      Pkg_Sdls_Constant.g_Brchsplit)) b
                   WHERE a.Brchno = b.Column_Value
                     AND a.Acctdt = i_Acctdt) x
           WHERE x.c.f_Checkst = Pkg_Sdls_Constant.g_Checkfail;
        --ת��code����
        l_Log.Rowcnt := SQL%ROWCOUNT;
        --�ύ��������
        COMMIT;
        --�Ǽ���־��Ϣ
        Pkg_Bdss_Util.Pro_Cm_Writelog(i_Acctdt => i_Acctdt,
                                      i_Subsys => Pkg_Sdls_Constant.g_Subsys,
                                      i_Logcod => l_Log.Logcod,
                                      i_Logdes => l_Log.Logdes,
                                      i_Procna => l_Log.Procna,
                                      i_Bgtime => l_Log.Bgtime,
                                      i_Logobj => l_Log.Logobj,
                                      i_Logkey => l_Log.Logkey,
                                      i_Rowcnt => l_Log.Rowcnt);
      END IF;
    
    EXCEPTION
      WHEN OTHERS THEN
        l_Log.Logcod := SQLCODE;
        l_Log.Logdes := Substr(l_Log.Logdes || '�쳣���쳣��Ϣ��' || SQLERRM,
                               1,
                               Pkg_Bdss_Constant.Length_Logdes);
        RAISE Err_Exception;
    END;
    COMMIT;
    --3.8 �Ǽ�����������ɵ���־
    Pkg_Bdss_Util.Pro_Cm_Writelog(i_Acctdt => i_Acctdt,
                                  i_Subsys => Pkg_Sdls_Constant.g_Subsys,
                                  i_Logcod => l_Log.Logcod,
                                  i_Logdes => '�������',
                                  i_Procna => l_Log.Procna,
                                  i_Bgtime => v_Altime);
  
    /*--3.9 ǰ�����д��붼�ɹ�ִ�к����¸�����o_logcod��o_logdes��ֵ
    o_Logcod := Pkg_Bdss_Constant.Logcod_Ok;
    o_Logdes := Pkg_Bdss_Constant.Logdes_Ok;*/
  
  EXCEPTION
    WHEN Err_Exception THEN
      ROLLBACK; --���ٶ�undo��ռ��ռ��
      Pkg_Bdss_Util.Pro_Cm_Writelog(i_Acctdt => i_Acctdt,
                                    i_Subsys => Pkg_Sdls_Constant.g_Subsys,
                                    i_Logcod => l_Log.Logcod,
                                    i_Logdes => l_Log.Logdes,
                                    i_Procna => l_Log.Procna,
                                    i_Bgtime => l_Log.Bgtime,
                                    i_Logobj => l_Log.Logobj,
                                    i_Logkey => l_Log.Logkey);
      /*o_Logcod := l_Log.Logcod;
      o_Logdes := l_Log.Logdes;*/
    WHEN Warn_Exception THEN
      --�����쳣 ������쳣�����������Ƿ񷵻���ȷ�ķ�����
      ROLLBACK;
      Pkg_Bdss_Util.Pro_Cm_Writelog(i_Acctdt => i_Acctdt,
                                    i_Subsys => Pkg_Sdls_Constant.g_Subsys,
                                    i_Logcod => Nvl(l_Log.Logcod,
                                                    Pkg_Bdss_Constant.Logcod_Warn_Break),
                                    i_Logdes => Nvl(l_Log.Logdes,
                                                    Pkg_Bdss_Constant.Logdes_Warn_Break),
                                    i_Procna => l_Log.Procna,
                                    i_Bgtime => l_Log.Bgtime,
                                    i_Logobj => l_Log.Logobj,
                                    i_Logkey => l_Log.Logkey,
                                    i_Rowcnt => l_Log.Rowcnt);
      /*o_Logcod := Pkg_Bdss_Constant.Logcod_Ok;
      o_Logdes := Pkg_Bdss_Constant.Logdes_Warn_Break || l_Log.Logdes;*/
  END Pro_Chek_Loab;

  PROCEDURE Pro_Chek_Depb(i_Acctdt IN DATE, --��������
                          i_Brchno IN VARCHAR2, --ҵ�����
                          i_Cheksp IN VARCHAR2 --У�����,��ϸУ�顢����У��
                          ) AS
    /************************************************************************
    ����������������������У��
    ����������  ����������У��
    ��д�ˣ�    zhengmzh
    ��д���ڣ�  2013-01-14
    �޸ļ�¼��
    *************************************************************************/
    /*o_Logcod VARCHAR2(255); -- ����ֵ��ʱ����
    o_Logdes VARCHAR2(255); -- ����ֵ��ʱ����*/
    l_Log    Pkg_Bdss_Constant.t_Log; --��־��Ϣ������
    v_Altime Bdss_Trlg.Bgtime%TYPE; --���̿�ʼʱ�䣬����׼ȷ�����������̵ĺķ�ʱ��
    v_Objtna Bdss_Trlg.Logdes%TYPE; --������������
    Err_Exception EXCEPTION; --�����쳣
    Warn_Exception EXCEPTION; --�����쳣
  BEGIN
    --0 ��ʼ��
    v_Altime     := Systimestamp;
    l_Log.Logcod := Pkg_Bdss_Constant.Logcod_Ok;
    l_Log.Procna := 'Pro_Chek_Depb';
    l_Log.Procna := g_Pkgname || '.' || l_Log.Procna;
    l_Log.Logobj := 'Pro_Chek_Depb';
  
    v_Objtna     := '�����ͳ�Ʊ�׼��������';
    l_Log.Logdes := v_Objtna || '����У��';
    --0.1 �Ǽǹ��̿�ʼ����־
    Pkg_Bdss_Util.Pro_Cm_Writelog(i_Acctdt => i_Acctdt,
                                  i_Subsys => Pkg_Sdls_Constant.g_Subsys,
                                  i_Logcod => l_Log.Logcod,
                                  i_Logdes => '���̿�ʼ-' || l_Log.Logdes,
                                  i_Procna => l_Log.Procna,
                                  i_Bgtime => v_Altime);
  
    BEGIN
    
      --�������У��
      l_Log.Logcod := Pkg_Bdss_Constant.Logcod_Ok;
      l_Log.Logkey := 'DEPB_CHECK';
      l_Log.Bgtime := Systimestamp;
      l_Log.Logdes := v_Objtna || 'У��';
    
      IF i_Brchno IS NULL THEN
        l_Log.Logdes := l_Log.Logdes || '��������Ϊ��';
        RAISE Err_Exception;
      END IF;
    
      IF i_Cheksp IS NULL OR i_Cheksp = Pkg_Sdls_Constant.g_Detailcheck THEN
        INSERT INTO Bdss_Chek_Rslt
          (Acctdt, Subsys, Brchno, Chektp, Chekvl, Cheksp, Relseg, Chekmg)
          SELECT i_Acctdt,
                 Pkg_Sdls_Constant.g_Subsys,
                 x.Brchno,
                 Pkg_Sdls_Constant.g_Repttp_Depb,
                 x.Chekvl,
                 Pkg_Sdls_Constant.g_Detailcheck,
                 x.c.f_Relseg,
                 x.c.f_Errormsg
            FROM (SELECT a.Brchno,
                         To_Char(a.Acctdt,
                                 Pkg_Sdls_Constant.g_Dateformat_Long) ||
                         Pkg_Sdls_Constant.g_Cheksplt || a.Brchno ||
                         Pkg_Sdls_Constant.g_Cheksplt || a.Acctno ||
                         Pkg_Sdls_Constant.g_Cheksplt || a.Acctid Chekvl,
                         Func_Sdls_Validator(Checkparam(Pkg_Sdls_Constant.g_Repttp_Depb,
                                                        'acctdt=' ||
                                                        To_Char(a.Acctdt,
                                                                Pkg_Sdls_Constant.g_Dateformat) ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'brchno=' || a.Brchno ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'custtp=' || a.Custtp ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'acctno=' || a.Acctno ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'acctna=' || a.Acctna ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'acctid=' || a.Acctid ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'prodtp=' || a.Prodtp ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'itemcd=' || a.Itemcd ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'bgindt=' ||
                                                        To_Char(a.Bgindt,
                                                                Pkg_Sdls_Constant.g_Dateformat) ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'matudt=' ||
                                                        To_Char(a.Matudt,
                                                                Pkg_Sdls_Constant.g_Dateformat) ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'crcycd=' || a.Crcycd ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'lastbl=' || a.Lastbl ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'ccintg=' || a.Ccintg ||
                                                        Pkg_Sdls_Constant.g_Fdsplit ||
                                                        'inralv=' || a.Inralv)) c
                    FROM Sdls_Data_Dpbl a,
                         TABLE(Pkg_Bdss_Util.Splitstr(i_Brchno,
                                                      Pkg_Sdls_Constant.g_Brchsplit)) b
                   WHERE a.Brchno = b.Column_Value
                     AND a.Acctdt = i_Acctdt) x
           WHERE x.c.f_Checkst = Pkg_Sdls_Constant.g_Checkfail;
        --ת��code����
        l_Log.Rowcnt := SQL%ROWCOUNT;
        --�ύ��������
        COMMIT;
        --�Ǽ���־��Ϣ
        Pkg_Bdss_Util.Pro_Cm_Writelog(i_Acctdt => i_Acctdt,
                                      i_Subsys => Pkg_Sdls_Constant.g_Subsys,
                                      i_Logcod => l_Log.Logcod,
                                      i_Logdes => l_Log.Logdes,
                                      i_Procna => l_Log.Procna,
                                      i_Bgtime => l_Log.Bgtime,
                                      i_Logobj => l_Log.Logobj,
                                      i_Logkey => l_Log.Logkey,
                                      i_Rowcnt => l_Log.Rowcnt);
      END IF;
    
    EXCEPTION
      WHEN OTHERS THEN
        l_Log.Logcod := SQLCODE;
        l_Log.Logdes := Substr(l_Log.Logdes || '�쳣���쳣��Ϣ��' || SQLERRM,
                               1,
                               Pkg_Bdss_Constant.Length_Logdes);
        RAISE Err_Exception;
    END;
    COMMIT;
    --3.8 �Ǽ�����������ɵ���־
    Pkg_Bdss_Util.Pro_Cm_Writelog(i_Acctdt => i_Acctdt,
                                  i_Subsys => Pkg_Sdls_Constant.g_Subsys,
                                  i_Logcod => l_Log.Logcod,
                                  i_Logdes => '�������',
                                  i_Procna => l_Log.Procna,
                                  i_Bgtime => v_Altime);
  
    /*--3.9 ǰ�����д��붼�ɹ�ִ�к����¸�����o_logcod��o_logdes��ֵ
    o_Logcod := Pkg_Bdss_Constant.Logcod_Ok;
    o_Logdes := Pkg_Bdss_Constant.Logdes_Ok;*/
  
  EXCEPTION
    WHEN Err_Exception THEN
      ROLLBACK; --���ٶ�undo��ռ��ռ��
      Pkg_Bdss_Util.Pro_Cm_Writelog(i_Acctdt => i_Acctdt,
                                    i_Subsys => Pkg_Sdls_Constant.g_Subsys,
                                    i_Logcod => l_Log.Logcod,
                                    i_Logdes => l_Log.Logdes,
                                    i_Procna => l_Log.Procna,
                                    i_Bgtime => l_Log.Bgtime,
                                    i_Logobj => l_Log.Logobj,
                                    i_Logkey => l_Log.Logkey);
      /*o_Logcod := l_Log.Logcod;
      o_Logdes := l_Log.Logdes;*/
    WHEN Warn_Exception THEN
      --�����쳣 ������쳣�����������Ƿ񷵻���ȷ�ķ�����
      ROLLBACK;
      Pkg_Bdss_Util.Pro_Cm_Writelog(i_Acctdt => i_Acctdt,
                                    i_Subsys => Pkg_Sdls_Constant.g_Subsys,
                                    i_Logcod => Nvl(l_Log.Logcod,
                                                    Pkg_Bdss_Constant.Logcod_Warn_Break),
                                    i_Logdes => Nvl(l_Log.Logdes,
                                                    Pkg_Bdss_Constant.Logdes_Warn_Break),
                                    i_Procna => l_Log.Procna,
                                    i_Bgtime => l_Log.Bgtime,
                                    i_Logobj => l_Log.Logobj,
                                    i_Logkey => l_Log.Logkey,
                                    i_Rowcnt => l_Log.Rowcnt);
      /*o_Logcod := Pkg_Bdss_Constant.Logcod_Ok;
      o_Logdes := Pkg_Bdss_Constant.Logdes_Warn_Break || l_Log.Logdes;*/
  END Pro_Chek_Depb;
END Pkg_Sdls_Validator;
/
