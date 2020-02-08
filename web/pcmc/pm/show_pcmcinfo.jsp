<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>公告信息</title>
    <%@ include file="/common.jsp"%>
    <%@ include file="/common_tag.jsp"%>
    <style type="text/css">
        .notice-main {
            padding: 15px;
            margin: 15px;
            border: 4px double #ccc;
            background: #fff url("../images/index/content-body.gif") repeat-x scroll top
        }
        .notice-title {
            height: 35px;
            line-height: 35px;
            font-family: "微软雅黑", "黑体";
            font-size: 22px;
            text-align: center;
            overflow: hidden;
        }
        .notice-top {
            height: 22px;
            line-height: 22px;
            pading: 5px;
            font-family: Arial, Helvetica, sans-serif;
            font-size: 12px;
            color: #666;
            text-align: center;
            vertical-align: middle;
            overflow: hidden;
            border-bottom: 1px dashed #ccc;
        }
        .notice-content {
            font-size: 14px;
            line-height: 23px;
            font-family: "宋体";
            margin: 5px 0 5px 0;
            padding: 5px 0 5px 0;
            overflow: auto;
            min-height: 200px;
            word-break: break-all;
            white-space: normal;
        }
        .notice-bottom {
            height: 22px;
            line-height: 22px;
            pading: 5px;
            font-family: Arial, Helvetica, sans-serif;
            font-size: 12px;
            text-align: center;
            vertical-align: middle;
            overflow: hidden;
            border: 1px dashed #ccc;
        }
    </style>
</head>
<body>
<sc:form name="frmcog"  action="/xmlprocesserservlet" sysName="pcmc" oprID="info" 
    actions="updatePcmcInfo" forward="/pcmc/message/query_pcmcinfo.jsp" method="post">
    <div class="notice-main" >
        <div class="notice-title">${jrafrpu.rspPkg.rspRcdDataMaps[0].title }</div>
        <div class="notice-top">
            <span>生效时间：</span><span><sc:fmt type="date" pattern="yyyy-MM-dd HH:mm:ss" name="startdt" index="1" /></span>
            &nbsp;&nbsp;
            <span>终止时间：</span><span><sc:fmt type="date" pattern="yyyy-MM-dd HH:mm:ss" name="enddt" index="1" /></span>
        </div>
        <div class="notice-content" style="min-height: 240px;overflow: auto;"><pre style="white-space: normal; word-break: break-all">${jrafrpu.rspPkg.rspRcdDataMaps[0].content }</pre></div>
        <div class="notice-bottom">
            <span>附件下载：</span>
            <span>
                <c:choose>
                    <c:when test="${empty jrafrpu.rspPkg.rspRcdDataMaps[0].filename}">无
                    </c:when>
                    <c:otherwise>
                        <a href="#;returnValue=false;" target="download" onclick="download(this);">
                            <sc:value name='/DataPacket/Response/Data/Record/filename' />
                        </a>
                    </c:otherwise>
                </c:choose>
            </span>
        </div>
    </div>
  
</sc:form>
</body>
<script language="javascript">
function download(obj){
    var url = "/public/downloaddatafile.jsp?decodeFlag=true&filename=";
	var filename = "<sc:value name='/DataPacket/Response/Data/Record/filename'/>";
    url = url + filename;
	obj.href = encodeURI(encodeURI(url));
}
</Script>
</html>