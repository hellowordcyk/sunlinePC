<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.jdom.*" %>
<%@ page import="java.util.*"%>
<%
	Document xmlDoc = (Document) request.getAttribute("xmlDoc");
    String parentid = request.getParameter("menuid");
    String psubsysid = request.getParameter("subsysid");
%>
<html>
<body>
<script language="JavaScript">
function exec(val)
{
    try
    {
    	window.parent.execScript(val);
    }
    catch(e){}
}
<%
	StringBuffer sbuf = new StringBuffer();
    sbuf.append("exec('");
	if("-1".equals(parentid))
    {
        sbuf.append("var toNode=tree.root;");
    }
    else
	{
        sbuf.append("var toNode=tree.nodes[\"n" + psubsysid+","+parentid + "\"];");
	}
	if (xmlDoc!=null)
    {
        sbuf.append("');");
        out.println(sbuf.toString());
    	List recordList = xmlDoc.getRootElement().getChild("Response").getChild("Data").getChildren("Record");
        int size = recordList.size();
        int len = 0;
        while(true)
        {
            sbuf = new StringBuffer();
            sbuf.append("var val"+len+"='");
        for (int i=len;i<size && i < len+20;i++)
        {
            Element record = (Element)recordList.get(i);
            String subsysid = record.getChildText("subsysid");
            String menuid = record.getChildText("menuid");
            String pmenuid = record.getChildText("pmenuid");
            String menuname = record.getChildText("menuname");
            int childnum = Integer.parseInt(record.getChildText("childnum"));

            String icon = "file";
            if(0 < childnum)
            {
                icon = "folder";
            }
            icon = "";
            sbuf.append("var nNode=tree.add(toNode,\"last\",\"" +menuname+"("+menuid+ ")\",\"" + "n"
            + subsysid+","+menuid + "\",\"" + icon + "\",\"js\",\"expand()\");");
            sbuf.append("if(nNode.parent.first.label.innerText==\"loading...\")nNode.parent.first.remove();");
            if(0 < childnum)
        	{
            	sbuf.append("nNode.add(\"loading...\");nNode.expand(false);");
        	}
        }
        sbuf.append("';\nsetTimeout('exec(val"+len+")',"+(30*len)+");");
        out.println(sbuf.toString());

        len += 20;
        if(len >= size) break;
        }
    }
%>
</script>
</body>
</html>
