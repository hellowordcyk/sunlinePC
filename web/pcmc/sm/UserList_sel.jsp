<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common.jsp" %>

<display:table uid="record" name="jrafrpu.rspPkg.rspRcdDataMaps" class="list-table" requestURI="/httpprocesserservlet"
              sort="list">
    <display:column style="text-align: center" title="<input type='checkbox' name='allbox' onclick='checkAll(this)'>">
        <c:if test="${record.rolecount != '0'}">
            <input type="checkbox" name="userid" onclick="outlineMyRow(this)" value='${record.userid }' checked="checked"/>
        </c:if>
        <c:if test="${record.rolecount == '0'}">
            <input type="checkbox" name="userid" onclick="outlineMyRow(this)" value='${record.userid }' />
        </c:if>
    </display:column>
    <display:column title="序号">
        ${record_rowNum }
    </display:column>
    <display:column property="usercode" title="用户编号" />
    <display:column property="username" title="用户名称" />
    <display:column property="deptname" title="所在部门" />
</display:table>
<script type="text/javascript" defer="defer">
new Jraf.Outlinetor(".list-table tbody tr");

function outlineMyRow(ckr)
{
    var otr = ckr.parentElement.parentElement;
    if(otr.tagName.toUpperCase()=="TR"){
        if(ckr.checked==true){
            if(!ckr.ocls) ckr.setAttribute("ocls","");
            ckr.ocls = otr.className!='select'?otr.className:ckr.ocls;
            otr.className="select";
        }else{
            otr.className=ckr.ocls;
        }
    }
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

</script>