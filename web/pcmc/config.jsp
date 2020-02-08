<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="org.jdom.*" %>
<%@ page import="org.jdom.input.*" %>
<%@ page import="org.jdom.output.*" %>
<%@ page import="org.jdom.xpath.XPath" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="com.sunline.jraf.conf.*"%>
<% request.setCharacterEncoding("UTF-8"); %>
<%
   String errortxt="";
   String action = request.getParameter("act");
   boolean isUpdate=false;
   FileOutputStream fo = null;
   if(action==null || action.length()==0){
      action="show";
   }
	if(action.equals("update")) isUpdate=true;

   //参数设置
   String temppath=request.getParameter("temppath");
   String debug=request.getParameter("debug");
   String appname=request.getParameter("appname");
   String sitename=request.getParameter("sitename");
   String applogpath=request.getParameter("applogpath");
   String log4jconfig=request.getParameter("log4jconfig");

   String users_check=request.getParameter("users_check");
   String users_local=request.getParameter("users_local");
   String[] user_names=request.getParameterValues("user_name");
   String[] user_enables=request.getParameterValues("user_enable");
   String[] user_syncs=request.getParameterValues("user_sync");
   String[] user_repositorys=request.getParameterValues("user_repository");   
   String[] user_tables=request.getParameterValues("user_table");

   String ReportServer_URL=request.getParameter("ReportServer_URL");   
   String BIReport_URL=request.getParameter("BIReport_URL");
   String MingReport_URL=request.getParameter("MingReport_URL");
   
   String FileService_destination=request.getParameter("FileService_destination");
   String FileService_type=request.getParameter("FileService_type");
   String FileService_maxsize=request.getParameter("FileService_maxsize");
   
   String MailService_postmaster=request.getParameter("MailService_postmaster");
   String MailService_servername=request.getParameter("MailService_servername");
   String MailServer_home=request.getParameter("MailServer_home");
   String MailServer_configfile=request.getParameter("MailServer_configfile");
   String pop3server_port=request.getParameter("pop3server_port");
   String pop3server_host=request.getParameter("pop3server_host");
   String pop3server_connectiontimeout=request.getParameter("pop3server_connectiontimeout");
   String pop3server_timeout=request.getParameter("pop3server_timeout");
   String smtpserver_port=request.getParameter("smtpserver_port");
   String smtpserver_host=request.getParameter("smtpserver_host");
   String smtpserver_connectiontimeout=request.getParameter("smtpserver_connectiontimeout");
   String smtpserver_timeout=request.getParameter("smtpserver_timeout");
   String smtpserver_maxmessagesize=request.getParameter("smtpserver_maxmessagesize");
   String smtpserver_authRequired=request.getParameter("smtpserver_authRequired");
   
   String bbsService_name=request.getParameter("bbsService_name");
   String bbsService_path=request.getParameter("bbsService_path");   
   
   String filename=FileUtil.getHomePath()+"config.xml";
   File file = new File(filename);
   if(!file.exists()){
      out.println("系统配置文件["+filename+"]不存在");
      return;
   }
   SAXBuilder builder = new SAXBuilder();
   builder.setExpandEntities(false); 
	Document confDoc = builder.build(file);  
	if(confDoc==null){
	   out.println("打开系统配置文件出错");
	   return;
	}	
	Element root=confDoc.getRootElement();
	Element node=null;

   node = (Element)XPath.selectSingleNode(root,"temppath");
   if(node!=null){              
      if(!isUpdate) 
         temppath=node.getTextTrim();
      else
         node.setText(temppath);
   }

   node = (Element)XPath.selectSingleNode(root,"debug");
   if(node!=null){              
      if(!isUpdate) 
         debug=node.getTextTrim();
      else{
         node.setText(debug);
         BimisConf.setDebug(Boolean.valueOf(debug).booleanValue());
         }
   }   

   node = (Element)XPath.selectSingleNode(root,"bimisconfig/appname");
   if(node!=null){              
      if(!isUpdate) 
         appname=node.getTextTrim();
      else
         node.setText(appname);
   }   

   node = (Element)XPath.selectSingleNode(root,"bimisconfig/sitename");
   if(node!=null){              
      if(!isUpdate) 
         sitename=node.getTextTrim();
      else
         node.setText(sitename);
   }   

   node = (Element)XPath.selectSingleNode(root,"bimisconfig/applogpath");
   if(node!=null){              
      if(!isUpdate) 
         applogpath=node.getTextTrim();
      else
         node.setText(applogpath);
   }
   
   node = (Element)XPath.selectSingleNode(root,"bimisconfig/log4jconfig");
   if(node!=null){              
      if(!isUpdate) 
         log4jconfig=node.getAttributeValue("propfile");
      else
         node.setAttribute("propfile",log4jconfig);
   }
    

   node = (Element)XPath.selectSingleNode(root,"auth/users");
   List users=null;
   if(node!=null){              
      Element nu=null;
      users = node.getChildren("user");
      if(!isUpdate){
         users_check=node.getAttributeValue("check");
         users_local=node.getAttributeValue("local");
         if(users!=null){
            user_names = new String[users.size()];
            user_enables = new String[users.size()];
            user_syncs = new String[users.size()];
            user_repositorys = new String[users.size()];
            user_tables = new String[users.size()];
            for(int i=0;i<users.size();i++){
               nu = (Element)users.get(i);
               user_names[i]=nu.getAttributeValue("name");
               user_enables[i]=nu.getAttributeValue("enable");
               user_syncs[i]=nu.getAttributeValue("sync");
               user_repositorys[i]=nu.getAttributeValue("repository");
               user_tables[i]=nu.getAttributeValue("table");
            }
         }
      }
      else{
         node.setAttribute("check",users_check);
         node.setAttribute("local",users_local);
         for(int i=0;i<user_names.length;i++){
            if(users!=null && users.size()>i){
               nu = (Element)users.get(i);
            }else{
               nu=new Element("user");
               node.addContent(nu);
            }
            nu.setAttribute("name",user_names[i]);
            nu.setAttribute("enable",user_enables[i]);
            nu.setAttribute("sync",user_syncs[i]);
            nu.setAttribute("repository",user_repositorys[i]);
            nu.setAttribute("table",user_tables[i]);
         }
      }
   }   
   
   node = (Element)XPath.selectSingleNode(root,"ReportServer");
   if(node!=null){              
      if(!isUpdate) 
         ReportServer_URL=node.getAttributeValue("URL");
      else
         node.setAttribute("URL",ReportServer_URL);
   }
   node = (Element)XPath.selectSingleNode(root,"ReportServer/BIReport");
   if(node!=null){              
      if(!isUpdate) 
         BIReport_URL=node.getAttributeValue("URL");
      else
         node.setAttribute("URL",BIReport_URL);
   }
   node = (Element)XPath.selectSingleNode(root,"ReportServer/MingReport");
   if(node!=null){              
      if(!isUpdate) 
         MingReport_URL=node.getAttributeValue("URL");
      else
         node.setAttribute("URL",MingReport_URL);
   }    
   
   node = (Element)XPath.selectSingleNode(root,"FileService/Repository");
   if(node!=null){              
      if(!isUpdate){ 
         FileService_destination=node.getAttributeValue("destination");
         FileService_type=node.getAttributeValue("type");
      }
      else{
         node.setAttribute("destination",FileService_destination);
         node.setAttribute("type",FileService_type);
      }
   }

   node = (Element)XPath.selectSingleNode(root,"FileService/maxsize");
   if(node!=null){              
      if(!isUpdate) 
         FileService_maxsize=node.getTextTrim();
      else
         node.setText(FileService_maxsize);
   } 
     
   node = (Element)XPath.selectSingleNode(root,"MailService/postmaster");
   if(node!=null){              
      if(!isUpdate) 
         MailService_postmaster=node.getTextTrim();
      else
         node.setText(MailService_postmaster);
   }
   node = (Element)XPath.selectSingleNode(root,"MailService/servername");
   if(node!=null){              
      if(!isUpdate) 
         MailService_servername=node.getTextTrim();
      else
         node.setText(MailService_servername);
   }    

   node = (Element)XPath.selectSingleNode(root,"MailService/MailServer[@enable='true']");
   if(node!=null){
      Element node1 = node.getChild("home");
      if(node1!=null){
         if(!isUpdate) 
            MailServer_home=node1.getTextTrim();
         else
            node1.setText(MailServer_home);
      }
      node1 = node.getChild("configfile");
      if(node1!=null){
         if(!isUpdate) 
            MailServer_configfile=node1.getTextTrim();
         else
            node1.setText(MailServer_configfile);
      }
      node = (Element)XPath.selectSingleNode(node,"pop3server[@enabled='true']");
      node1 = node.getChild("port");
      if(node1!=null){
         if(!isUpdate) 
            pop3server_port=node1.getTextTrim();
         else
            node1.setText(pop3server_port);
      }      
      node1 = node.getChild("host");
      if(node1!=null){
         if(!isUpdate) 
            pop3server_host=node1.getTextTrim();
         else
            node1.setText(pop3server_host);
      }
      node1 = node.getChild("connectiontimeout");
      if(node1!=null){
         if(!isUpdate) 
            pop3server_connectiontimeout=node1.getTextTrim();
         else
            node1.setText(pop3server_connectiontimeout);
      }
      node1 = node.getChild("timeout");
      if(node1!=null){
         if(!isUpdate) 
            pop3server_timeout=node1.getTextTrim();
         else
            node1.setText(pop3server_timeout);
      }      
   }   


   node = (Element)XPath.selectSingleNode(root,"MailService/smtpserver[@enabled='true']");
   if(node!=null){
      Element node1 = node.getChild("port");
      if(node1!=null){
         if(!isUpdate) 
            smtpserver_port=node1.getTextTrim();
         else
            node1.setText(smtpserver_port);
      }
      node1 = node.getChild("host");
      if(node1!=null){
         if(!isUpdate) 
            smtpserver_host=node1.getTextTrim();
         else
            node1.setText(smtpserver_host);
      }
      node1 = node1 = node.getChild("connectiontimeout");
      if(node1!=null){
         if(!isUpdate) 
            smtpserver_connectiontimeout=node1.getTextTrim();
         else
            node1.setText(smtpserver_connectiontimeout);
      }      
      node1 = node.getChild("timeout");
      if(node1!=null){
         if(!isUpdate) 
            smtpserver_timeout=node1.getTextTrim();
         else
            node1.setText(smtpserver_timeout);
      }
      node1 = node.getChild("maxmessagesize");
      if(node1!=null){
         if(!isUpdate) 
            smtpserver_maxmessagesize=node1.getTextTrim();
         else
            node1.setText(smtpserver_maxmessagesize);
      }
      node1 = node.getChild("authRequired");
      if(node1!=null){
         if(!isUpdate) 
            smtpserver_authRequired=node1.getTextTrim();
         else
            node1.setText(smtpserver_authRequired);
      }      
   }   
 
   node = (Element)XPath.selectSingleNode(root,"bbsService/bbsserver[@enabled='true']");
   if(node!=null){              
      if(!isUpdate){ 
         bbsService_name=node.getAttributeValue("name");
         bbsService_path=node.getAttributeValue("path");
      }
      else{
         node.setAttribute("name",bbsService_name);
         node.setAttribute("path",bbsService_path);
      }
   }   


   try{
   	if(!isUpdate){
   	      confDoc=null;
   	      node=null;
   	      root=null;
   	   }else{
   	      if (!file.exists()) {
   	        file.mkdirs();
   	      }
   	      Format format = Format.getRawFormat();
   	      format.setOmitDeclaration(false);
   	      format.setOmitEncoding(false);
   	      format.setEncoding("UTF-8");
   	      XMLOutputter docWriter = new XMLOutputter(format);
   	      fo = new FileOutputStream(file, false);
   	      docWriter.output(confDoc, fo);
   	      
   	   }
   }catch(Exception e){
   }finally{
	   try {
		   fo.flush();
		   fo.close();
		} catch (IOException e) {
		}
   }
   
          

      
   BimisConf.doReload();

%>
<html>
<%@ include file="/public/checkLogin.jsp"%>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>系统配置</title>
</head>
<BODY  background="/images/background.gif" style="BORDER-RIGHT: medium none; BORDER-TOP: medium none; MARGIN: 0px; BORDER-LEFT: medium none; BORDER-BOTTOM: medium none" bgColor=#ffffff>
<p align="center"><font size="3" color="#ff00ff">配置文件:<%=filename%></font></p>
<%
   if(errortxt.length()>0){
%>
   <p align="center"><font size="3" color="#ff0000">出错:<%=errortxt%></font></p>
<%  
      return; 
   }
   if(isUpdate){
%>
<p align="center">配置文件更新成功!<br>
<a href="/governor/initlogin/config.jsp">返回</a>
</p>
<%
   }
%>

<form name="config" method="post">
<input type="hidden" name="act" value="show">

<TABLE cellSpacing=0 cellPadding=0 width="98%" align=center border=0 >
   <TR>
      <TD colspan="2" align="center">
<TABLE id ="tabpane" CELLSPACING=0 CELLPADDING=0 border=0 align="center" width="98%" style="cursor:hand;font-size:12pt">
   <TR>
   	<td  name ="prof" width="1%" nowrap bgcolor="blue" onclick="showme(this)" style="color:red;" >服务器属性
   	   </td>
   	<td width="4" nowrap bgcolor="black"></td>
   	<td name ="auth" width="1%" nowrap bgcolor="#ffffff" onclick="showme(this)">用户服务器设置
   	   </td>
   	<td width="4" nowrap bgcolor="black"></td>
   	<td name ="report" width="1%" nowrap bgcolor="#ffffff" onclick="showme(this)">报表服务器配置
   	   </td>
   	<td width="4" nowrap bgcolor="black"></td>
   	<td name ="file" width="1%" nowrap bgcolor="#ffffff" onclick="showme(this)">文件服务器配置
   	   </td>
   	<td width="4" nowrap bgcolor="black"></td>
   	<td name ="email" width="1%" nowrap bgcolor="#ffffff" onclick="showme(this)" >电子邮件服务器定义
   	   </td>
   	<td width="4" nowrap bgcolor="black"></td>
   	<td name ="bbs" width="1%" nowrap bgcolor="#ffffff" onclick="showme(this)" >论坛服务器配置
   	   </td>
   	<td width="80%" >&nbsp;</td>
	</TR>
   <TR>
   	<td height="5" width="100%" colspan="12" bgcolor="#0000ff">
   	   </td>
	</TR>	
</TABLE>         
      </TD>
   </TR>
   <TR id="prof" style="display:inline;">
      <TD  colspan="2" align="center">
         <table  cellSpacing=0 cellPadding=1 width="98%" align="center" border=0 class="defaultTable">
            <tr align="left">
               <td colspan="2" background="/images/navigation_ico_2.gif" class="navigation">
                  <font color="#00ffff">服务器属性</font></td>
            </tr> 
            <TR>
               <TD  align="right" width="1%" nowrap><b>临时文件目录:</b></TD>
               <TD ><input type="text" name="temppath" size="40" class="inputtext" value="<%=temppath%>" ></TD>
            </TR>
            <TR>
               <TD  ALIGN="RIGHT" nowrap><b>服务器运行模式：</b></TD>
               <TD>
                  <select name="debug" class="inputtext">
                     <option value="true" <%if(debug.equals("true")) out.print("selected");%>>调试</option>
                     <option value="false" <%if(!debug.equals("true")) out.print("selected");%>>正常</option>
                  </select>
               </TD>
            </TR>
            <TR>
               <TD  ALIGN="RIGHT" nowrap><b>应用系统名称：</b></TD>
               <TD><input type="text" name="appname" size="40" class="inputtext" value="<%=appname%>" ></TD>
            </TR>
            <TR>
               <TD  ALIGN="RIGHT" nowrap><b>站点名称:</b></TD>
               <TD><input type="text" name="sitename" size="40" class="inputtext" value="<%=sitename%>" ></TD>
            </TR>
            <TR>
               <TD  ALIGN="RIGHT" nowrap><b>日志存放目录:</b></TD>
               <TD><input type="text" name="applogpath" size="40" class="inputtext" value="<%=applogpath%>" >
                  (相对配置文件所在目录的相对路径)</TD>
            </TR>
            <TR>
               <TD  ALIGN="RIGHT" nowrap><b>log4j配置文件:</b></TD>
               <TD><input type="text" name="log4jconfig" size="40" class="inputtext" value="<%=log4jconfig%>" >
                  (相对配置文件所在目录的相对路径)</TD>
            </TR>
         </table>
      </TD>  
   </TR>
   <TR id="auth" style="display:none;">
      <TD  colspan="2" align="center">
         <table cellSpacing=0 cellPadding=0 width="98%" align="center" border=0 class="defaultTable">
            <tr align="left">
               <th colspan="2" background="/images/navigation_ico_2.gif" class="navigation"><font color="#00ffff">用户服务器设置</font></th>
            </tr> 
            <TR>
               <TD  align="right" width="1%" nowrap><b>主用户服务名:</b></TD>
               <TD width="100%"><input type="text" name="users_check" size="10" class="inputtext" value="<%=users_check%>" >
               （验证用户和用户信息的主要服务器）</TD>
            </TR>
            <TR>
               <TD  ALIGN="RIGHT" nowrap><b>本地用户服务器名:</b></TD>
               <TD><input type="text" name="users_local" size="10" class="inputtext" value="<%=users_local%>" >
                  （本系统的用户服务器名,如：bimis）</TD>
            </TR>
         </table>
      <TABLE cellSpacing=0 cellPadding=0 width="98%" align=center border=0 class="defaultTable">
         <TR>
            <TD>服务器名</TD>
            <TD>使用中</TD>
            <TD>信息修改</TD>
            <TD>用户管理类名称</TD>
            <TD>用户存储表名</TD>
         </TR>
<%
   for(int i=0;i<user_names.length;i++){
%>         
         <TR <%if((i+1)%2==1){%>bgcolor="#00FFFF" <% }else{ %> bgcolor="#A52A2A" <%}%> >
            <TD><input type="text" name="user_name" size="10"  class="inputtext" value="<%=user_names[i]%>" ></TD>
            <TD>
               <select name="user_enable" class="inputtext">
                  <option value="true" <%if(user_enables[i].equals("true")) out.print("selected");%>>是</option>
                  <option value="false" <%if(!user_enables[i].equals("true")) out.print("selected");%>>否</option>
               </select>               
               </TD>
            <TD>
               <select name="user_sync" class="inputtext">
                  <option value="true" <%if(user_syncs[i].equals("true")) out.print("selected");%>>是</option>
                  <option value="false" <%if(!user_syncs[i].equals("true")) out.print("selected");%>>否</option>
               </select>               
               </TD>
            <TD><input type="text" name="user_repository" size="50%"  class="inputtext" value="<%=user_repositorys[i]%>" ></TD>
            <TD><input type="text" name="user_table" size="20"  class="inputtext" value="<%=user_tables[i]%>" ></TD>
         </TR>
<%
   }
%>         
      </TABLE>         
      </TD>  
   </TR>

   <TR id="report" style="display:none;">
      <TD  colspan="2" align="center">
         <table cellSpacing=0 cellPadding=0 width="98%" align="center" border=0 class="defaultTable">
            <tr align="left">
               <th colspan="2" background="/images/navigation_ico_2.gif" class="navigation"><font color="#00ffff">报表服务器配置</font></th>
            </tr> 
            <TR>
               <TD  align="right" width="1%" nowrap><b>报表服务器URL:</b></TD>
               <TD width="100%"><input type="text" name="ReportServer_URL" size="40" class="inputtext" value="<%=ReportServer_URL%>" ></TD>
            </TR>
            <TR>
               <TD  ALIGN="RIGHT" nowrap><b>分析报表服务器URL:</b></TD>
               <TD><input type="text" name="BIReport_URL" size="80" class="inputtext" value="<%=BIReport_URL%>" ></TD>
            </TR>
            <TR>
               <TD  ALIGN="RIGHT" nowrap><b>明宇报表服务器URL：</b></TD>
               <TD><input type="text" name="MingReport_URL" size="60" class="inputtext" value="<%=MingReport_URL%>" ></TD>
            </TR>
         </table>
      </TD>  
   </TR>
   
   <TR id="file"  style="display:none;">
      <TD colspan="2" align="center">
         <table cellSpacing=0 cellPadding=0 width="98%" align="center" border=0 class="defaultTable">
            <tr align="left">
               <th colspan="2" background="/images/navigation_ico_2.gif" class="navigation"><font color="#00ffff">文件服务器配置</font></th>
            </tr> 
            <TR>
               <TD  ALIGN="RIGHT" width="1%" nowrap><b>文件保存目录:</b></TD>
               <TD><input type="text" name="FileService_destination" size="40" class="inputtext" value="<%=FileService_destination%>" ></TD>
            </TR>
            <TR>
               <TD  ALIGN="RIGHT" nowrap><b>文件保存在:</b></TD>
               <TD><input type="text" name="FileService_type" size="40" class="inputtext" value="<%=FileService_type%>" ></TD>
            </TR>
            <TR>
               <TD  ALIGN="RIGHT" nowrap><b>上传文件最大字节数:</b></TD>
               <TD><input type="text" name="FileService_maxsize" size="40" class="inputtext" value="<%=FileService_maxsize%>" ></TD>
            </TR>
         </table>
      </TD>  
   </TR>
   
   <TR id="email" style="display:none;">
      <TD  colspan="2" align="center">
         <table cellSpacing=0 cellPadding=0 width="98%" align="center" border=0 class="defaultTable">
            <tr align="left">
               <th colspan="2" background="/images/navigation_ico_2.gif" class="navigation"><font color="#00ffff">电子邮件服务器定义</font></th>
            </tr> 
            <TR>
               <TD  ALIGN="RIGHT" width="1%" nowrap><b>管理员邮件地址:</b></TD>
               <TD><input type="text" name="MailService_postmaster" size="40" class="inputtext" value="<%=MailService_postmaster%>" ></TD>
            </TR>
            <TR>
               <TD  ALIGN="RIGHT" nowrap><b>邮件服务器域名:</b></TD>
               <TD><input type="text" name="MailService_servername" size="40" class="inputtext" value="<%=MailService_servername%>" ></TD>
            </TR>
            <TR>
               <TD  ALIGN="RIGHT" nowrap><b>邮件服务器主目录:</b></TD>
               <TD><input type="text" name="MailServer_home" size="40" class="inputtext" value="<%=MailServer_home%>" ></TD>
            </TR>
            <TR>
               <TD  ALIGN="RIGHT" nowrap><b>邮件服务器配置文件:</b></TD>
               <TD><input type="text" name="MailServer_configfile" size="40" class="inputtext" value="<%=MailServer_configfile%>" ></TD>
            </TR>
            <TR>
               <TD  ALIGN="RIGHT" nowrap><b>pop3服务器地址:</b></TD>
               <TD><input type="text" name="pop3server_host" size="40" class="inputtext" value="<%=pop3server_host%>" ></TD>
            </TR>
            <TR>
               <TD  ALIGN="RIGHT" nowrap><b>pop3服务器端口:</b></TD>
               <TD><input type="text" name="pop3server_port" size="40" class="inputtext" value="<%=pop3server_port%>" ></TD>
            </TR>
            <TR>
               <TD  ALIGN="RIGHT" nowrap><b>pop3服务器连接限时(毫秒):</b></TD>
               <TD><input type="text" name="pop3server_connectiontimeout" size="40" class="inputtext" value="<%=pop3server_connectiontimeout%>" ></TD>
            </TR>
            <TR>
               <TD  ALIGN="RIGHT" nowrap><b>pop3服务器操作限时(毫秒):</b></TD>
               <TD><input type="text" name="pop3server_timeout" size="40" class="inputtext" value="<%=pop3server_timeout%>" ></TD>
            </TR>
            <TR>
               <TD  ALIGN="RIGHT" nowrap><b>smtp服务器地址:</b></TD>
               <TD><input type="text" name="smtpserver_host" size="40" class="inputtext" value="<%=smtpserver_host%>" ></TD>
            </TR>
            <TR>
               <TD  ALIGN="RIGHT" nowrap><b>smtp服务器端口:</b></TD>
               <TD><input type="text" name="smtpserver_port" size="40" class="inputtext" value="<%=smtpserver_port%>" ></TD>
            </TR>
            <TR>
               <TD  ALIGN="RIGHT" nowrap><b>smtp服务器连接限时(毫秒):</b></TD>
               <TD><input type="text" name="smtpserver_connectiontimeout" size="40" class="inputtext" value="<%=smtpserver_connectiontimeout%>" ></TD>
            </TR>
            <TR>
               <TD  ALIGN="RIGHT" nowrap><b>smtp服务器操作限时(毫秒):</b></TD>
               <TD><input type="text" name="smtpserver_timeout" size="40" class="inputtext" value="<%=smtpserver_timeout%>" ></TD>
            </TR>
            <TR>
               <TD  ALIGN="RIGHT" nowrap><b>邮件大小限制(字节):</b></TD>
               <TD><input type="text" name="smtpserver_maxmessagesize" size="40" class="inputtext" value="<%=smtpserver_maxmessagesize%>" ></TD>
            </TR>
            <TR>
               <TD  ALIGN="RIGHT" nowrap><b>smtp服务器需要验证:</b></TD>
               <TD><input type="text" name="smtpserver_authRequired" size="40" class="inputtext" value="<%=smtpserver_authRequired%>" ></TD>
            </TR>
         </table>
      </TD>  
   </TR>

   <TR id="bbs" style="display:none;">
      <TD  colspan="2" align="center">
         <table cellSpacing=0 cellPadding=0 width="98%" align="center" border=0 class="defaultTable">
            <tr align="left">
               <th colspan="2" background="/images/navigation_ico_2.gif" class="navigation"><font color="#00ffff">论坛服务器配置</font></th>
            </tr> 
            <TR>
               <TD  ALIGN="RIGHT" width="1%" nowrap><b>论坛名称：</b></TD>
               <TD><input type="text" name="bbsService_name" size="40" class="inputtext" value="<%=bbsService_name%>" ></TD>
            </TR>
            <TR>
               <TD  ALIGN="RIGHT" nowrap><b>论坛URL:</b></TD>
               <TD><input type="text" name="bbsService_path" size="40" class="inputtext" value="<%=bbsService_path%>" ></TD>
            </TR>
         </table>
      </TD>  
   </TR>   

            
</TABLE>
<p align="center">
   <input type="button" class=btn value="修改" name="update" onclick="doupdate();">
   <input type="button" class=btn value="刷新" name="show" onclick="doshow();">
   <input type="button" class=btn value="返回" onclick="goback()" name="back">
</p>
</form>

</body>
</html>

<Script language="JavaScript">
<!--   
function doupdate()
{
   document.forms[0].act.value="update";
   document.forms[0].submit();
}
function doshow()
{
   document.forms[0].act.value="show";
   document.forms[0].submit();   
}
function goback(){
	document.location='/install/index.jsp';
}
function showme(obj){
   //var pos = getXY(event.srcElement);
   //alert("left:"+pos.left+"|top:"+pos.top);
   //alert(obj.tagName);
   //alert(event.srcElement.tagName);
	if(obj.tagName=="TD"){
		//unSelectAllTabPane(event.srcElement.parentElement);
	   //curRow=event.srcElement.parentElement;
	   curRow=obj.parentElement;
	   //alert("这是第"+(curRow.rowIndex+1)+"行,第"+(obj.cellIndex+1)+"列");
	   var curCells = curRow.childNodes;
	   for(var i=0;i<curCells.length;i++){
	      var curCell = curCells[i];
	      //alert('name='+curCell.getAttribute("name"));
	      if(curCell.getAttribute("name")!=null){
	         curCell.bgColor="#ffffff";
	         curCell.style.color="black";
	         var name = curCell.name;//("name").value;
	         var tb = document.getElementById(name);
	         if(tb!=null){
   	         if(name!=obj.name){
   	            //alert("hided "+name);
   	            tb.style.display="none";
   	         }else{
   	            //alert("show "+name);
   	            tb.style.display="inline";
   	         }
   	      }
	      }
	   }
		obj.style.color="red";
		obj.bgColor="blue";	   	   
	} 
}
function unSelectAllTabPane(trobj){
	var tabs =document.getElementById("tabpane");
	tabs.style.color="yellow";
	alert(tabs.length);
	alert(tabs.id);
	for(var i=0;i<tabs.length;i++){
		var tab = tabs[i];
			alert(i);
		tab.style.color="red";
	}
}
function showtabpane(obj){
	//隐藏后 页面的位置还被控件占用
	//document.all["PanelSMS"].style.visibility="hidden"; 
	//document.all["PanelSMS"].style.visibility="visible"; 
	//隐藏后 页面的位置不被占用
	document.all["tabpane"].style.display="none"; 
	document.all["tabpane"].style.display="inline";   
}  

function getXY(Obj) 
{
   var sumTop,sumLeft;
   for (sumTop=0,sumLeft=0;Obj!=document.body;){
      sumTop+=Obj.offsetTop;
      sumLeft+=Obj.offsetLeft;
      Obj=Obj.offsetParent;
   }
   return {left:sumLeft,top:sumTop}
}
function SelThis(obj)
{
   SelectRow(obj);
    //var Sel = window.document.body.createTextRange();
    //Sel.moveToElementText(obj);
    //window.document.execCommand("SelectAll");
}

window.focus();
-->
</Script>
