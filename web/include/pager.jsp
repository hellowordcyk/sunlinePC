<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div id="_loadbox" style="display:none; position:absolute;right:30px;top:25px;background:#CD281B;border:1px solid;color:#FFFFFF">正在查询，请等候...</div>
<div class="result">
	<span>查询结果： 共 <b>${ jrafrpu.rspPkg.rspRecordCount}</b> 条记录，第 <b>${ jrafrpu.rspPkg.rspPageNo}</b> 页，共 <b>${ jrafrpu.rspPkg.rspPageCount}</b>页</span>
	<span>到第
	    <sc:text attributesText="size='3' height='4' id='PageNo'" default="1" name="PageNo" xmlpath="/DataPacket/Response/Data/PageInfo" _class="pageno" type="int" dspName="输入页码"/>&nbsp;页&nbsp;
	    <a href="#" onClick="goPage();" style="width: 14px;display: inline;"><b>GO</b></a>
	    <c:choose>
	     <c:when test="${ jrafrpu.rspPkg.rspPageCount <= 1 && jrafrpu.rspPkg.rspPageNo <= 1 }">
	         <input type="button" class="page_first" onclick="firstPage();" value="首页" disabled="disabled" >
	         <input type="button" class="page_prev" onclick="prevPage();" value="上页" disabled="disabled" >
	         <input type="button" class="page_next" onclick="nextPage();" value="下页" disabled="disabled" >
	         <input type="button" class="page_last" onclick="lastPage();" value="尾页" disabled="disabled" >
	     </c:when>
	     <c:when test="${ jrafrpu.rspPkg.rspPageNo <= 1}">
	         <input type="button" class="page_first" onclick="firstPage();" value="首页" disabled="disabled" >
	         <input type="button" class="page_prev" onclick="prevPage();" value="上页" disabled="disabled" >
	         <input type="button" class="page_next" onclick="nextPage();" value="下页" >
	         <input type="button" class="page_last" onclick="lastPage();" value="尾页" >
	     </c:when>
	     <c:when test="${ jrafrpu.rspPkg.rspPageCount <= jrafrpu.rspPkg.rspPageNo }">
	         <input type="button" class="page_first" onclick="firstPage();" value="首页">
	         <input type="button" class="page_prev" onclick="prevPage();" value="上页">
	         <input type="button" class="page_next" onclick="nextPage();" value="下页" disabled="disabled" >
	         <input type="button" class="page_last" onclick="lastPage();" value="尾页" disabled="disabled" >
	     </c:when>
	     <c:otherwise>
	         <input type="button" class="page_first" onclick="firstPage();" value="首页">
	         <input type="button" class="page_prev" onclick="prevPage();" value="上页" >
	         <input type="button" class="page_next" onclick="nextPage();" value="下页" >
	         <input type="button" class="page_last" onclick="lastPage();" value="尾页" >
	     </c:otherwise>
	 </c:choose>
	</span>
</div>
<script type="text/javascript">
Event.observe(window, 'load', function() { 
	new Jraf.Outlinetor(".list-table tbody tr");
}); 
function firstPage()
{
    document.getElementById('PageNo').value=1;
    goPage();
}
function lastPage()
{
    document.getElementById('PageNo').value='${ jrafrpu.rspPkg.rspPageCount }';
    goPage();
}
function prevPage()
{
    document.getElementById('PageNo').value=parseInt('${ jrafrpu.rspPkg.rspPageNo}')-1;
    goPage();
}
function nextPage()
{
    document.getElementById('PageNo').value=parseInt('${ jrafrpu.rspPkg.rspPageNo}')+1;
    goPage();
}
function goPage()
{
    var count = '${ jrafrpu.rspPkg.rspPageCount}';
    var re = /^[1-9][0-9]*$/g;
    var s = document.getElementById('PageNo').value;
    if (re.test(s))
    {
        try {
            count = parseInt(count) <= 0 ? 1 : parseInt(count);
        } catch(e) {
            count = 1;
        }
        if (count < s) {
            document.getElementById('PageNo').value = count;
        }
        if (count <= 0) {
            document.getElementById('PageNo').value = 1;
        }
    	Element.show('_loadbox');
        document.forms["page_form"].submit();
    } else {
    	alert("页码必须是正整数");
    }
}

/**
*以下函数用于记录的选择
*/
function checkCkSelected(oForm){
	window.event.returnValue = false;

	for (var i=0;i<oForm.all.tags("input").length;i++){
        var ele = oForm.all.tags("input")[i];
        var ct = ele.getAttribute("type");
        if ((ele.type=="checkbox")&&(ele.checked==true))
        return true;
    }
    return false;
}

function checkAll(ck)
{
  for (var i=0;i<ck.form.all.tags("input").length;i++){
    var ele = ck.form.all.tags("input")[i];
    //var ct = ele.getAttribute("type");
    if ((ele.type=="checkbox")){
      if(ck.checked!=ele.checked)
        ele.click();
    }
  }
}

function checkSelected(sName){
   window.event.returnValue = false;
   var chs = document.getElementsByName(sName);
   for(var i=0;i<chs.length;i++){
      var ele = chs[i];
      if(ele.type=="checkbox" && ele.checked==true)
          return true;
   }
   return false;
}

function editSelected(sName)
{
    var chs = document.getElementsByName(sName);
    var num = 0;
    var selOne = null;
    for(var i=0;i<chs.length;i++){
       var ele = chs[i];
       if(ele.type=="checkbox" && ele.checked==true){
           num++;
           selOne = ele;
       }
       if(num>1){
           alert("请选择一项要编辑的数据！");
           return false;
       }
    }
    if(num == 0){
        alert("请选择一项要编辑的数据！");
        return false;
    }
    toEdit(selOne);
}

function deleteSelected(sName)
{

   if (!checkSelected(sName))
   {
      alert("请选择要删除的数据！");
      return false;
   }
   if (confirm("你确定要删除选中的数据？"))
   {
      doDelete(sName);
   }
}
/*此方法被Jraf.Outlinetor替代*/
function outlineMyRow(ckr)
{
    /*var otr = ckr.parentElement.parentElement;
    if(otr.tagName.toUpperCase()=="TR"){
        if(ckr.checked==true){
            if(!ckr.ocls) ckr.setAttribute("ocls","");
            ckr.ocls = otr.className!='select'?otr.className:ckr.ocls;
            otr.className="select";
        }else{
            otr.className=ckr.ocls;
        }
    }*/
}
</script>