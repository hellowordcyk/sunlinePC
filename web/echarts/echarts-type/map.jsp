<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>
    <meta charset="utf-8">
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
                'echarts/chart/map' // 使用柱状图就加载bar模块，按需加载
            ],
            function (ec) {
                // 基于准备好的dom，初始化echarts图表
                var myChart = ec.init(document.getElementById('main')); 
                
                var option = {
                	    tooltip : {
                	        trigger: 'item',
                	        formatter: '{b}'
                	    },
                	    series : [
                	        {
                	            name: '中国',
                	            type: 'map',
                	            mapType: 'china',
                	            selectedMode : 'multiple',
                	            itemStyle:{
                	                normal:{label:{show:true}},
                	                emphasis:{label:{show:true}}
                	            },
                	            data:[
                	                {name:'广东',selected:true}
                	            ]
                	        }
                	    ]
                	};
                	var ecConfig = require('echarts/config');
                	myChart.on(ecConfig.EVENT.MAP_SELECTED, function (param){
                	    var selected = param.selected;
                	    var str = '当前选择： ';
                	    for (var p in selected) {
                	        if (selected[p]) {
                	            str += p + ' ';
                	        }
                	    }
                	    document.getElementById('wrong-message').innerHTML = str;
                	})
                	                    
        
                // 为echarts对象加载数据 
                myChart.setOption(option); 
            }
        );
    </script>
</body>