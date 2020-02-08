<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
	<%@ include file="/common.jsp"%>
	<title>页面皮肤切换</title>
</head>
<body style="padding: 5px;">
    <table cellpadding="0" cellspacing="0" class="form-table" style="margin: 0">
        <tr>
            <th>更换皮肤</th>
        </tr>
        <tr>
            <td class='' style='padding-left: 20px'>
                <label for="blueSkin">
                    <input type='radio' id="blueSkin" name='skinbtn' value='outlook' /> 默认皮肤（蓝色）
                </label>
            </td>
        </tr>
        <tr>
            <td class='' style='padding-left: 20px'>
                <label for="redSkin">
                    <input type='radio' id="redSkin" name='skinbtn' value='redstyle' />金典红色 
                </label>
            </td>
        </tr>
        <tr class='form-bottom'>
            <td>
                <sc:button value="确定" onclick='clikcSkin()'/>
            </td>
        </tr>
    </table>
</body>
<script type="text/javascript">
function clikcSkin(){
	var obj = document.getElementsByName("skinbtn");
	for(var i=0;i<obj.length;i++){
		if(obj[i].checked){
    		window.returnValue=obj[i].value;
    		window.close();
		}
	}
}
</script>
</html>