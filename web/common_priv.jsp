<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String jspname = request.getRequestURI();
    request.setAttribute("jsppath", jspname);
%>
<sc:doPost var="recordList" scope="request" sysName="pcmc" 
           oprId="privActor" action="getJSPPriv" params="jsppath=${jsppath}"></sc:doPost>
<script type="text/javascript" defer="defer">
initPageStyle();
function initPageStyle() {
<%-- 启动了权限管理功能，则判断当前用户是否具有访问权限 --%>
<c:if test="${empty recordList.rspRcdDataMaps[0].hasStart}">
  <%-- 有权限 --%>
  <c:if test="${empty recordList.rspRcdDataMaps}">
  <%-- 页面要权限管理，但又没有配置权限时，提示系统错误！ --%>
    Jraf.showMessageBox({
        text: '<span class="error">对不起，未配置权限之前页面功能不可用！请系统管理员配置JSP受管对象的权限.</span>',
        onClose: function (){
            <%--//window.location.href = "<%=request.getContextPath()%>/error.jsp";--%>
            document.write("<span style='font-size: 14px; font-weight: bold;'>对不起，未配置权限之前页面功能不可用！请系统管理员配置JSP受管对象的权限.</span>");
            window.close();
        }
    });
  </c:if>
  <c:forEach var="record" items="${recordList.rspRcdDataMaps}">
    <c:choose>
      <c:when test="${ not empty record.usercode}">
          <%-- 当前用户的权限 --%>
          if ($("${record.objtid}")){
              var objtid = $("${record.objtid}");
              if("disabled" in objtid) {
                  objtid.disabled = false;
              } else {
                  objtid.show();
              }
              <%-- 避免后台查询数据有重复情况 --%>
              objtid.writeAttribute("hasPriv", "true");
          }
      </c:when>
      <c:otherwise>
          <%-- 当前用户无权限的置为不可用--%>
          if ($("${record.objtid}")){
              var objtid = $("${record.objtid}");
              //有hasPriv属性的且为“true”,表示有权限了
              if(objtid.readAttribute("hasPriv") != "true") {
                  if("disabled" in objtid) {
                      objtid.disabled = true;
                  } else {
                      objtid.hide();
                  }
              }
          }
      </c:otherwise>
    </c:choose>
  </c:forEach>
</c:if>
}
</script>
