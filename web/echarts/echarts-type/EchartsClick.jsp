<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="java.util.List"%>
<%@ page import="org.jdom.*"%>
<%@ page import="com.sunline.jraf.web.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>ECharts</title>
</head>
<body>
    <!-- 为ECharts准备一个具备大小（宽高）的Dom -->
    <div id="main" style="height:500px"></div>
    <!-- ECharts单文件引入 -->
    <script src="/echarts/build/dist/echarts.js"></script>
    <script type="text/javascript">
        // 路径配置
        require.config({
            paths: {
                echarts: '/echarts/build/dist'
            }
        });
        
        // 使用
        require(
            [
                'echarts',
                'echarts/chart/pie',
                'echarts/chart/funnel' // 使用柱状图就加载bar模块，按需加载
            ],
            function (ec) {
                // 基于准备好的dom，初始化echarts图表
                var myChart = ec.init(document.getElementById('main')); 
                // 通过require获得echarts接口（或者命名空间）后可实例化图表
                
                var option = {
                	    tooltip : {
                	        trigger: 'axis'
                	    },
                	    legend: {
                	        data:['最高','最低']
                	    },
                	    toolbox: {
                	        show : true,
                	        feature : {
                	            mark : {show: true},
                	            dataView : {readOnly:false},
                	            magicType : {show: true, type: ['line', 'bar', 'stack', 'tiled']},
                	            restore : {show: true},
                	            saveAsImage : {show: true}
                	        }
                	    },
                	    calculable : true,
                	    dataZoom : {
                	        show : true,
                	        realtime : true,
                	        start : 40,
                	        end : 60
                	    },
                	    xAxis : [
                	        {
                	            type : 'category',
                	            boundaryGap : true,
                	            data : function (){
                	                var list = [];
                	                for (var i = 1; i <= 30; i++) {
                	                    list.push('2013-03-' + i);
                	                }
                	                return list;
                	            }()
                	        }
                	    ],
                	    yAxis : [
                	        {
                	            type : 'value'
                	        }
                	    ],
                	    series : [
                	        {
                	            name:'最高',
                	            type:'line',
                	            data:function (){
                	                var list = [];
                	                for (var i = 1; i <= 30; i++) {
                	                    list.push(Math.round(Math.random()* 30) + 30);
                	                }
                	                return list;
                	            }()
                	        },
                	        {
                	            name:'最低',
                	            type:'bar',
                	            data:function (){
                	                var list = [];
                	                for (var i = 1; i <= 30; i++) {
                	                    list.push(Math.round(Math.random()* 10));
                	                }
                	                return list;
                	            }()
                	        }
                	    ]
                	};
                	var ecConfig = require('echarts/config');
                	function eConsole(param) {
                	    var mes = '【' + param.type + '】';
                	    if (typeof param.seriesIndex != 'undefined') {
                	        mes += '  seriesIndex : ' + param.seriesIndex;
                	        mes += '  dataIndex : ' + param.dataIndex;
                	    }
                	    if (param.type == 'hover') {
                	        document.getElementById('hover-console').innerHTML = 'Event Console : ' + mes;
                	    }
                	    else {
                	        document.getElementById('console').innerHTML = mes;
                	    }
                	}
                	/*
                	// -------全局通用
                	REFRESH: 'refresh',
                	RESTORE: 'restore',
                	RESIZE: 'resize',
                	CLICK: 'click',
                	DBLCLICK: 'dblclick',
                	HOVER: 'hover',
                	MOUSEOUT: 'mouseout',
                	// -------业务交互逻辑
                	DATA_CHANGED: 'dataChanged',
                	DATA_ZOOM: 'dataZoom',
                	DATA_RANGE: 'dataRange',
                	DATA_RANGE_HOVERLINK: 'dataRangeHoverLink',
                	LEGEND_SELECTED: 'legendSelected',
                	LEGEND_HOVERLINK: 'legendHoverLink',
                	MAP_SELECTED: 'mapSelected',
                	PIE_SELECTED: 'pieSelected',
                	MAGIC_TYPE_CHANGED: 'magicTypeChanged',
                	DATA_VIEW_CHANGED: 'dataViewChanged',
                	TIMELINE_CHANGED: 'timelineChanged',
                	MAP_ROAM: 'mapRoam',
                	*/
                	myChart.on(ecConfig.EVENT.CLICK, eConsole);
                	myChart.on(ecConfig.EVENT.DBLCLICK, eConsole);
                	//myChart.on(ecConfig.EVENT.HOVER, eConsole);
                	myChart.on(ecConfig.EVENT.DATA_ZOOM, eConsole);
                	myChart.on(ecConfig.EVENT.LEGEND_SELECTED, eConsole);
                	myChart.on(ecConfig.EVENT.MAGIC_TYPE_CHANGED, eConsole);
                	myChart.on(ecConfig.EVENT.DATA_VIEW_CHANGED, eConsole);
                	                    
                // 为echarts对象加载数据 
                myChart.setOption(option); 
            }
        );
    </script>
</body>