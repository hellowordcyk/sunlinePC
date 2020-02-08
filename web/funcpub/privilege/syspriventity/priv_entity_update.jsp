<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 新增岗位
 * description: 
 *    新增岗位信息；
 * author: 
 * createtime:
 * logs:
 *     edited by LongJiang on 20160622 优化布局  
 *--%>
<form method="post" class="pageForm required-validate" onbeforesubmit="checkTableOrColumnExist()" onsubmit="return validateCallback(this,dialogAjaxDone)"
        action="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='privEntityActor' type='crypto'/>&actions=<sc:fmt value='updateSysPrivEntity' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>">
    <div class="pageContent">
        <div class="pageFormContent">
            <table class="form-table" cellpadding="0" cellspacing="0">
                <tr>
                    <td class="form-label">
                        <span class="redmust">*</span>实体编码
                    </td>
                    <td class="form-value" colspan="3">
                        <sc:text name="entityCode" readonly="true" index="1" validate="alphanumeric" attributesText="maxlength='32' minlength='4'" />
                    </td>
                </tr>
                <tr>
                    <td class="form-label">
                        <span class="redmust">*</span>实体名称
                    </td>
                    <td class="form-value" colspan="3">
                        <sc:text name="entityName" validate="required" index="1" />
                    </td>
                </tr>
                <tr>
                    <td class="form-label">
                        <span class="redmust">*</span>所属子系统
                    </td>
                    <td class="form-value" colspan="3">
                    	<sc:hidden name="systemCode" index="1"/>
                        <sc:optd name="systemCode" type="subsyscd" index="1" />
                    </td>
                </tr>
                <tr>
                    <td class="form-label"><span class="redmust">*</span>数据库实体表</td>
                    <td class="form-value" colspan="3">
                        <sc:text name="dbTable" validate="alphanumeric required" index="1"/>
                    </td>
                </tr>
                <tr>
                    <td class="form-label"><span class="redmust">*</span>实体表主键</td>
                    <td class="form-value">
                        <sc:text name="dbColumnPK" validate="alphanumeric required" index="1"/>
                    </td>
                    <td class="form-label"><span class="redmust">*</span>类型</td>
                    <td class="form-value">
                        <sc:select name="dbPKType" type="dict" key="pcmc,dbPKType" nullOption="--请选择--"  includeTitle="false"  validate="required"  index="1"/>
                    </td>
                </tr>
                <tr>
                    <td class="form-label"><span class="redmust">*</span>实体表标题字段</td>
                    <td colspan="3">
                        <sc:text name="dbColumnTitle" validate="alphanumeric required" index="1"/>
                    </td>
                </tr>
                <tr>
                    <td class="form-label"><span class="redmust">*</span>是否复合主键</td>
                    <td class="form-value" colspan="3">
                    	<sc:hidden name="isComposite" index="1"/>
                        <sc:optd name="isComposite" type="dict" key="pcmc,boolflag" index="1"/>
                    </td>
                </tr>
                <c:if test="${jrafrpu.rspPkg.rspRcdDataMaps[0].isComposite eq '1'}">
	                <tr>
	                    <td class="form-label">实体表扩展主键A</td>
	                    <td class="form-value">
	                        <sc:text name="dbColumnPKA" validate="alphanumeric "  index="1"/>
	                    </td>
	                    <td class="form-label">类型</td>
	                    <td class="form-value">
	                        <sc:select name="dbPKTypeA" type="dict" key="pcmc,dbPKType" nullOption="--请选择--"   includeTitle="false"  index="1"/>
	                    </td>
	                </tr>
	                <tr>
	                    <td class="form-label">实体表扩展主键B</td>
	                    <td class="form-value">
	                        <sc:text name="dbColumnPKB" validate="alphanumeric "  index="1"/>
	                    </td>
	                    <td class="form-label">类型</td>
	                    <td class="form-value">
	                        <sc:select name="dbPKTypeB" type="dict" key="pcmc,dbPKType" nullOption="--请选择--"  includeTitle="false"   index="1"/>
	                    </td>
	                </tr>
	                <tr>
	                    <td class="form-label">实体表扩展主键C</td>
	                    <td class="form-value">
	                        <sc:text name="dbColumnPKC" validate="alphanumeric "  index="1"/>
	                    </td>
	                    <td class="form-label">类型</td>
	                    <td class="form-value">
	                        <sc:select name="dbPKTypeC" type="dict" key="pcmc,dbPKType" nullOption="--请选择--"   includeTitle="false"  index="1"/>
	                    </td>
	                </tr>
	                <tr>
	                    <td class="form-label">实体表扩展主键D</td>
	                    <td class="form-value">
	                        <sc:text name="dbColumnPKD" validate="alphanumeric "  index="1"/>
	                    </td>
	                    <td class="form-label">类型</td>
	                    <td class="form-value">
	                        <sc:select name="dbPKTypeD" type="dict" key="pcmc,dbPKType" nullOption="--请选择--"   includeTitle="false"  index="1"/>
	                    </td>
	                </tr>
                </c:if>
                <tr>
                    <td class="form-label"><span class="redmust">*</span>实体表拥有者字段</td>
                    <td class="form-value" colspan="3">
                        <sc:text name="dbColumnOwner" validate="alphanumeric required" index="1"/>
                    </td>
                </tr>
                <tr>
                    <td class="form-label"><span class="redmust">*</span>实体表部门字段</td>
                    <td class="form-value" colspan="3">
                        <sc:text name="dbColumnDept" validate="alphanumeric required" index="1"/>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <div class="formBar">
        <ul>
        	<li>
                <button class="savebtn" type="button" onclick="validate()">验证</button>
            </li>
            <li>
                <button class="savebtn" type="submit">保存</button>
            </li>
            <li>
                <button class="close" type="button">取消</button>
            </li>
        </ul>
    </div>
</form>
<script type="text/javascript">
	var pageScope = $.pdialog.getCurrent();
	var info = "验证成功！";
	function validate() {
		var status = checkTableOrColumnExist();
		if(status) {
			alertMsg.correct(info);
		}else{
			alertMsg.warn(info);
		}
	}
	
	function checkTableOrColumnExist() {
		var status = false;
		info = "";
		var $form = $("form.pageForm",pageScope).first();
		var url = "/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>"
			+"&oprID=<sc:fmt value='privEntityActor' type='crypto'/>"
			+"&actions=<sc:fmt value='checkTableOrColumnExist' type='crypto'/>";
		$.ajax({    
	        type:'post',        
	        url:url,
	        data:$form.serializeArray(),
	        async:false,   
	        dataType:'xml', 
	        success:function(data){   
				var retCode = $(data).find("DataPacket Response Data retCode").text();
				var retMessage = $(data).find("DataPacket Response Data retMessage").text();
				info = retMessage;
				if("200"==retCode) {
					status = true;
				}else{
					alertMsg.warn(info);
					status = false;
				}
	        }
	    });
		return status;
	}
</script>