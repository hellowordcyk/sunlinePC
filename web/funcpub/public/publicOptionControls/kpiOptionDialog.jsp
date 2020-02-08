<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 指标选择带回
 * description: 
 *     1.指标选择带回
 * author: 
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160704 优化布局
 *--%>
<style type="text/css">
    #selectedManagerTree li span.button.switch.level0 {
        visibility: hidden;
        width: 1px;
    }

    #selectedManagerTree li ul.level0 {
        padding: 0;
        background: none;
    }
</style>
<div class="pageHeader">
    <form id="pagerForm" action="/httpprocesserservlet?<c:out value='${param.filter }' />" method="post"
          onsubmit="return dialogSearch(this);">
        <input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>"/>
        <input type="hidden" name="oprID" value="<sc:fmt value='publicOptionControls' type='crypto'/>"/>
        <input type="hidden" name="actions" value="<sc:fmt value='getKpiOptionData' type='crypto'/>"/>
        <input type="hidden" name="forward"
               value="<sc:fmt type='crypto' value='/funcpub/public/publicOptionControls/kpiOptionDialog.jsp' />"/>

        <!-- <input type="hidden" name="filter" value=""/> -->
        <input type="hidden" name="filter" value="<c:out value='${param.filter }' escapeXml='false' />"/>
        <input type="hidden" name="multi" value="<c:out value='${param.multi }' />"/>
        <input type="hidden" name="callback" value="<c:out value='${param.callback }' />"/>
        <input type="hidden" name="selectedColumn" value="<c:out value='${param.selectedColumn }' />"/>
        <input type="hidden" name="selected" value="<c:out value='${param.selected }' />"/>

        <%-- 规范： 初始化查询必加隐藏表单 --%>
        <sc:hidden name="jraf_initsubmit"/>

        <input type="hidden" name="pageNum" value="1"/>
        <input type="hidden" name="area" value="<c:out value='${param.area }' />"/>
        <input type="hidden" name="kpiType" value="<c:out value='${param.kpiType }' />"/>
        <input type="hidden" name="applyType" value="<c:out value='${param.applyType }' />"/>
        <div class="searchBar">
            <table class="searchContent" cellpadding="0" cellspacing="0">
                <tr>
                    <td class="form-label">指标编号</td>
                    <td class="form-value"><sc:text name="userCode"/></td>
                    <td class="form-label">指标名称</td>
                    <td class="form-value"><sc:text name="userName"/></td>
                    <td class="form-btn">
                        <ul>
                            <li>
                                <button id="selectKpiBtn" class="querybtn" jraf_initsubmit type="submit">查询</button>
                            </li>
                            <li>
                                <button class="resetbtn" type="reset">清空</button>
                            </li>
                        </ul>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</div>
<div class="pageContent">
    <div id="kpiTable" style="width:500px;float:left;margin-top:5px;margin-left:5px; height:340px;">
        <table class="table" cellpadding="0" cellspacing="0">
            <thead>
            <tr>
                <th>指标编号</th>
                <th>指标名称</th>
                <th>指标类型</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${empty jrafrpu.rspPkg.rspRcdDataMaps}">
                    <tr>
                        <td class="empty" colspan="3">查询无数据。</td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="kpi" items="${jrafrpu.rspPkg.rspRcdDataMaps}" varStatus="index">
                        <tr <c:if test="${index.index%2 != 0}"> class="evenrow"</c:if> >
                            <sc:hidden name="kpiCode" value="${kpi.kpiCode}"/>
                            <sc:hidden name="kpiName" value="${kpi.kpiName}"/>
                            <sc:hidden name="kpiType" value="${kpi.kpiType}"/>
                            <td>${kpi.kpiCode}</td>
                            <td>${kpi.kpiName}</td>
                            <td>
                                <c:if test="${kpi.kpiType == 'B'}">基础指标</c:if>
                                <c:if test="${kpi.kpiType == 'C'}">派生指标</c:if>
                                <c:if test="${kpi.kpiType == 'I'}">手工指标</c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
        <div class="panelBar">
            <div class="pagination" targetType="dialog"
                 totalCount="${jrafrpu.rspPkg.rspDataMap.PageInfo.RecordCount}"
                 numPerPage="${jrafrpu.rspPkg.rspDataMap.PageInfo.PageSize}"
                 currentPage="${jrafrpu.rspPkg.rspDataMap.PageInfo.PageNo}">
            </div>
        </div>
    </div>

    <div class="window-center-button">
        <button class="add" onclick="choseSelected();" type="button">选择--></button>
        <br><br>
        <c:if test="${param.multi == 'true' }">
            <button class="add" onclick="choseAll();" type="button">选择本页</button>
            <br><br>
        </c:if>
        <button class="delete" onclick="deleteSelected()" type="button"><--删除</button>
        <br><br>
        <button class="delete" onclick="deleteAll()" type="button"><--全删</button>
        <br><br>
        <button class="close" onclick="submit()" type="button">确定</button>
    </div>

    <div class="window-right-box" style="width:280px;">
        <ul id="selectedKpiTree" class="ztree"></ul>
    </div>
</div>
<script>
    var multi = "<c:out value='${param.multi}' />";
    if ("true" == multi) {
        multi = true;
    } else {
        multi = false;
    }
    var userSelectedSetting = {
        view: {
            dblClickExpand: function (treeId, treeNode) {
                return treeNode.level > 0;
            },
            showLine: false,// 是否显示连接线
            selectedMulti: multi,// 是否多选
            showIcon: true// 是否显示图标
        },
        data: {simpleData: {enable: true}},
        callback: {
            onDblClick: function () {
                deleteSelected();
            }
        }
    };
    $(function () {
        //edit by longjian 20160615 去掉了 isforward 参数， 暂时设置为false。不然一直加载
        /*
        var isforward = "false";
        if(isforward != "false"){
            $("#selectKpiBtn",$.pdialog.getCurrent()).trigger("click");
        }
        */
        $.fn.zTree.init($("#selectedKpiTree", $.pdialog.getCurrent()), userSelectedSetting, null);//id 对象 数据
        initselectedUserTree();//发送查询指标信息的请求
    });

    function initselectedUserTree() {
        var selected = "<c:out value='${param.selected}' />";
        var selectedColumn = "<c:out value='${param.selectedColumn}' />";
        var sysName = '<sc:fmt value='funcpub' type='crypto'/>';
        var oprID = '<sc:fmt value='publicOptionControls' type='crypto'/>';
        var actions = '<sc:fmt value='getSelectedKpiForKpiOption' type='crypto'/>';
        var url = "/xmlprocesserservlet?sysName=" + sysName + "&oprID=" + oprID + "&actions=" + actions + "&selected=" + selected + "&selectedColumn=" + selectedColumn;
        $.ajax({
            type: 'post',
            url: url,
            async: false,
            dataType: 'XML',
            success: function (data) {
                var selectedKpi = $(data).find('DataPacket Response Data selectedKpi').text();

                if (null != selectedKpi && selectedKpi.length > 0) {
                    selectedKpi = $.parseJSON(selectedKpi);
                    var treeObj = $.fn.zTree.getZTreeObj("selectedKpiTree");
                    if (multi) {//多选
                        $(selectedKpi).each(function () {
                            var kpi = $.parseJSON(this.info);
                            addSelectedNode(kpi.kpiCode, kpi.kpiName, kpi.kpiType);
                        });
                    } else {//单选
                        if (!!selectedKpi[0]) {
                            var kpi = $.parseJSON(selectedKpi[0].info);
                            addSelectedNode(kpi.kpiCode, kpi.kpiName, kpi.kpiType);
                        }
                    }

                }
            }
        });
    }

    function choseAll() {
        var treeObj = $.fn.zTree.getZTreeObj("selectedKpiTree");
        var tr = $("#kpiTable", $.pdialog.getCurrent()).find("tbody tr");
        treeObj.cancelSelectedNode();
        $(tr).each(function () {
            var kpiCode = $(this).find("[name='kpiCode']").val();
            var kpiName = $(this).find("[name='kpiName']").val();
            var kpiType = $(this).find("[name='kpiType']").val();
            addSelectedNode(kpiCode, kpiName, kpiType);
        });
        setForward();
    }

    function choseSelected() {
        var treeObj = $.fn.zTree.getZTreeObj("selectedKpiTree");
        var tr = $("#kpiTable", $.pdialog.getCurrent()).find("tbody tr.selected");
        if (null != tr && tr.length > 0) {
            treeObj.cancelSelectedNode();
            $(tr).each(function () {
                var kpiCode = $(this).find("[name='kpiCode']").val();
                var kpiName = $(this).find("[name='kpiName']").val();
                var kpiType = $(this).find("[name='kpiType']").val();
                if (multi) {
                    addSelectedNode(kpiCode, kpiName, kpiType);
                } else {
                    deleteAll();
                    addSelectedNode(kpiCode, kpiName, kpiType);
                }
            });
            setForward();
        }
    }

    function addSelectedNode(kpiCode, kpiName, kpiType) {
        var treeObj = $.fn.zTree.getZTreeObj("selectedKpiTree");
        var node = treeObj.getNodeByParam("id", kpiCode, null);
        if (node == null) {
            treeObj.addNodes(null, {
                id: kpiCode,
                name: "[" + kpiCode + "]" + kpiName,
                isParent: false,
                info: {kpiCode: kpiCode, kpiName: kpiName, kpiType: kpiType}
            });
            node = treeObj.getNodeByParam("id", kpiCode, null);
        }
        treeObj.selectNode(node, true);
    }

    function deleteSelected() {
        var treeObj = $.fn.zTree.getZTreeObj("selectedKpiTree");
        var nodes = treeObj.getSelectedNodes();
        $(nodes).each(function () {
            treeObj.removeNode(this);
        });
        setForward();
    }

    function deleteAll() {
        var treeObj = $.fn.zTree.getZTreeObj("selectedKpiTree");
        var nodes = treeObj.transformToArray(treeObj.getNodes());
        $(nodes).each(function () {
            treeObj.removeNode(this);
        });
        setForward();
    }

    function setForward() {
        var selected = new Array();
        var selectedColumn = "${param.selectedColumn}";
        var treeObj = $.fn.zTree.getZTreeObj("selectedKpiTree");
        var nodes = treeObj.transformToArray(treeObj.getNodes());
        $(nodes).each(function () {
            var kpi = this.info;
            selected.push(kpi.kpiCode);
        });
        /*
        var forward = "/funcpub/public/publicOptionControls/kpiOptionDialog.jsp"
                    + ""
                    + "&filter=
        <c:out value='${param.filter}' />"
				+ "&multi=
        <c:out value='${param.multi}' />"
				+ "&callback=
        <c:out value='${param.callback}' />"
				+ "&selectedColumn=
        <c:out value='${param.selectedColumn}' />"
				+ "&selected="+selected;
				*/
        $("[name='selected']", $.pdialog.getCurrent()).val(selected);
        //$("[name='forward']",$.pdialog.getCurrent()).val(forward);
    }

    function submit() {
        var callback = "<c:out value='${param.callback}' />";
        var kpiCode = "";
        var kpiName = "";
        var kpiType = "";
        var resultArray = new Array();
        var selectedTreeObj = $.fn.zTree.getZTreeObj("selectedKpiTree");
        var nodes = selectedTreeObj.transformToArray(selectedTreeObj.getNodes());
        $(nodes).each(function () {
            var kpi = this.info;
            kpiCode += kpi.kpiCode + ",";
            kpiName += kpi.kpiName + ",";
            kpiType += kpi.kpiType + ",";
            resultArray.push(kpi);
        });
        kpiCode = kpiCode.substring(0, kpiCode.length - 1);
        kpiName = kpiName.substring(0, kpiName.length - 1);
        kpiType = kpiType.substring(0, kpiType.length - 1);
        var resultObj = {kpiCode: kpiCode, kpiName: kpiName, kpiType: kpiType};
        eval(callback + "(resultArray,resultObj)");
    }
</script>
