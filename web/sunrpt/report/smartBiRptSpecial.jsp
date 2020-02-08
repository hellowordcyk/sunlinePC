<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/jui_tag.jsp"%>
<!DOCTYPE html>
<iframe height="600" width="1200" frameborder="0" src="http://10.22.80.24:7028/smartbi/vision/openresource.jsp?resid=${param.resId}&user=user&password=user"></iframe>
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