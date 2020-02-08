<%@ taglib prefix="sc" uri="http://www.sunline.cn/jsp/common" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>全局搜索功能</title>

</head>

<body>

    <div class="pageHeader">
        <c:if test="${not empty jrafrpu.rspPkg.rspRcdDataMapsResults1}">
            <table class="table" width="100%" >
            <thead>
                <tr>
                    <th style="text-align: left;background: #FFFFFF">功能列表：</th>
                </tr>
                <tr>
                    <th style="text-align: center">序号</th>
                    <th style="text-align: center">功能名称</th>
                </tr>

            </thead>
            <tbody>
                    <c:forEach var="record" items="${jrafrpu.rspPkg.rspRcdDataMapsResults1}" varStatus="status" >
                            <tr class='${status.index%2 != 0 ? "evenrow" : ""}' >
                                <td style="color:#1e81d2;text-align: center">
                                        ${status.index+1}
                                </td>
                                <td  style="text-align: center" >
                                    <a href="javascript:goToFunction('${record.LINKURL }','${record.MENUNAME }','${record.MENUTYPE}')">${record.MENUNAME }</a>
                                </td>
                            </tr>
                    </c:forEach>
                 </tbody>
            </table>
        </c:if>

        <c:if test="${not empty jrafrpu.rspPkg.rspRcdDataMapsResults2}">
            <table class="table" width="100%" border="0">
                <thead>
                <th style="text-align: left;background: #FFFFFF">指标列表：</th>
                </tr>
                <tr>
                    <th style="text-align: center">序号</th>
                    <th style="text-align: center">功能名称</th>
                </tr>
                </thead>
                <tbody>
                    <c:forEach var="record" items="${jrafrpu.rspPkg.rspRcdDataMapsResults2}" varStatus="status" >
                    <tr class='${status.index%2 != 0 ? "evenrow" : ""}' >
                        <td style="color:#1e81d2;text-align: center">
                                ${status.index+1}
                        </td>
                        <td  style="text-align: center" >
                            <a href="javascript:goToFunction('${record.LINKURL }','${record.MENUNAME }','${record.MENUTYPE}')">${record.MENUNAME }</a>
                        </td>
                    </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:if>
        <c:if test="${not empty jrafrpu.rspPkg.rspRcdDataMapsResults3}">
            <table class="table" width="100%" border="0">
                <thead>
                <th style="text-align: left;background: #FFFFFF">零售方案列表：</th>
                </tr>
                <tr>
                    <th style="text-align: center">序号</th>
                    <th style="text-align: center">功能名称</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="record" items="${jrafrpu.rspPkg.rspRcdDataMapsResults3}" varStatus="status" >
                    <tr class='${status.index%2 != 0 ? "evenrow" : ""}' >
                        <td style="color:#1e81d2;text-align: center">
                                ${status.index+1}
                        </td>
                        <td  style="text-align: center" >
                            <a href="javascript:goToFunction('${record.LINKURL }','${record.MENUNAME }','${record.MENUTYPE}')">${record.MENUNAME }</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:if>
        <c:if test="${not empty jrafrpu.rspPkg.rspRcdDataMaps}">
            <table class="table" width="100%" border="0">
                <thead>
                <th style="text-align: left;background: #FFFFFF">对公方案列表：</th>
                </tr>
                <tr>
                    <th style="text-align: center">序号</th>
                    <th style="text-align: center">功能名称</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="record" items="${jrafrpu.rspPkg.rspRcdDataMaps}" varStatus="status" >
                    <tr class='${status.index%2 != 0 ? "evenrow" : ""}' >
                        <td style="color:#1e81d2;text-align: center">
                                ${status.index+1}
                        </td>
                        <td  style="text-align: center" >
                            <a href="javascript:goToFunction('${record.LINKURL }','${record.MENUNAME }','${record.MENUTYPE}')">${record.MENUNAME }</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:if>
    </div>
<script type="text/javascript">

  function goToFunction(url,menuname,type) {

      $.pdialog.closeCurrent();
      var temp_url2 = '';

      if(url.indexOf("sysName")!=-1){

          temp_url2+=url.split("?")[0];

          var otherSource="&forward="+'<sc:fmt type="crypto" value="/sunrpt/report/export_show.jsp"/>'+"&"+url.split("?")[1].split("&")[4]+"&"+url.split("?")[1].split("&")[5];
          temp_url2+="?sysName="+'<sc:fmt type="crypto" value="sunrpt"/>';
          temp_url2+="&oprID="+'<sc:fmt type="crypto" value="sunrpt-report"/>';
          temp_url2+="&actions="+'<sc:fmt type="crypto" value="queryReport"/>'
          temp_url2+=otherSource;
          var temp_url =  temp_url2;
      }else{
          var temp_url = url;
      }

      if(type==1){
          navTab.openTab("export_show",temp_url,{title : menuname,type:'POST',data:{},fresh:false});
      }else if(type==2){
          navTab.openTab("kpiInfoQuery",temp_url,{title : "指标库",type:'POST',data:{"param.mainKpiName":menuname},fresh:false});
      }else if(type==3){
          navTab.openTab("manager_cm",temp_url,{title : "行员考核方案配置",type:'POST',data:{"wayName":menuname},fresh:false});
      } else if(type==4){
          navTab.openTab("manager_org",temp_url,{title : "机构考核方案配置",type:'POST',data:{"wayName":menuname},fresh:false});
      }
  }
</script>
</body>





