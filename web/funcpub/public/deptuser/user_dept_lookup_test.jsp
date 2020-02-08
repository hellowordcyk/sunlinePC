<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 公共控件测试页面
 * description: 
 *     1.公共控件测试页面
 * author: LongJiang
 * createtime: 20160809
 *--%>
<div class="pageContent">
    <div class="pageFormContent">
         <table class="form-table" cellpadding="0" cellspacing="0" >
            <tr>
                <td class="form-label">单选部门</td>
                <td class="form-value">
                    <input type="hidden" name="single_dept_id"/>
                    <input type="hidden" name="single_dept_code"/>
                    <input type="text" name="single_dept_name"/>
                    <a class="btnLook" title="单选部门"  lookupGroup="" width="900" height="500"
                     href="/funcpub/public/deptuser/deptLookup_selectone.jsp?lookupid=single_dept_id&lookupcode=single_dept_code&lookupname=single_dept_name"></a>
                    
                </td>
            </tr>
            
             <tr>
                <td class="form-label">多选部门</td>
                <td class="form-value">
                    <input type="hidden" name="mutil_dept_id"/>
                    <input type="hidden" name="mutil_dept_code"/>
                    <input type="text" name="mutil_dept_name"/>
                    <a class="btnLook" title="多选部门"   lookupGroup="" width="900" height="500"
                     href="/funcpub/public/deptuser/deptLookupMulti.jsp?lookupid=mutil_dept_id&lookupname=mutil_dept_name"></a>
                </td>
            </tr>
            
             <tr>
                <td class="form-label">单选用户</td>
                <td class="form-value">
                    <input type="hidden" name="single_user_id"/>
                    <input type="hidden" name="single_user_code"/>
                    <input type="text" name="single_user_name"/>
                    <a class="btnLook" title="单选用户" lookupGroup=""  width="900" height="500"
                     href="/funcpub/public/deptuser/userLookupSingle.jsp?lookupid=single_user_id&lookupcode=single_user_code&lookupname=single_user_name"></a>
                </td>
            </tr>
            
             <tr>
                <td class="form-label">多选用户</td>
                <td class="form-value">
                    <input type="hidden" name="mutil_user_id"/>
                    <input type="hidden" name="mutil_user_code"/>
                    <input type="text" name="mutil_user_name"/>
                    <a class="btnLook" title="多选用户" lookupGroup=""  width="900" height="500"
                     href="/funcpub/public/deptuser/userLookupMulti.jsp?lookupid=mutil_user_id&lookupname=mutil_user_name"></a>
                
                </td>
            </tr>
            <tr>
                <td class="form-label">树形用户</td>
                <td class="form-value">
                    <input type="hidden" name="mutil_user_id1"/>
                    <input type="hidden" name="mutil_user_code1" id="mutil_user_code_id"/>
                    <input type="text" name="mutil_user_name1"/>
                    <a class="btnLook" title="多选用户" lookupGroup=""  width="1000" height="600"
                     href="/funcpub/public/deptuser/userTreeOptionDialog.jsp?lookupid=mutil_user_id1&lookupcode=mutil_user_code1&lookupname=mutil_user_name1&elmId={mutil_user_code_id}"></a>
                
                </td>
            </tr>
            
            
            <tr>
                <td class="form-label">树形机构</td>
                <td class="form-value">
                    <input type="hidden" name="tree_deptid" id="tree_deptid"/>
                    <input type="hidden" name="tree_deptcode" id="tree_deptcode"/>
                    <input type="text" name="tree_deptname"/>
                    <a class="btnLook" title="多选机构" lookupGroup=""  width="1000" height="500"
                     href="/funcpub/public/deptuser/deptTreeOptionDialog.jsp?lookupid=tree_deptid&lookupcode=tree_deptcode&lookupname=tree_deptname&elmId={tree_deptid}"></a>
                </td>
            </tr>
            
            <tr>
                <td class="form-label">指标</td>
                <td class="form-value">
                    <input type="hidden" name="kpiCode"  /> 
                    <input type="text" name="kpiName" /> 
                    <a class="btnLook publicOptionControls" type="kpi" multi="true" filter="&area=all&kpiType=B,C,I&applyType=1,2"  
                        seletedInput="kpiCode" selectedColumn="KPI_CODE" callback="kpiOptionCallBack">
                    </a>
                </td>
            </tr>
            
         </table>
    </div>
</div>

<script>
function kpiOptionCallBack(kpiArray,kpi){
    $("[name='kpiCode']",navTab.getCurrentPanel()).val(kpi.kpiCode);
    $("[name='kpiName']",navTab.getCurrentPanel()).val(kpi.kpiName);
}
</script>
