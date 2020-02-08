CREATE OR REPLACE PACKAGE Pkg_Sdls_Validator IS
  /************************************************************************
  过程中文名：pkg_sdls_validator(存贷款统计标准化系统校验处理包)
  功能描述：
  编写人：    zhengmzh
  编写日期：  2013-01-10
  修改记录：
  *************************************************************************/
  g_Pkgname VARCHAR2(255) DEFAULT 'Pkg_Sdls_Validator';
  --校验主过程,日终时批量执行
  PROCEDURE Pro_Chek_Main(i_Acctdt IN DATE, --数据日期
                          o_Logcod OUT VARCHAR2, --返回日志代码
                          o_Logdes OUT VARCHAR2); --返回日志消息
  --校验前台调用                          
  PROCEDURE Pro_Chek_Call(i_Acctdt IN DATE, --数据日期
                          i_Brchno IN VARCHAR2, --业务机构
                          i_Chektp IN VARCHAR2, --校验类型,贷款发生额、贷款余额、存款余额
                          i_Cheksp IN VARCHAR2, --校验类别,明细校验、汇总校验
                          o_Logcod OUT VARCHAR2, --返回日志代码
                          o_Logdes OUT VARCHAR2); --返回日志消息       
  --贷款发生额校验                               
  PROCEDURE Pro_Chek_Loaf(i_Acctdt IN DATE, --数据日期
                          i_Brchno IN VARCHAR2, --业务机构
                          i_Cheksp IN VARCHAR2); --校验类别,明细校验、汇总校验
  --贷款余额校验                               
  PROCEDURE Pro_Chek_Loab(i_Acctdt IN DATE, --数据日期
                          i_Brchno IN VARCHAR2, --业务机构
                          i_Cheksp IN VARCHAR2); --校验类别,明细校验、汇总校验
  --存款余额校验                               
  PROCEDURE Pro_Chek_Depb(i_Acctdt IN DATE, --数据日期
                          i_Brchno IN VARCHAR2, --业务机构
                          i_Cheksp IN VARCHAR2); --校验类别,明细校验、汇总校验                                                     
END Pkg_Sdls_Validator;
/
CREATE OR REPLACE PACKAGE BODY Pkg_Sdls_Validator IS

  PROCEDURE Pro_Chek_Main(i_Acctdt IN DATE, --数据日期
                          o_Logcod OUT VARCHAR2, --返回日志代码
                          o_Logdes OUT VARCHAR2) --返回日志消息
   AS
    /************************************************************************
    过程中文名：数据校验主过程
    功能描述：  作为贷款发生额、贷款余额、存款余额数据校验调度的入口
    编写人：    zhengmzh
    编写日期：  2013-01-10
    修改记录：
    *************************************************************************/
    l_Log    Pkg_Bdss_Constant.t_Log; --日志信息变量组
    v_Altime Bdss_Trlg.Bgtime%TYPE; --过程开始时间，用于准确计算整个过程的耗费时间
    v_Objtna Bdss_Trlg.Logdes%TYPE; --操作对象名称
    Err_Exception EXCEPTION; --错误异常
    Warn_Exception EXCEPTION; --警告异常
    --只处理明细机构
    CURSOR c_Brch IS
      SELECT Deptcode
        FROM Pcmc_Dept a
       WHERE NOT EXISTS
       (SELECT 1 FROM Pcmc_Dept b WHERE a.Deptid = b.Pdeptid);
    v_Brch c_Brch%ROWTYPE;
  BEGIN
    --0 初始化
    v_Altime     := Systimestamp;
    l_Log.Logcod := Pkg_Bdss_Constant.Logcod_Ok;
    l_Log.Procna := 'Pro_chek_main';
    l_Log.Procna := g_Pkgname || '.' || l_Log.Procna;
    l_Log.Logobj := 'Pro_chek_main';
  
    v_Objtna     := '存贷款统计标准化';
    l_Log.Logdes := v_Objtna || '数据校验';
    --0.1 登记过程开始的日志
    Pkg_Bdss_Util.Pro_Cm_Writelog(i_Acctdt => i_Acctdt,
                                  i_Subsys => Pkg_Sdls_Constant.g_Subsys,
                                  i_Logcod => l_Log.Logcod,
                                  i_Logdes => '过程开始-' || l_Log.Logdes,
                                  i_Procna => l_Log.Procna,
                                  i_Bgtime => v_Altime);
  
    BEGIN
      OPEN c_Brch;
      LOOP
        FETCH c_Brch
          INTO v_Brch;
        EXIT WHEN c_Brch%NOTFOUND;
        --贷款发生额调用
        Pro_Chek_Loaf(i_Acctdt, v_Brch.Deptcode, NULL);
        --贷款余额调用
        Pro_Chek_Loab(i_Acctdt, v_Brch.Deptcode, NULL);
        --存款余额调用
        Pro_Chek_Depb(i_Acctdt, v_Brch.Deptcode, NULL);
      END LOOP;
      CLOSE c_Brch;
    EXCEPTION
      WHEN OTHERS THEN
        l_Log.Logcod := SQLCODE;
        l_Log.Logdes := Substr(l_Log.Logdes || '异常，异常信息：' || SQLERRM,
                               1,
                               Pkg_Bdss_Constant.Length_Logdes);
        RAISE Err_Exception;
    END;
    COMMIT;
    --3.8 登记整个过程完成的日志
    Pkg_Bdss_Util.Pro_Cm_Writelog(i_Acctdt => i_Acctdt,
                                  i_Subsys => Pkg_Sdls_Constant.g_Subsys,
                                  i_Logcod => l_Log.Logcod,
                                  i_Logdes => '过程完成',
                                  i_Procna => l_Log.Procna,
                                  i_Bgtime => v_Altime);
  
    --3.9 前述所有代码都成功执行后，重新给变量o_logcod和o_logdes赋值
    o_Logcod := Pkg_Bdss_Constant.Logcod_Ok;
    o_Logdes := Pkg_Bdss_Constant.Logdes_Ok;
  
  EXCEPTION
    WHEN Err_Exception THEN
      ROLLBACK; --减少对undo表空间的占用
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
      --警告异常 与错误异常的区别在于是否返回正确的返回码
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

  PROCEDURE Pro_Chek_Call(i_Acctdt IN DATE, --数据日期
                          i_Brchno IN VARCHAR2, --业务机构
                          i_Chektp IN VARCHAR2, --校验类型,贷款发生额、贷款余额、存款余额
                          i_Cheksp IN VARCHAR2, --校验类别,明细校验、汇总校验
                          o_Logcod OUT VARCHAR2, --返回日志代码
                          o_Logdes OUT VARCHAR2) --返回日志消息
   AS
    /************************************************************************
    过程中文名：数据校验主过程
    功能描述：  界面调用入口
    编写人：    zhengmzh
    编写日期：  2013-01-14
    修改记录：
    *************************************************************************/
    l_Log    Pkg_Bdss_Constant.t_Log; --日志信息变量组
    v_Altime Bdss_Trlg.Bgtime%TYPE; --过程开始时间，用于准确计算整个过程的耗费时间
    v_Objtna Bdss_Trlg.Logdes%TYPE; --操作对象名称
    Err_Exception EXCEPTION; --错误异常
    Warn_Exception EXCEPTION; --警告异常
  BEGIN
    --0 初始化
    v_Altime     := Systimestamp;
    l_Log.Logcod := Pkg_Bdss_Constant.Logcod_Ok;
    l_Log.Procna := 'Pro_Chek_Call';
    l_Log.Procna := g_Pkgname || '.' || l_Log.Procna;
    l_Log.Logobj := 'Pro_Chek_Call';
  
    v_Objtna     := '存贷款统计标准化';
    l_Log.Logdes := v_Objtna || '数据校验';
    --0.1 登记过程开始的日志
    Pkg_Bdss_Util.Pro_Cm_Writelog(i_Acctdt => i_Acctdt,
                                  i_Subsys => Pkg_Sdls_Constant.g_Subsys,
                                  i_Logcod => l_Log.Logcod,
                                  i_Logdes => '过程开始-' || l_Log.Logdes,
                                  i_Procna => l_Log.Procna,
                                  i_Bgtime => v_Altime);
  
    BEGIN
      IF i_Chektp IS NULL THEN
        --贷款发生额调用
        Pro_Chek_Loaf(i_Acctdt, i_Brchno, i_Cheksp);
        --贷款余额调用
        Pro_Chek_Loab(i_Acctdt, i_Brchno, i_Cheksp);
        --存款余额调用
        Pro_Chek_Depb(i_Acctdt, i_Brchno, i_Cheksp);
      ELSIF i_Chektp = Pkg_Sdls_Constant.g_Repttp_Lnam THEN
        --贷款发生额调用
        Pro_Chek_Loaf(i_Acctdt, i_Brchno, i_Cheksp);
      ELSIF i_Chektp = Pkg_Sdls_Constant.g_Repttp_Lnbl THEN
        NULL;
        --贷款余额调用
        Pro_Chek_Loab(i_Acctdt, i_Brchno, i_Cheksp);
      ELSIF i_Chektp = Pkg_Sdls_Constant.g_Repttp_Depb THEN
        NULL;
        --存款余额调用
        Pro_Chek_Depb(i_Acctdt, i_Brchno, i_Cheksp);
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        l_Log.Logcod := SQLCODE;
        l_Log.Logdes := Substr(l_Log.Logdes || '异常，异常信息：' || SQLERRM,
                               1,
                               Pkg_Bdss_Constant.Length_Logdes);
        RAISE Err_Exception;
    END;
    COMMIT;
    --3.8 登记整个过程完成的日志
    Pkg_Bdss_Util.Pro_Cm_Writelog(i_Acctdt => i_Acctdt,
                                  i_Subsys => Pkg_Sdls_Constant.g_Subsys,
                                  i_Logcod => l_Log.Logcod,
                                  i_Logdes => '过程完成',
                                  i_Procna => l_Log.Procna,
                                  i_Bgtime => v_Altime);
  
    --3.9 前述所有代码都成功执行后，重新给变量o_logcod和o_logdes赋值
    o_Logcod := Pkg_Bdss_Constant.Logcod_Ok;
    o_Logdes := Pkg_Bdss_Constant.Logdes_Ok;
  
  EXCEPTION
    WHEN Err_Exception THEN
      ROLLBACK; --减少对undo表空间的占用
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
      --警告异常 与错误异常的区别在于是否返回正确的返回码
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

  PROCEDURE Pro_Chek_Loaf(i_Acctdt IN DATE, --数据日期
                          i_Brchno IN VARCHAR2, --业务机构
                          i_Cheksp IN VARCHAR2 --校验类别,明细校验、汇总校验
                          ) AS
    /************************************************************************
    过程中文名：贷款发生额数据校验
    功能描述：  贷款发生额数据校验
    编写人：    zhengmzh
    编写日期：  2013-01-14
    修改记录：
    *************************************************************************/
    /*o_Logcod VARCHAR2(255); -- 返回值临时定义
    o_Logdes VARCHAR2(255); -- 返回值临时定义*/
    l_Log    Pkg_Bdss_Constant.t_Log; --日志信息变量组
    v_Altime Bdss_Trlg.Bgtime%TYPE; --过程开始时间，用于准确计算整个过程的耗费时间
    v_Objtna Bdss_Trlg.Logdes%TYPE; --操作对象名称
    Err_Exception EXCEPTION; --错误异常
    Warn_Exception EXCEPTION; --警告异常
  BEGIN
    --0 初始化
    v_Altime     := Systimestamp;
    l_Log.Logcod := Pkg_Bdss_Constant.Logcod_Ok;
    l_Log.Procna := 'Pro_Chek_Loaf';
    l_Log.Procna := g_Pkgname || '.' || l_Log.Procna;
    l_Log.Logobj := 'Pro_Chek_Loaf';
  
    v_Objtna     := '存贷款统计标准化贷款发生额';
    l_Log.Logdes := v_Objtna || '数据校验';
    --0.1 登记过程开始的日志
    Pkg_Bdss_Util.Pro_Cm_Writelog(i_Acctdt => i_Acctdt,
                                  i_Subsys => Pkg_Sdls_Constant.g_Subsys,
                                  i_Logcod => l_Log.Logcod,
                                  i_Logdes => '过程开始-' || l_Log.Logdes,
                                  i_Procna => l_Log.Procna,
                                  i_Bgtime => v_Altime);
  
    BEGIN
    
      --贷款发生额校验
      l_Log.Logcod := Pkg_Bdss_Constant.Logcod_Ok;
      l_Log.Logkey := 'LOAF_CHECK';
      l_Log.Bgtime := Systimestamp;
      l_Log.Logdes := v_Objtna || '校验';
    
      IF i_Brchno IS NULL THEN
        l_Log.Logdes := l_Log.Logdes || '机构不能为空';
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
        --转换code结束
        l_Log.Rowcnt := SQL%ROWCOUNT;
        --提交隐性事务
        COMMIT;
        --登记日志信息
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
        l_Log.Logdes := Substr(l_Log.Logdes || '异常，异常信息：' || SQLERRM,
                               1,
                               Pkg_Bdss_Constant.Length_Logdes);
        RAISE Err_Exception;
    END;
    COMMIT;
    --3.8 登记整个过程完成的日志
    Pkg_Bdss_Util.Pro_Cm_Writelog(i_Acctdt => i_Acctdt,
                                  i_Subsys => Pkg_Sdls_Constant.g_Subsys,
                                  i_Logcod => l_Log.Logcod,
                                  i_Logdes => '过程完成',
                                  i_Procna => l_Log.Procna,
                                  i_Bgtime => v_Altime);
  
    /*--3.9 前述所有代码都成功执行后，重新给变量o_logcod和o_logdes赋值
    o_Logcod := Pkg_Bdss_Constant.Logcod_Ok;
    o_Logdes := Pkg_Bdss_Constant.Logdes_Ok;*/
  
  EXCEPTION
    WHEN Err_Exception THEN
      ROLLBACK; --减少对undo表空间的占用
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
      --警告异常 与错误异常的区别在于是否返回正确的返回码
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

  PROCEDURE Pro_Chek_Loab(i_Acctdt IN DATE, --数据日期
                          i_Brchno IN VARCHAR2, --业务机构
                          i_Cheksp IN VARCHAR2 --校验类别,明细校验、汇总校验
                          ) AS
    /************************************************************************
    过程中文名：贷款余额数据校验
    功能描述：  贷款余额数据校验
    编写人：    zhengmzh
    编写日期：  2013-01-14
    修改记录：
    *************************************************************************/
    /*o_Logcod VARCHAR2(255); -- 返回值临时定义
    o_Logdes VARCHAR2(255); -- 返回值临时定义*/
    l_Log    Pkg_Bdss_Constant.t_Log; --日志信息变量组
    v_Altime Bdss_Trlg.Bgtime%TYPE; --过程开始时间，用于准确计算整个过程的耗费时间
    v_Objtna Bdss_Trlg.Logdes%TYPE; --操作对象名称
    Err_Exception EXCEPTION; --错误异常
    Warn_Exception EXCEPTION; --警告异常
  BEGIN
    --0 初始化
    v_Altime     := Systimestamp;
    l_Log.Logcod := Pkg_Bdss_Constant.Logcod_Ok;
    l_Log.Procna := 'Pro_Chek_Loab';
    l_Log.Procna := g_Pkgname || '.' || l_Log.Procna;
    l_Log.Logobj := 'Pro_Chek_Loab';
  
    v_Objtna     := '存贷款统计标准化贷款余额';
    l_Log.Logdes := v_Objtna || '数据校验';
    --0.1 登记过程开始的日志
    Pkg_Bdss_Util.Pro_Cm_Writelog(i_Acctdt => i_Acctdt,
                                  i_Subsys => Pkg_Sdls_Constant.g_Subsys,
                                  i_Logcod => l_Log.Logcod,
                                  i_Logdes => '过程开始-' || l_Log.Logdes,
                                  i_Procna => l_Log.Procna,
                                  i_Bgtime => v_Altime);
  
    BEGIN
    
      --贷款余额校验
      l_Log.Logcod := Pkg_Bdss_Constant.Logcod_Ok;
      l_Log.Logkey := 'LOAB_CHECK';
      l_Log.Bgtime := Systimestamp;
      l_Log.Logdes := v_Objtna || '校验';
    
      IF i_Brchno IS NULL THEN
        l_Log.Logdes := l_Log.Logdes || '机构不能为空';
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
        --转换code结束
        l_Log.Rowcnt := SQL%ROWCOUNT;
        --提交隐性事务
        COMMIT;
        --登记日志信息
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
        l_Log.Logdes := Substr(l_Log.Logdes || '异常，异常信息：' || SQLERRM,
                               1,
                               Pkg_Bdss_Constant.Length_Logdes);
        RAISE Err_Exception;
    END;
    COMMIT;
    --3.8 登记整个过程完成的日志
    Pkg_Bdss_Util.Pro_Cm_Writelog(i_Acctdt => i_Acctdt,
                                  i_Subsys => Pkg_Sdls_Constant.g_Subsys,
                                  i_Logcod => l_Log.Logcod,
                                  i_Logdes => '过程完成',
                                  i_Procna => l_Log.Procna,
                                  i_Bgtime => v_Altime);
  
    /*--3.9 前述所有代码都成功执行后，重新给变量o_logcod和o_logdes赋值
    o_Logcod := Pkg_Bdss_Constant.Logcod_Ok;
    o_Logdes := Pkg_Bdss_Constant.Logdes_Ok;*/
  
  EXCEPTION
    WHEN Err_Exception THEN
      ROLLBACK; --减少对undo表空间的占用
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
      --警告异常 与错误异常的区别在于是否返回正确的返回码
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

  PROCEDURE Pro_Chek_Depb(i_Acctdt IN DATE, --数据日期
                          i_Brchno IN VARCHAR2, --业务机构
                          i_Cheksp IN VARCHAR2 --校验类别,明细校验、汇总校验
                          ) AS
    /************************************************************************
    过程中文名：存款余额数据校验
    功能描述：  存款余额数据校验
    编写人：    zhengmzh
    编写日期：  2013-01-14
    修改记录：
    *************************************************************************/
    /*o_Logcod VARCHAR2(255); -- 返回值临时定义
    o_Logdes VARCHAR2(255); -- 返回值临时定义*/
    l_Log    Pkg_Bdss_Constant.t_Log; --日志信息变量组
    v_Altime Bdss_Trlg.Bgtime%TYPE; --过程开始时间，用于准确计算整个过程的耗费时间
    v_Objtna Bdss_Trlg.Logdes%TYPE; --操作对象名称
    Err_Exception EXCEPTION; --错误异常
    Warn_Exception EXCEPTION; --警告异常
  BEGIN
    --0 初始化
    v_Altime     := Systimestamp;
    l_Log.Logcod := Pkg_Bdss_Constant.Logcod_Ok;
    l_Log.Procna := 'Pro_Chek_Depb';
    l_Log.Procna := g_Pkgname || '.' || l_Log.Procna;
    l_Log.Logobj := 'Pro_Chek_Depb';
  
    v_Objtna     := '存贷款统计标准化存款余额';
    l_Log.Logdes := v_Objtna || '数据校验';
    --0.1 登记过程开始的日志
    Pkg_Bdss_Util.Pro_Cm_Writelog(i_Acctdt => i_Acctdt,
                                  i_Subsys => Pkg_Sdls_Constant.g_Subsys,
                                  i_Logcod => l_Log.Logcod,
                                  i_Logdes => '过程开始-' || l_Log.Logdes,
                                  i_Procna => l_Log.Procna,
                                  i_Bgtime => v_Altime);
  
    BEGIN
    
      --贷款余额校验
      l_Log.Logcod := Pkg_Bdss_Constant.Logcod_Ok;
      l_Log.Logkey := 'DEPB_CHECK';
      l_Log.Bgtime := Systimestamp;
      l_Log.Logdes := v_Objtna || '校验';
    
      IF i_Brchno IS NULL THEN
        l_Log.Logdes := l_Log.Logdes || '机构不能为空';
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
        --转换code结束
        l_Log.Rowcnt := SQL%ROWCOUNT;
        --提交隐性事务
        COMMIT;
        --登记日志信息
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
        l_Log.Logdes := Substr(l_Log.Logdes || '异常，异常信息：' || SQLERRM,
                               1,
                               Pkg_Bdss_Constant.Length_Logdes);
        RAISE Err_Exception;
    END;
    COMMIT;
    --3.8 登记整个过程完成的日志
    Pkg_Bdss_Util.Pro_Cm_Writelog(i_Acctdt => i_Acctdt,
                                  i_Subsys => Pkg_Sdls_Constant.g_Subsys,
                                  i_Logcod => l_Log.Logcod,
                                  i_Logdes => '过程完成',
                                  i_Procna => l_Log.Procna,
                                  i_Bgtime => v_Altime);
  
    /*--3.9 前述所有代码都成功执行后，重新给变量o_logcod和o_logdes赋值
    o_Logcod := Pkg_Bdss_Constant.Logcod_Ok;
    o_Logdes := Pkg_Bdss_Constant.Logdes_Ok;*/
  
  EXCEPTION
    WHEN Err_Exception THEN
      ROLLBACK; --减少对undo表空间的占用
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
      --警告异常 与错误异常的区别在于是否返回正确的返回码
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
