<%@page import="com.sunline.jraf.security.UserAuthenticator"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.ArrayList"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="com.sunline.sunrpt.util.*"%>
<%@ page import="com.sunline.sunrpt.report.ExportReport"%>
<%@ page import="java.util.List"%>
<%@ page import="org.jdom.*"%>
<%@ page import="com.sunline.jraf.web.*"%>
<%@ page import="java.util.Iterator"%>
<%@ include file="/jui_tag.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<title>报表查询</title>
<%
	Document xmlDoc = (Document) request.getAttribute("xmlDoc");
	List<Element> expReportBaseInfo = xmlDoc.getRootElement().getChild("Response").getChild("Data").getChildren("expReportBaseInfo");
	List<Element> expReportPropertyList = xmlDoc.getRootElement().getChild("Response").getChild("Data").getChild("expReportPropertyList").getChildren("Record");
	Element colCondPropertyEle = xmlDoc.getRootElement().getChild("Response").getChild("Data").getChild("colCondPropertyList");
	List<Element> expReportHeaderList = xmlDoc.getRootElement().getChild("Response").getChild("Data").getChild("expReportHeaderList").getChildren("Record");
	List<Element> showDataList = xmlDoc.getRootElement().getChild("Response").getChild("Data").getChild("showDataList").getChildren("Record");
	Element queryErrInfo = xmlDoc.getRootElement().getChild("Response").getChild("Data").getChild("showDataList").getChild("errinfo");
	Element queryErrSql = xmlDoc.getRootElement().getChild("Response").getChild("Data").getChild("showDataList").getChild("errsql");
	Element pageInfo = xmlDoc.getRootElement().getChild("Response").getChild("Data").getChild("showDataList").getChild("PageInfo");
	Element expLsum = xmlDoc.getRootElement().getChild("Response").getChild("Data").getChild("showDataList").getChild("expLsum");
	Element expSum = xmlDoc.getRootElement().getChild("Response").getChild("Data").getChild("showDataList").getChild("expSum");
	String RecordCount = null;
	String PageCount = null;
	String PageSize = null;
	String PageNo = null;
	if(pageInfo != null){
		RecordCount = pageInfo.getChildText("RecordCount");
		PageCount = pageInfo.getChildText("PageCount");
		PageSize = pageInfo.getChildText("PageSize");
		PageNo = pageInfo.getChildText("PageNo");
	}
	
	int theadTdLength = expReportPropertyList.size();
	String tbWidth = theadTdLength*100/10<100?"100%":theadTdLength*100/10+"%";
%>

<body scroll="no">
<div class="pageHeader">
	<form id = "pagerForm" name="rpt_export_show_fom_name_${param.rptuid }"
		onsubmit="return checkAndQuery(this);"
		action="/httpprocesserservlet?sysName=<sc:fmt value='sunrpt' type='crypto'/>&oprID=<sc:fmt value='sunrpt-report' type='crypto'/>&actions=<sc:fmt value='queryReport' type='crypto'/>&forward=<sc:fmt value='/sunrpt/report/export_show.jsp' type='crypto'/>&rptuid=${param.rptuid }"
		method="post">
		<div class="searchBar">
			<table class="searchContent" cellpadding="0" cellspacing="0" >
				<tr>
					<%if(colCondPropertyEle!=null){
						List<Element> colCondlist = colCondPropertyEle.getChildren("Record");
						int count =0;
						Iterator it = colCondlist.iterator();
						while(it.hasNext()){
							count++;
							int colspan = 1;
							if(count == colCondlist.size()){
								if(count%3 == 1){
									colspan = 4;
								}else if(count%3 == 2){
									colspan = 2;
								}
							}
							Element el = (Element)it.next();
							String colcondna = el.getChildText("fldsna"); //查询字段
							//如果是GETNA 函数时，使用真实查询字段，如GETNA(ORG_NO,pcmc_dept,deptcode,deptname)，使用ORG_NO作为name和id
							if(StringUtils.contains(colcondna, SunrptUtil.RPT_FUNCTION_GETNA)){
								colcondna = colcondna.substring(colcondna.indexOf("(")+1,colcondna.lastIndexOf(")")-1);
								colcondna = colcondna.split(",")[0];
							}
							//如果是KPINA 函数时，使用K+指标编码作为查询字段
							if(StringUtils.contains(colcondna, SunrptUtil.RPT_FUNCTION_KPINA)||StringUtils.contains(colcondna, SunrptUtil.RPT_FUNCTION_KPICODE)){
								String kpicode = el.getChildText("flysna"); //查询字段
								colcondna = "K"+SunrptUtil.getRealFlysNa(kpicode).toUpperCase();//指标字段的命名是K+kpicode
							}
							String flddpn = el.getChildText("flddpn"); //查询字段
							String colcond = el.getChildText("colcond");//查询条件格式
							colcond = colcond.substring(2, colcond.length()-1);	
							String[] paraArr =colcond.split("_@_");//Y(控件类型，控件格式，是否必填，默认值，模糊匹配)
							if(paraArr.length>4){
								flddpn = flddpn+SunrptUtil.getDimetpDictName(paraArr[4]);
							}%>
						<td class="form-label"><%=flddpn %></td>
						<td class="form-value">
                        <%  String defaultVal = "";
								String[] defaultValArr = {"",""};
								List<String> checklist = new ArrayList<String>();
								if(paraArr.length>3&&!paraArr[3].equals("##")){
									defaultVal = paraArr[3];
									if(defaultVal.indexOf("|")>-1){
										defaultValArr = defaultVal.split("\\|");
										checklist = Arrays.asList(defaultValArr);
									}else{
										checklist.add(defaultVal);
									}
								}
							%>
							<!-- 1下拉框  -->
							<%if("select".equalsIgnoreCase(paraArr[0])){
								if("1".equalsIgnoreCase(paraArr[2])){%>
									<sc:select name="<%=colcondna %>" includeTitle="false" key="<%=paraArr[1] %>" type="knp" default="<%=defaultVal %>" validate="required"/>
									<span class="redmust">*</span>
								<%}else{%>
									<sc:select name="<%=colcondna %>" includeTitle="false" key="<%=paraArr[1] %>" type="knp" default="<%=defaultVal %>" nullOption="--请选择--" />
								<%}%>
							<!-- 2复选框 -->
							<%}else if("checkbox".equalsIgnoreCase(paraArr[0])){
							    if("1".equalsIgnoreCase(paraArr[2])){%>
							    	<sc:scheckbox name="<%=colcondna %>" key="<%=paraArr[1] %>" type="knp" defaults="<%=checklist %>"  validate="required"/>
									<span class="redmust">*</span>
								<%}else{%>
								    <sc:scheckbox name="<%=colcondna %>" key="<%=paraArr[1] %>" type="knp" defaults="<%=checklist %>" />
								<%}%>
							<!-- 3弹出框 -->
							<%}else if("dialog".equalsIgnoreCase(paraArr[0])){
								String seldef = "";
								String code = "";
								String name = "";
								if(null != defaultVal && !"".equals(defaultVal))
								{
									seldef = defaultVal.replace("|", ",");
									code = seldef.split(":")[0];
									name = seldef.split(":")[1];
								}	
								if("1".equalsIgnoreCase(paraArr[2])){%>
								<!-- 3.1-1机构  -->
								<%if("brchno".equalsIgnoreCase(paraArr[1])){%>
									<sc:hidden name="<%=colcondna %>" id="<%=colcondna %>"	validate="required" default="<%=code %>" />
									<sc:text name='<%=colcondna+"_name"%>' id='<%=colcondna+"_name"%>' default="<%=name%>" validate="required" readonly="true" />
									
									<%-- <a class="btnLook" title="选择机构" lookupGroup="" width="900" height="500"
                                        href="/funcpub/public/deptuser/deptLookupMulti.jsp?lookupcode=<%=colcondna %>&lookupname=<%=colcondna+"_name"%>"></a>
                                     --%>
                                    <a class="btnLook" title="选择机构" lookupGroup=""  width="1000" height="500"
                                        href="/funcpub/public/deptuser/deptTreeOptionDialog.jsp?lookupcode=<%=colcondna %>&lookupname=<%=colcondna+"_name"%>&elmId={<%=colcondna %>}"></a>
                                    
									<span class="redmust">*</span>
								<!-- 3.2-1人员  -->
								<%}else if("user".equalsIgnoreCase(paraArr[1])){%> 
									<sc:hidden name="<%=colcondna %>" id='<%=colcondna+"_No"%>'	validate="required" default="<%=code %>" />  
									<sc:text name='<%=colcondna+"_name" %>' id='<%=colcondna+"_name" %>' default="<%=name%>" validate="required" readonly="true"/>
									 
									<%-- <a id="userOptions" class="btnLook publicOptionControls" type="userTable" multi="true" filter="&agb=g"  
										seletedInput="<%=colcondna%>" selectedColumn="USERCODE" callback="userTableCallBack">
									</a> --%>
									
									<%-- <a class="btnLook" title="选择用户" lookupGroup="" width="900" height="500"
                                        href="/funcpub/public/deptuser/userLookupMulti.jsp?lookupcode=<%=colcondna %>&lookupname=<%=colcondna+"_name" %>"></a>
									 --%>
									<a class="btnLook" title="选择用户" lookupGroup=""  width="1000" height="500"
                                        href="/funcpub/public/deptuser/userTreeOptionDialog.jsp?lookupcode=<%=colcondna %>&lookupname=<%=colcondna+"_name" %>&elmId={<%=colcondna %>_No}"></a>
             
									<span class="redmust">*</span>
								<!-- 3.3-1指标  -->
								<%}else if("item".equalsIgnoreCase(paraArr[1])){%> 
									<%-- <a class="btnLook" onclick="showUserTreeDialog('<%=colcondna %>','userTree_callback',1,'a','','');"></a> --%>
									<!-- <span>Waiting For 指标弹框开发</span> -->
									<sc:hidden name="<%=colcondna %>" id='<%=colcondna+"_code"%>' validate="required" default="<%=seldef %>" />  
									<sc:text name='<%=colcondna+"_name" %>' id='<%=colcondna+"_name" %>' validate="required" readonly="true" />
									<a id="kpiOptions" class="btnLook publicOptionControls" type="kpi" multi="true" 
										filter="&area=ba&kpiType=B,C,I&applyType=1,2"  
										seletedInput="<%=colcondna %>" selectedColumn="KPI_CODE" callback="kpiOptionCallBack">
									</a>
									<span class="redmust">*</span> 
								<%}
								}else{%>
								<!-- 3.1-2机构  -->
								<%if("brchno".equalsIgnoreCase(paraArr[1])){%>
									<sc:hidden name="<%=colcondna %>" id="<%=colcondna %>" default="<%=seldef %>" />
									<sc:text name='<%=colcondna+"_name" %>' id='<%=colcondna+"_name" %>'  readonly="true"/>
									<%-- <a class="btnLook" title="选择机构" lookupGroup="" width="900" height="500"
                                        href="/funcpub/public/deptuser/deptLookupMulti.jsp?lookupcode=<%=colcondna %>&lookupname=<%=colcondna+"_name"%>"></a>
                                     --%>
                                    <a class="btnLook" title="选择机构" lookupGroup=""  width="1000" height="500"
                                        href="/funcpub/public/deptuser/deptTreeOptionDialog.jsp?lookupcode=<%=colcondna %>&lookupname=<%=colcondna+"_name"%>&elmId={<%=colcondna %>}"></a>
                                    
                                    
								<!-- 3.2-2人员 -->
								<%}else if("user".equalsIgnoreCase(paraArr[1])){%> 
									<sc:hidden name="<%=colcondna%>" id='<%=colcondna+"_No"%>' default="<%=seldef %>" />
									<sc:text name='<%=colcondna+"_name" %>' id='<%=colcondna+"_name" %>' readonly="true"/>
									<%-- <a id="userOptions" class="btnLook publicOptionControls" type="userTable" multi="true" filter="&agb=g"  
										seletedInput="<%=colcondna%>" selectedColumn="USERCODE" callback="userTableCallBack">
									</a> --%>
									
									<%-- <a class="btnLook" title="选择用户" lookupGroup="" width="900" height="500"
                                        href="/funcpub/public/deptuser/userLookupMulti.jsp?lookupcode=<%=colcondna %>&lookupname=<%=colcondna+"_name" %>"></a>
                                     --%>
                                    <a class="btnLook" title="选择用户" lookupGroup=""  width="1000" height="500"
                                        href="/funcpub/public/deptuser/userTreeOptionDialog.jsp?lookupcode=<%=colcondna %>&lookupname=<%=colcondna+"_name" %>&elmId={<%=colcondna %>_No}"></a>
             
								<!-- 3.3-2指标 -->   
								<%}else if("item".equalsIgnoreCase(paraArr[1])){%> 
									<%-- <a class="btnLook" onclick="showUserTreeDialog('<%=colcondna %>','userTree_callback',1,'a','','');"></a> --%>
									<!-- <span>Waiting For 指标弹框开发</span> -->
									<sc:hidden name="<%=colcondna %>" id='<%=colcondna+"_code"%>' 	validate="required" default="<%=seldef %>" />  
									<sc:text name='<%=colcondna+"_name" %>' id='<%=colcondna+"_name" %>'  readonly="true"/>
									<a id="kpiOptions" class="btnLook publicOptionControls" type="kpi" multi="true" 
										filter="&area=ba&kpiType=B,C,I&applyType=1,2"  
										seletedInput="<%=colcondna %>" selectedColumn="KPI_CODE" callback="kpiOptionCallBack">
									</a>
								<%}
								}%>
							<!-- 4日期 -->
							<%}else if("dt".equalsIgnoreCase(paraArr[0])){
								if("1".equalsIgnoreCase(paraArr[2])){%> 
								<sc:date name="<%=colcondna %>"	dateFmt="<%=paraArr[1] %>" default="<%=defaultVal %>" validate="required"  readonly="true"/><span class="redmust">*</span>
							  <%}else{%> 
							  	<sc:date name="<%=colcondna %>" default="<%=defaultVal %>" dateFmt="<%=paraArr[1] %>" readonly="true"/> 
							  <%}%>
							<!-- 5日期区间  -->
							<%}else if("bwdt".equalsIgnoreCase(paraArr[0])){
								String fromName =  colcondna+"_1";
								String toName =  colcondna+"_2";
								/* count=4;//区间控件直接换行 */
								if("1".equalsIgnoreCase(paraArr[2])){%> 
								<sc:date name="<%=fromName %>"	dateFmt="<%=paraArr[1] %>" default="<%=defaultValArr[0] %>" validate="required" readonly="true"/><span class="redmust">*</span>-
								<sc:date name="<%=toName %>" dateFmt="<%=paraArr[1] %>" default="<%=defaultValArr[1] %>"  validate="required" readonly="true"/><span class="redmust">*</span>
							  <%}else{%> 
							  	<sc:date name="<%=fromName %>"	dateFmt="<%=paraArr[1] %>" default="<%=defaultValArr[0] %>" readonly="true"/>-
								<sc:date	name="<%=toName %>" dateFmt="<%=paraArr[1] %>" default="<%=defaultValArr[1] %>" readonly="true"/> 
							  <%}%>
							<!-- 6输入框区间  -->
							<%}else if("bwtx".equalsIgnoreCase(paraArr[0])){
								String fromName =  colcondna+"_1";
								String toName =  colcondna+"_2";
								if("1".equalsIgnoreCase(paraArr[2])){%> 
								<sc:text name="<%=fromName %>" validate="required number" default="<%=defaultValArr[0] %>" style="width:80px;" /><span class="redmust">*</span>~ 
								<sc:text name="<%=toName %>" validate="required number" default="<%=defaultValArr[1] %>" style="width:80px;" /><span class="redmust">*</span> 
							  <%}else{%> 
							  	<sc:text name="<%=fromName %>" validate="number"	default="<%=defaultVal %>" style="width:80px;"/>~
								<sc:text name="<%=toName %>"	validate="number" default="<%=defaultVal %>" style="width:80px;"/> 
							  <%}%>
							<!-- 7输入框 -->
							<%}else{
								if("1".equalsIgnoreCase(paraArr[2])){%> 
								<sc:text name="<%=colcondna %>" validate="required"	default="<%=defaultVal %>" /> <span class="redmust">*</span><%
								}else{%> 
								<sc:text name="<%=colcondna %>"	default="<%=defaultVal %>" /> 
							  <%}
							}%>
						</td>
                        <%if((colCondlist.size()>2&&count==2)||(colCondlist.size()<=2&&count==colCondlist.size())){%>
                            <td class="form-btn" rowspan="<%=(colCondlist.size()%2==0?colCondlist.size()/2:(colCondlist.size()/2+1))%>">
                                <ul>
                                    <li>
                                        <button type="button" onclick="doQuery()" class="querybtn">查询</button>
                                        <input type="hidden" name="isqrdata" value="true"> <!-- <input type="hidden" name="rptuid"  > -->
                                        <input type="hidden" name="pageNum" value="1" /> 
                                    </li>
                                    <li>
                                        <button class="resetbtn" type="reset">清空</button>
                                    </li>
                                </ul>
                            </td>
                            
                        <%}%>
					<%if(count%2==0 && count < colCondlist.size()){%>
					</tr>
					<tr>
					<%}%>
					
				<%}%>
					</tr>
				<%}%>
				</table>
			</div>
		</form>
	</div>
	<div class="pageContent">
		<div class="panelBar">
			<ul class="toolBar">
				<li><a class="export" title="导出查询结果到Excel"  onclick='excelExport("${param.rptuid }");'><span>Excel导出</span></a></li>
			</ul>
		</div>	
		<table width="<%=tbWidth%>" class="table">
			<thead>
			<%
				int colNum = expReportPropertyList.size();
				String showdata[] = new String[colNum];
				String showdatafmt[] = new String[colNum];
				String aherfarr[] = new String[colNum];
				String aherCnarr[] = new String[colNum];
				for (int y = 0; y < colNum; y++) {
					Element element = expReportPropertyList.get(y);
					String flysna = element.getChildText("flysna"); //01属性名称(描述)
					String fldsna = element.getChildText("fldsna"); //01属性名称(描述)
					//详细用fldsna，指标用flysna
					if(!StringUtil.isNullOrEmpty(flysna)){
					    fldsna = flysna;
					}
					String fldsnafmt = element.getChildText("colfomat"); //01属性名称(描述)
					String aherf_info = element.getChildText("aherf_info"); //超链接信息
					String aherf_info_cn = element.getChildText("aherf_info_cn"); //超链接信息中文
					String sum = element.getChildText("sum"); //统计要求
					if(StringUtils.contains(fldsna, SunrptUtil.RPT_FUNCTION_KPINA)||StringUtils.contains(fldsna, SunrptUtil.RPT_FUNCTION_KPICODE)){
						String kpicode = element.getChildText("flysna"); 
						fldsna = "K"+SunrptUtil.getRealFlysNa(kpicode).toUpperCase();//代表指标
					}
					showdata[y] = fldsna;
					showdatafmt[y] = fldsnafmt;
					aherfarr[y] = aherf_info;
					aherCnarr[y] = aherf_info_cn;
				}
				/* Element lastHeadElement = expReportHeaderList
						.get(expReportHeaderList.size() - 1);
				int level = Integer
						.valueOf(lastHeadElement.getChildText("thLevel")); */
				int level = ExportReport.getHeadRowNum(expReportHeaderList);
				int rowNum = 8 + level;
				Element expReportBaseInfoElement = null;
				if (expReportBaseInfo.size() > 0) {
					expReportBaseInfoElement = (Element) expReportBaseInfo.get(0);
				}
				String datasrcid = expReportBaseInfoElement
						.getChildText("datasrcid"); //数据源标识
				String title = expReportBaseInfoElement.getChildText("title"); //表名
				String tabtype = expReportBaseInfoElement.getChildText("tabtype"); //报表类型
				String typena = expReportBaseInfoElement.getChildText("typena"); //报表类型名称
				String bala_rule = expReportBaseInfoElement
						.getChildText("bala_rule"); //平衡关系校验规则
				String tab = expReportBaseInfoElement.getChildText("tab"); //数据来源表
				for (int i = 1; i < 5; i++) { //从第1行 开始写 表格   i<12  i<(rowNum-1)  一行一行写  -----------------------------
					if (i == 1) { // 第1行
			%>
			<%-- <tr>
				<th style="text-align: center;" colspan="<%=colNum %>"><%=title%></th>
			</tr> --%>
			<%
				}

					if (i == 2) { // 第2行-------------------------------------------------------
			%>
			<%-- <tr>
				<th  style="text-align: center;"   colspan="<%=colNum %>"><%=typena%></th>
			</tr> --%>
			<%
				}

					if (i == 3) { //  第3--表头结束    行 ----------------------------------做3行

						int templevel = 0; //标记当前层次 第几层
						for (int n = 0; n < expReportHeaderList.size(); n++) {
							Element element = expReportHeaderList.get(n);

							String thId = element.getChildText("thId"); //01项id
							int thLevel = Integer.valueOf(element.getChildText("thLevel")); //02层级
							String thSeq = element.getChildText("thSeq"); //03关联序列
							String thName = element.getChildText("thName"); //04项标题
							String thParentId = element.getChildText("thParentId"); //05父项id
							int thRowspan = Integer.valueOf(element
									.getChildText("thRowspan")); //06合并行数 
							int thColspan = Integer.valueOf(element
									.getChildText("thColspan")); //07合并列数
							int thSortId = Integer.valueOf(element
									.getChildText("thSortId")); //08顺序号

							if (templevel != thLevel) { //换层 要加<tr>
								templevel = thLevel;
			%>
			<tr>
				<%
					}
				%>

				<th  style="text-align: center;"  rowspan="<%=thRowspan%>" colspan="<%=thColspan%>"><%=thName%></th>

				<%
					if (expReportHeaderList.size() == (n + 1)) {
				%>
			</tr>
			<tr>
			<%
				} else {
								Element elementNext = expReportHeaderList
										.get(n + 1);
								int thLevelNext = Integer.valueOf(elementNext
										.getChildText("thLevel")); //02层级
								if (thLevel != thLevelNext) { //行结尾
			%>
			</tr>

			
			<%
				}
							}
						}
					}
			
					if (i == 4) { //第6 行 ----------------------------------------------
						%>
						</thead>
			<tbody>
						<%
						if(queryErrInfo!=null){
							String errinfo = queryErrInfo.getText();
							String errsql = queryErrSql.getText();
						%>
						
						<tr>
							<td colspan="100"><sc:fmt value="<%=errinfo%>" /> </td>							
						</tr>
						<tr>
							<td colspan="100"><sc:fmt value="<%=errsql%>" /> </td>							
						</tr>
						<%
						}
						for (int k = 0; k < showDataList.size(); k++) {
			%>

			<tr>
				<%
					Element element = showDataList.get(k);
								for (int z = 0; z < showdata.length; z++) {
									String eleName = showdata[z];
									if(StringUtils.contains(eleName, SunrptUtil.RPT_FUNCTION_GETNA)){//GET函数
										String dictinfo = eleName.substring(eleName.indexOf("(")+1, eleName.lastIndexOf(")"));
										eleName = SunrptUtil.parseGetNa(dictinfo.split(",")[0]);//获取真实ElementName
									}
									String showdatatemp = element.getChildText(eleName);
									String aherfstr = aherfarr[z];
									String aherfCnstr = aherCnarr[z];
									String showdatafmtStr = showdatafmt[z];
									//System.out.println(showdatafmtStr);
									if(showdatafmtStr.startsWith("M") || showdatafmtStr.startsWith("N")
									        || showdatafmtStr.startsWith("P")){
										%>
										<td style="text-align: right;">
										<%	
									}
									else{
										%>
										<td style="text-align: center;">
										<%	
									}
									if(!StringUtil.isObjNullOrEmpty(aherfstr)){
										String[] paraArr = aherfstr.split("_@_");
										if(paraArr.length>2&&!"0".equals(paraArr[0])&&!"0".equals(paraArr[1])){//超链接
											String a_rptsna = RptExcelParse.toSemiangle(aherfCnstr).split(",")[1];//先转小写
											String a_paras="";
											if(!"0".equals(paraArr[2])){//存在参数
												String[] queryparaArr = paraArr[2].split(",");
												for(String pstr : queryparaArr){
													a_paras += "&"+pstr+"="+element.getChildText(pstr);
												}
											}
											%>
											<a  rel="<%=paraArr[1] %>" title="<%=a_rptsna %>" href="/httpprocesserservlet?sysName=<sc:fmt value='sunrpt' type='crypto'/>&oprID=<sc:fmt value='sunrpt-report' type='crypto'/>&actions=<sc:fmt value='queryReport' type='crypto'/>&forward=<sc:fmt value='/sunrpt/report/export_show.jsp' type='crypto'/>&rptuid=<%=paraArr[1] %>&isinqr=1<%=a_paras %>" target="navTab">
											<sc:fmt value="<%=showdatatemp%>" /> 
											</a>
											<%
										}else{
											%>
											<sc:fmt value="<%=showdatatemp%>" /> 
										 	<%
										}
									}else{
									    //设置百分比，默认显示两位小数
									    if(showdatafmtStr.startsWith("P")){
									        BigDecimal bgNum = new BigDecimal(showdatatemp);
									        bgNum= bgNum.setScale(2, BigDecimal.ROUND_HALF_UP).multiply(new BigDecimal(100));
											showdatatemp = bgNum.toString()+"%";
										}
									    
										%>
											<sc:fmt value="<%=showdatatemp%>" /> 
										<%
									}
					%>
				</td>
				<%
					}
				%>
			</tr>
			<%
				}
					}
				}
			%>
			<%
				//插入 - 小计
				if(expLsum!=null&&expLsum.getChild("Record")!=null){
			%>
			<!-- <tr>
			</tr> -->
			<tr>
				<td>小计:</td>
			<%
					Element re = expLsum.getChild("Record");
					for(int n=1; n<showdata.length;n++){
						String eleName = showdata[n];
						String lsum = "";
						if(!StringUtils.contains(eleName, SunrptUtil.RPT_FUNCTION_GETNA)){
							lsum = re.getChildText(eleName);
						}
						%>
						<td  ><%=lsum %></td>
						<%
					}
				}
			%>
			</tr>
			<%
				//插入 - 合计
				if(expSum!=null&&expSum.getChild("Record")!=null){
			%>
			<!-- <tr>
			</tr> -->
			<tr>
				<td>合计</td>
			<%
					Element re = expSum.getChild("Record");
					for(int n=1; n<showdata.length;n++){
						String eleName = showdata[n];
						String sums = "";
						if(!StringUtils.contains(eleName, SunrptUtil.RPT_FUNCTION_GETNA)){
							sums = re.getChildText(eleName);
						}
						%>
						<td ><%=sums %></td>
						<%
					}
				}
			%>
			</tr>
			</tbody>
		</table>
		<% if(pageInfo != null){%>
		<div class="panelBar">
			<div class="pagination" targetType="navTab"
				totalCount="<%=RecordCount%>" numPerPage="<%=PageSize%>"
				pageNumShown="10" currentPage="<%=PageNo%>">
			</div>
		</div>
		<%} %>
	</div>

</body>
<script type="text/javascript" >
	$(document).ready(function(){
		var isqrdata = "${param.isinqr}";
		if(isqrdata=="1"){//系统进入就查询
			//alert("开启自查");
			doQuery();
		}
		
	});
/* 	initTable();
	function initTable(){
		var tdLength = $("thead",navTab.getCurrentPanel()).find("td").length;
		var width = tdLength*100/10;
		var tbWidth = "";
		if(tbWidth<100){
			tbWidth = "100%";
		}else{
			tbWidth = width+"%";
		}
		alert(tdLength);
		$(".grid",navTab.getCurrentPanel()).width(tbWidth);
	} */
	
	function doQuery(){
		var formname = "rpt_export_show_fom_name_"+"${param.rptuid }";
		var frm = $("form[name="+formname+"]");
		checkAndQuery(frm[0],navTab.getCurrentPanel());	
	}
	
	//edit zhukl 表单查询提交校验
	function checkAndQuery(form, navTabId){
		var $form = $(form);
		if (!$form.valid()) {
			return false;
		}else{
			navTabSearch(form);
		}
		return false;
	}
	//edit zhukl 导出查询结果 
	function excelExport(rptuid){
		debugger;
		var formname = "rpt_export_show_fom_name_"+rptuid;
		var form = $("form[name="+formname+"]");
		var $form = $(form[0]);
		if (!$form.valid()) {
			return false;
		}else{
		    var args ="&"+$(form).serialize();
		    args = decodeURIComponent(args,true);
		    args = encodeURI(encodeURI(args)); 
			var url = '/download?sysName=<sc:fmt value='sunrpt' type='crypto'/>&oprID=<sc:fmt value='sunrpt-report' type='crypto'/>&actions=<sc:fmt value='expReportExcel' type='crypto'/>';
		    url += "&dt="+new Date().getTime()+"&rptuid="+rptuid+args+"&csrftoken="+g_csrfToken;
		    location.href= url;
		    
		    
		}
		
	}
	
	function parseFileStr(xmlStr,str){
		var len = str.length;
		var strval = xmlStr.substring(xmlStr.indexOf(str)+len+1, xmlStr
				.lastIndexOf(str)-2);
		return strval;
	}
	
	/**
	*  修改方法名，与首页 同名函数 冲突
	*/
	function parseXmlStr2(xmlStr) {
		//先获取response段的字符串
		var responseStr = xmlStr.substring(xmlStr.indexOf("Response"), xmlStr
				.lastIndexOf("Response"));
		alert(responseStr);
		var dataStr = responseStr.substring(responseStr.indexOf("Data") - 1,
				responseStr.lastIndexOf("Data") + 5);
		var xmlDoc = null;
		try //Internet Explorer
		{
			xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
			xmlDoc.async = "false";
			xmlDoc.loadXML(dataStr);
		} catch (e) {
			try //Firefox, Mozilla, Opera, etc.
			{
				parser = new DOMParser();
				xmlDoc = parser.parseFromString(dataStr, "text/xml");
			} catch (e) {
				alert(e.message);
				return;
			}
		}
		
		return xmlDoc;
	}	

function deptTreeCallBack(deptArray,dept){
	$("#deptOptions",navTab.getCurrentPanel()).prevAll("input[name$='name']").val(dept.deptName);
	$("#deptOptions",navTab.getCurrentPanel()).prevAll("input[type='hidden']").val(dept.deptCode);
}
function userTableCallBack(userArray,user){
	$("#userOptions",navTab.getCurrentPanel()).prevAll("input[name$='name']").val(user.userName);
	$("#userOptions",navTab.getCurrentPanel()).prevAll("input[type='hidden']").val(user.userCode);
}
function kpiOptionCallBack(kpiArray,kpi){
	$("#kpiOptions",navTab.getCurrentPanel()).prevAll("input[name$='name']").val(kpi.kpiName);
	$("#kpiOptions",navTab.getCurrentPanel()).prevAll("input[type='hidden']").val(kpi.kpiCode);
}
</script>
</html>