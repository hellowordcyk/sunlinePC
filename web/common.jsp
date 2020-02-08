<%@ page errorPage="/jsp_error.jsp"%>
<%@ include file="/common_tag.jsp" %>
<%@ page import="com.sunline.jraf.framework.FrameWorkConfiguration" %>

<%
    String contextPathStr = request.getContextPath();
    com.sunline.jraf.security.UserAuthenticator loginJrafAuth = (com.sunline.jraf.security.UserAuthenticator) com.sunline.jraf.security.UserAuthenticator.getAuthenticator();
   // System.out.println("***"+request.getRequestURI());
    String uri = request.getRequestURI();
    if(!(uri.startsWith("/common")|| uri.startsWith("/error")|| uri.startsWith("/public"))){
    	String[] strs = uri.split("/");
    	String subSysName = strs[1];
    	if(!FrameWorkConfiguration.verifyAction(subSysName)){
    		
    		System.out.println("*** license error");%>
    		<script>exportLicense();
    		
    		  function exportLicense(){
    			  var url="/governor/upload/uploadMain.jsp?sysName=<%=subSysName%>";
    		      var rtnValue = openModal(url, 800,250); 
    		      if(!rtnValue){
    		    	    window.history.go(-1);
    		      }
    		  }
    		  
    		  function openModal(URL,width,Height){
    			    var w = window.showModalDialog(URL,"win32","dialogWidth:"+ width +"px;dialogHeight:" + Height + "px;status:no;help:no");
    			    return w;
    			}
    		</script>
    		<%
        }
    }
    
    String skinname = null;
	if(loginJrafAuth==null)
	{
	    response.sendRedirect("/logout.jsp");
	    return;		
	}else
	{
		skinname = loginJrafAuth.getUser().getSkinname();
	}
	if(skinname == null || skinname.equals("") || skinname.trim().equals(""))
	{
		//skinname = "default";
		skinname = "outlook";
	}
	String skinPath = "/common/skins/" + skinname;
	String skinCssPath = skinPath + "/theme";
	String skinImgPath = skinPath + "/images";
	String skinScriptPath = "/common/scripts";
%>

<link rel="stylesheet" type="text/css" href="<%=contextPathStr + skinCssPath %>/style-sys.css">
<link rel="stylesheet" type="text/css" href="<%=contextPathStr + skinCssPath %>/style-custom.css">
<!--[if IE 6]>
<link rel="stylesheet" type="text/css" href="<%=contextPathStr + skinCssPath %>/style-custom-ie6.css">
<![endif]-->

<script type="text/javascript" src="<%=skinScriptPath %>/alai_tree.js"></script>
<script type="text/javascript" src="<%=skinScriptPath %>/alai_tree_check.js"></script>
<script type="text/javascript" src="<%=skinScriptPath %>/alai_menu.js"></script>
<script type="text/javascript" src="<%=skinScriptPath %>/prototype1.7.js"></script>
<script type="text/javascript" src="<%=skinScriptPath %>/Jraf_prototype.js"></script>
<script type="text/javascript" src="<%=skinScriptPath %>/checkForm.js"></script>
<script type="text/javascript" src="<%=skinScriptPath %>/checkValid.js"></script>
<script type="text/javascript" src="<%=skinScriptPath %>/form.js" ></script>
<script type="text/javascript" src="<%=skinScriptPath %>/openNewWindow.js"></script>
<script type="text/javascript" src="<%=skinScriptPath %>/openW.js"></script>
<script type="text/javascript" src="<%=skinScriptPath %>/mousemove.js"></script>


<script type="text/javascript" src="<%=skinPath%>/newcalendar/calendar.js"></script>
<script type="text/javascript" src="<%=skinPath %>/newcalendar/lang/calendar-zh.js"></script>
<script type="text/javascript" src="<%=skinPath %>/newcalendar/calendar-setup.js"></script>
