<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/jui_tag.jsp"%>
<!DOCTYPE html>
<%-- <jsp:include page="http://10.22.80.24:7028/smartbi/vision/openresource.jsp?resid=I8a96d08b016306140614b71c01632485f8df1ed4&user=admin&password=admin" flush="true" ></jsp:include> --%>
<iframe height="600" width="1200" frameborder="0" scrolling="auto" src="http://10.22.80.24:7028/smartbi/vision/openresource.jsp?resid=${param.resId}&user=admin&password=admin"></iframe>
<script>
	$(function(){
		$("iframe").attr("width",$(".layoutBox").width());
		$("iframe").attr("height",$(".layoutBox").height());
		$("iframe").parents('.page').css('overflow','hidden');
		$(window).resize(function(){
			$("iframe").attr("width",$(".layoutBox").width());
			$("iframe").attr("height",$(".layoutBox").height());
		});
		$('.changescale').remove();
	});
</script>
