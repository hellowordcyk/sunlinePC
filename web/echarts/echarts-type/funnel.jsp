<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common_tag.jsp" %>
<!DOCTYPE html>
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
                'echarts/chart/funnel'// 使用柱状图就加载bar模块，按需加载
            ],
            function (ec) {
                // 基于准备好的dom，初始化echarts图表
                var myChart = ec.init(document.getElementById('main')); 
                // 通过require获得echarts接口（或者命名空间）后可实例化图表
                
                var option = { //驱动图表生成的数据内容数组
                	    title : {//标题
                	        text: '漏斗图',
                	        subtext: '纯属虚构'
                	    },
                	    tooltip : {//提示框
                	        trigger: 'item',
                	        formatter: "{a} <br/>{b} : {c}%"
                	    },
                	    toolbox: {//工具箱
                	        show : true,
                	        feature : { //启用功能
                	            mark : {show: true},
                	            dataView : {show: true, readOnly: false},
                	            restore : {show: true},
                	            saveAsImage : {show: true}
                	        }
                	    },
                	    legend: {//图例
                	        data : ['展现','点击','访问','咨询','订单']
                	    },
                	    calculable : true,//是否启用拖拽重计算特性
                	    series : [//驱动图表生成的数据内容
                	        {
                	            name:'漏斗图',
                	            type:'funnel',
                	            width: '40%',
                	            data:[
                	                {value:60, name:'访问'},
                	                {value:40, name:'咨询'},
                	                {value:20, name:'订单'},
                	                {value:80, name:'点击'},
                	                {value:100, name:'展现'}
                	            ]
                	        },
                	        {
                	            name:'金字塔',
                	            type:'funnel',
                	            x : '50%',//左上角横坐标，数值单位px，支持百分比
                	            sort : 'ascending',//数据排序， 可以取ascending, descending
                	            itemStyle: {//数据排序， 可以取ascending, descending
                	                normal: {
                	                    // color: 各异,
                	                    label: {
                	                        position: 'left'//位置
                	                    }
                	                }
                	            },
                	            data:[//数值 名称
                	                {value:60, name:'访问'},
                	                {value:40, name:'咨询'},
                	                {value:20, name:'订单'},
                	                {value:80, name:'点击'},
                	                {value:100, name:'展现'}
                	            ]
                	        }
                	    ]
                	};
                	                    
                	                    
        
                // 为echarts对象加载数据 
                myChart.setOption(option); 
            }
        );
    </script>
</body>