<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
 /**
  * 1. “submitDivId”必加参数是加载分页列表的位置，即Jraf.Ajax.loadPageTo的最后 一个参数。
  * 2. doAfterLoad_${param.submitDivId }方法是自定义的，在分页加载 数据后执行，可以加也可以不加。
  */
 --%>
<div id="_loadbox_${param.submitDivId }" style="display:none; position:absolute;right:30px;top:25px;background:#CD281B;border:1px solid;color:#FFFFFF">
    正在查询，请等候...
</div>
<div id="_pager_ID_${param.submitDivId }" class="result">
    <input type="hidden" name="submitDivId" value="${param.submitDivId }"/>
        <c:choose>
         <c:when test="${ jrafrpu.rspPkg.rspPageCount <= 1 && jrafrpu.rspPkg.rspPageNo <= 1 }">
             <input type="button" class="page_first" onclick="firstPage_${param.submitDivId }();" value="首页" disabled="disabled" >
             <input type="button" class="page_prev" onclick="prevPage_${param.submitDivId }();" value="上页" disabled="disabled" >
             <input type="button" class="page_next" onclick="nextPage_${param.submitDivId }();" value="下页" disabled="disabled" >
             <input type="button" class="page_last" onclick="lastPage_${param.submitDivId }();" value="尾页" disabled="disabled" >
         </c:when>
         <c:when test="${ jrafrpu.rspPkg.rspPageNo <= 1}">
             <input type="button" class="page_first" onclick="firstPage_${param.submitDivId }();" value="首页" disabled="disabled" >
             <input type="button" class="page_prev" onclick="prevPage_${param.submitDivId }();" value="上页" disabled="disabled" >
             <input type="button" class="page_next" onclick="nextPage_${param.submitDivId }();" value="下页" >
             <input type="button" class="page_last" onclick="lastPage_${param.submitDivId }();" value="尾页" >
         </c:when>
         <c:when test="${ jrafrpu.rspPkg.rspPageCount <= jrafrpu.rspPkg.rspPageNo }">
             <input type="button" class="page_first" onclick="firstPage_${param.submitDivId }();" value="首页">
             <input type="button" class="page_prev" onclick="prevPage_${param.submitDivId }();" value="上页">
             <input type="button" class="page_next" onclick="nextPage_${param.submitDivId }();" value="下页" disabled="disabled" >
             <input type="button" class="page_last" onclick="lastPage_${param.submitDivId }();" value="尾页" disabled="disabled" >
         </c:when>
         <c:otherwise>
             <input type="button" class="page_first" onclick="firstPage_${param.submitDivId }();" value="首页">
             <input type="button" class="page_prev" onclick="prevPage_${param.submitDivId }();" value="上页" >
             <input type="button" class="page_next" onclick="nextPage_${param.submitDivId }();" value="下页" >
             <input type="button" class="page_last" onclick="lastPage_${param.submitDivId }();" value="尾页" >
         </c:otherwise>
     </c:choose> 
    <b>${ jrafrpu.rspPkg.rspPageNo}</b>/<b>${ jrafrpu.rspPkg.rspPageCount}</b>
    <sc:text attributesText="size='3' height='4' id='PageNo_${param.submitDivId }' 
     onkeydown='if(window.event.keyCode == \"13\"){goPage_${param.submitDivId}();}'" 
        default="1" name="PageNo" xmlpath="/DataPacket/Response/Data/PageInfo" 
        _class="pageno" type="int" dspName="输入页码"/>
    <a href="#" onClick="goPage_${param.submitDivId}();" style="width: 14px;display: inline;"><b>GO</b></a>
</div>
<script type="text/javascript" defer="defer">
new Jraf.Outlinetor("#${param.submitDivId } .list-table tbody tr");
<c:if test="${empty param.submitDivId }">
alert("[pager_ajax_smpl.jsp]ERROR: 参数submitDivId必须传入！");
</c:if>
eval(
"function firstPage_${param.submitDivId }(){"+
"    document.getElementById('PageNo_${param.submitDivId }').value=1;"+    
"    goPage_${param.submitDivId }();"+
"}"+

"function lastPage_${param.submitDivId }(){"+
"    document.getElementById('PageNo_${param.submitDivId }').value='${ jrafrpu.rspPkg.rspPageCount }';"+
"    goPage_${param.submitDivId }();"+
"}" +

"function prevPage_${param.submitDivId }(){"+
"    var oPageNo = document.getElementById('PageNo_${param.submitDivId }');   "+
"    oPageNo.value=parseInt('${ jrafrpu.rspPkg.rspPageNo}')-1;"+
"    goPage_${param.submitDivId }();"+
"}"+

"function nextPage_${param.submitDivId }(){"+
"    var oPageNo = document.getElementById('PageNo_${param.submitDivId }');   "+
"    oPageNo.value=parseInt('${ jrafrpu.rspPkg.rspPageNo}')+1;"+
"    goPage_${param.submitDivId }();"+
"}"+

"function goPage_${param.submitDivId }(){"+
"    var count = '${ jrafrpu.rspPkg.rspPageCount}';"+
"    var re = /^[1-9][0-9]*$/g;"+
"    var s = document.getElementById('PageNo_${param.submitDivId }').value;"+
"    if (re.test(s)){"+
"        try {"+
"           count = parseInt(count) <= 0 ? 1 : parseInt(count);"+ 
"        } catch(e) { count = 1;}"+
"        if (count < s ) { document.getElementById('PageNo_${param.submitDivId }').value = count;}"+
"        if (count <= 0) { document.getElementById('PageNo_${param.submitDivId }').value = 1;}"+

"        Element.show('_loadbox_${param.submitDivId }');"+
"        var oForm = $('_pager_ID_${param.submitDivId }').up('form');"+
"        var param = oForm.serialize(true);"+
"        var id = oForm.elements('submitDivId').value;"+
"        $(id).update('');"+
"        var ajax = new Jraf.Ajax({asynchronous: false});"+
"        ajax.loadPageTo('/httpprocesserservlet', param , id, function () {"+ 
"            if ( typeof (doAfterLoad_${param.submitDivId }) == 'function') {"+
"                doAfterLoad_${param.submitDivId}();"+
"            }"+
"        });"+
"    }else{"+
"        firstPage_${param.submitDivId}();"+
"    }"+
"}");
</script>