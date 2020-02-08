<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunline.bimis.pcmc.pm.PmInformations"%>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="com.sunline.jraf.web.Format"%>
<%@ page import="com.sunline.jraf.conf.BimisConf"%>
<%@ page import="java.util.List"%>
<%@ page import="org.jdom.*"%>
<%
    String infoid = request.getParameter("infoid");
	Element resData = PmInformations.getSingleInfomations(Long.parseLong(infoid));
	String title = "";
	String content = "";
	String createtime= "";
	String begindt = Format.dateFormat(resData.getChildTextTrim("dpcstart"));
	String enddt = Format.dateFormat(resData.getChildTextTrim("dpcend"));
	
    if (begindt.equals("1900-01-01")){
		begindt = "无";
    }
    if (enddt.equals("1900-01-01")){
		enddt = "无";
    }

	if(resData != null)
	{
		title = resData.getChildText("title");
		content = resData.getChildText("content");
        createtime = resData.getChildText("createtime");

		if (content!=null)
		{
			content=content.replaceAll("\n","<br>");
			content=content.replaceAll(" ","&nbsp;");
		}
	}
	Element fileData = PmInformations.getAdjunctList(Long.parseLong(infoid));
	List fileList = fileData.getChildren("Record");
%>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title><%=BimisConf.getSiteName()%></title>
	<noscript><iframe src="*.htm"></iframe></noscript>
	<script language="javascript" src="menu.js"></script>
	
	<style type="text/css">
		body {background-image:  url(images/bg_maintop.jpg);background-attachment:fixed;
			background-repeat:repeat-x;margin-left: 0px;margin-top: 0px;margin-right: 0px;margin-bottom: 0px;}
		td, th {font-family: Arial, Helvetica, sans-serif;font-size: 12px;line-height: 24px;color: #000000;}
		.title_news {font-family: "宋体";font-size: 24px;text-decoration: none ; font-weight: bold;line-height: 26px; color: #003CC8}
		.text_blue {font-family: Arial, Helvetica, sans-serif;font-size: 12px;line-height: 24px;color:#110CA6;}
		p{ padding-top:5px; padding-left:6px; padding-right:6px;}
		p.news{line-height: 150%; font-size: 16px; color: #000000; text-decoration: none; font-family: "宋体"}
		.text_yellow {font-family: Arial, Helvetica, sans-serif;font-size: 12px;line-height: 24px;color:#cc6600;}
		.navy {  font-family: "宋体"; font-size: 12px; line-height: 16px; color: #003cc8; text-decoration: none; border: none}	
	</style>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#000000">
	<tr><td height="1"></td></tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" height="1">
	<tr><td></td></tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0" >
	<tr><td>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
			<tr><td height="13"></td></tr>
		</table>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
			<tr>
				<td width="25" rowspan="3">&#160;</td>
				<td width="1" bgcolor="#B5B5B5"></td>
				<td width="94%" valign="top">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr><td bgcolor="#B5B5B5" height="1"></td></tr>
					</table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="30">&#160;</td>
							<td align="center">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr><td align="center" class="title_news" height="60"><%=title%></td></tr>
									<tr><td align="center" bgcolor="#B9B9B9"  width="1" height="1"></td></tr>
									<tr><td align="center" width="1" height="1"/></td></tr>
									<tr>
										<td align="center" bgcolor="#E7E7E7" class="txt12" height="20">
											<table width="100%"  border="0">
			  									<tr>
												    <td width="10%" bgcolor="#efefef"><div align="right">作者：</div></td>
												    <td width="84" nowrap class="text_blue"> <%=resData.getChildTextTrim("username")%></td>
												    <td width="10%" bgcolor="#EFEFEF"><div align="right">发布时间：</div></td>
												    <td width="84" nowrap class="text_blue"><%=Format.dateFormat(createtime)%></td>
												    <td width="10%" bgcolor="#EFEFEF"><div align="right">有效期：</div></td>
												    <td class="text_blue">从<%=begindt%>到<%=enddt%></td>
												    <td align=right>【字体：<a href="#" onclick="Zoom.style.fontSize='20px';" class="navy">大</a> <a href="#" onclick="Zoom.style.fontSize='16px';" class="navy">中</a> <a href="#" onclick="Zoom.style.fontSize='13px';" class="navy">小</a>】</td>
												</tr>
											</table>
										</td>
									</tr>
								</table>
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr><td align="center" bgcolor="#B9B9B9" width="1" height="1"/></td></tr>
								</table>
								<table width="100%" border="0" height="35" cellspacing="0">
									<tr><td valign="top" align="center">
										<table width="100%" border="0" cellspacing="0" cellpadding="0">
											<tr><td height="35" width="100%"></td></tr>
										</table>
										<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
											<tr><td><p class="news"><font id="Zoom"><%=content%></font></p></td></tr>
										</table>
										<table width="100%" border="0" cellspacing="0" cellpadding="0">
											<tr><td height="20" width="100%"></td></tr>
										</table>
										<table width="100%" border="0" cellspacing="0" cellpadding="0">
											<tr><td>&#160;</td></tr>
											<tr><td bgcolor="#CCCCCC" height="1"></td></tr>
											<tr><td height="15">&#160;</td></tr>
										</table>
										<table width="100%" border="0" cellspacing="0" cellpadding="0">
											<tr><td height="15" width="100%"></td></tr>
										</table>
										<table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
											<tr>
												<%
													if (fileList !=null && fileList.size()>0){
												%>
												<td width="40" valign="top" nowrap>附件：</td>
												<td width="54" align="left" valign="top"><img src="../../images/pic01/fujian.jpg" width="54" height="46"></td>
												<td><p class="text_blue">
													<%
														for (int i=0;i<fileList.size();i++){
															Element eltFile = (Element)fileList.get(i);
															String realfile = eltFile.getChildTextTrim("frealname");
															String diskfile = eltFile.getChildTextTrim("fdiskname");
															diskfile = Crypto.encode(request,diskfile);
															String fileid = eltFile.getChildTextTrim("fileid");
													%>
													<a title="下载“<%=realfile%>”" href='/public/downloadbimisfile.jsp?fileid=<%=fileid%>' target=_blank><%=realfile%></a><br>
		        <span class="text_yellow">*点击链接可查看内容或下载附件</span><br>
		        									<%}%>
		        									</p></td>
		        									<%}%>
		        								</tr>
		        							</table>
		        						</td>
		        					</tr>
		        				</table>
		        			</td>
		        			<td width="30">&#160;</td>
		        		</tr>
		        	</table>
		        </td>
		        <td width="1" bgcolor="#B5B5B5"></td>
		        <td width="3" bgcolor="#DEDEDE" valign="top" rowspan="3">
		        	<table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
		        		<tr><td height="5"></td></tr>
		        	</table>
		        </td>
				<td width="38" rowspan="3"></td>
			</tr>
			
			<tr><td  colspan="3" bgcolor="#B5B5B5" height="1" align=right></td></tr>
			<tr><td colspan="3" bgcolor="#E0E0E0" align="left" height="3">
				<table width="5" border="0" cellspacing="0" cellpadding="0" height="3">
					<tr><td bgcolor="#FFFFFF"></td></tr>
				</table>
			</td></tr>
		</table>

	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr><td height="8" width="100%" bgcolor="#FFFFFF"></td></tr>
	</table>
</td>
</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
	<tr><td height="75" valign="top"></td></tr>
</table>

</body>
</html>