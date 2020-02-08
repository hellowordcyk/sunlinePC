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
                
                var option = {
                	    tooltip : {  //提示框，鼠标悬浮交互时的信息提示
                	        trigger: 'axis'////触发类型，默认数据触发，见下图，可选为：'item' | 'axis'
                	    },
                	    toolbox: {////工具箱，每个图表最多仅有一个工具箱
                	        show : true,
                	        feature : {//启用功能
                	            mark : {show: true},
                	            dataView : {show: true, readOnly: false},//数据视图可编辑
                	            magicType: {show: true, type: ['line', 'bar']},//动态类型切换，支持直角系下的折线图、柱状图、堆积、平铺转换
                	            restore : {show: true},//还原
                	            saveAsImage : {show: true}//保存图片
                	        }
                	    },
                	    calculable : true,//是否启用拖拽重计算特性，默认关闭
                	    legend: {//图例
                	        data:['蒸发量','降水量','平均温度']//图例内容数组
                	    },
                	    xAxis : [//横轴
                	        {
                	            type : 'category',
                	            data : ['1月','2月','3月','4月','5月','6月','7月','8月','9月','10月','11月','12月']
                	        }
                	    ],
                	    yAxis : [//竖轴
                	        {
                	            type : 'value',
                	            name : '水量',
                	            axisLabel : {//坐标轴文本标签
                	                formatter: '{value} ml'//文本格式
                	            }
                	        },
                	        {
                	            type : 'value',
                	            name : '温度',
                	            axisLabel : {
                	                formatter: '{value} °C'
                	            }
                	        }
                	    ],
                	    series : [//驱动图表生成的数据内容数组，数组中每一项为一个系列的选项及数据，其中个别选项仅在部分图表类型中有效，请注意适用类型：

                	        {
                	            name:'蒸发量', //名称、类型、数据
                	            type:'bar',
                	            data:[2.0, 4.9, 7.0, 23.2, 25.6, 76.7, 135.6, 162.2, 32.6, 20.0, 6.4, 3.3]
                	        },
                	        {
                	            name:'降水量',
                	            type:'bar',
                	            data:[2.6, 5.9, 9.0, 26.4, 28.7, 70.7, 175.6, 182.2, 48.7, 18.8, 6.0, 2.3]
                	        },
                	        {
                	            name:'平均温度',
                	            type:'line',
                	            yAxisIndex: 1,
                	            data:[2.0, 2.2, 3.3, 4.5, 6.3, 10.2, 20.3, 23.4, 23.0, 16.5, 12.0, 6.2]
                	        }
                	    ]
                	};
                	                    
                	                    
        
                // 为echarts对象加载数据 
                myChart.setOption(option); 
            }
        );
    </script>
</body>