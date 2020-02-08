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
                'echarts/chart/line',
                'echarts/chart/bar' // 使用柱状图就加载bar模块，按需加载
            ],
            function (ec) {
                // 基于准备好的dom，初始化echarts图表
                var myChart = ec.init(document.getElementById('main')); 
                // 通过require获得echarts接口（或者命名空间）后可实例化图表
                
                var option = {//图表选项
                	    title : {//标题
                	        text: '未来一周气温变化',
                	        subtext: '纯属虚构'
                	    },
                	    tooltip : {//提示框
                	        trigger: 'axis'//数据触发类型
                	    },
                	    legend: {//图例
                	        data:['最高气温','最低气温']
                	    },
                	    toolbox: {//工具箱
                	        show : true,
                	        feature : {//启用的功能
                	            mark : {show: true},
                	            dataView : {show: true, readOnly: false},//数据显示可编辑
                	            magicType : {show: true, type: ['line', 'bar']},//动态类型切换
                	            restore : {show: true},//还原
                	            saveAsImage : {show: true}//保存图片
                	        }
                	    },
                	    calculable : true,//启用拖拽重计算特性
                	    xAxis : [//横轴
                	        {
                	            type : 'category',//坐标轴类型，横轴默认为类目型'category'，纵轴默认为数值型'value'
                	            boundaryGap : false,//类目起始和结束两端空白策略，默认为true留空，false则顶头
                	            data : ['周一','周二','周三','周四','周五','周六','周日']
                	        }
                	    ],
                	    yAxis : [//竖轴
                	        {
                	            type : 'value',
                	            axisLabel : {//坐标轴文本标签
                	                formatter: '{value} °C'//格式
                	            }
                	        }
                	    ],
                	    series : [//驱动图表生成的数据内容
                	        {
                	            name:'最高气温',
                	            type:'line',
                	            data:[11, 11, 15, 13, 12, 13, 10],
                	            markPoint : {//系列中的数据标注内容
                	                data : [
                	                    {type : 'max', name: '最大值'},
                	                    {type : 'min', name: '最小值'}
                	                ]
                	            },
                	            markLine : {//系列中的数据标线内容
                	                data : [
                	                    {type : 'average', name: '平均值'}
                	                ]
                	            }
                	        },
                	        {
                	            name:'最低气温',
                	            type:'line',
                	            data:[1, -2, 2, 5, 3, 2, 0],
                	            markPoint : {
                	                data : [
                	                    {name : '周最低', value : -2, xAxis: 1, yAxis: -1.5}
                	                ]
                	            },
                	            markLine : {
                	                data : [
                	                    {type : 'average', name : '平均值'}
                	                ]
                	            }
                	        }
                	    ]
                	};
                	                    
                	                    
                	                    
                	                    
        
                // 为echarts对象加载数据 
                myChart.setOption(option); 
            }
        );
    </script>
</body>