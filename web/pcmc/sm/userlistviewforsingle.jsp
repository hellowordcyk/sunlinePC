<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.sunline.cn/jsp/common" prefix="sc"%>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<display:table uid="roww" name="jrafrpu.rspPkg.rspRcdDataMaps" style="width:100%;" class="list-table"
   requestURI="/httpprocesserservlet" requestURIcontext="false">
    <display:column title="序号" style="width:5%;">
        ${roww_rowNum }
    </display:column>
    <display:column property="usercode" title="用户号"/>
    <display:column title="用户名">
        <a href="javascript: void(0);" onclick="doDetial('${roww.userid }');">${roww.username }</a>
    </display:column>
    <display:column property="deptname" title="部门"/>
    <display:column property="phone" title="电话" />
    <display:column  title="冻结">
    <sc:optd value="${roww.disable}" type="dict" key="pcmc,boolflag"/>
    </display:column>
    <display:column  title="操作" >
        <sc:button value="详情" _class="edit" onclick="doDetial('${roww.userid }')"/>
    </display:column>
</display:table>
<script type="text/javascript" defer="defer">
<!--
function doDetial(userid){
    var url = '/pcmc/sm/userdetailforsingle.jsp?userid='+userid;
    var w = openModal(url,800,450);
    if (w!=null && w==true) {
        viewItem(jraftreemenu.treeContext.getSelectedNode());
    }
    //document.location.href = url;
}
//-->
</script>
