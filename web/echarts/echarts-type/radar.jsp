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
                'echarts/chart/radar' // 使用柱状图就加载bar模块，按需加载
            ],
            function (ec) {
                // 基于准备好的dom，初始化echarts图表
                var myChart = ec.init(document.getElementById('main')); 
                // 通过require获得echarts接口（或者命名空间）后可实例化图表
                
                var option = {//图表选项
                	    title : {//标题
                	        text: '预算 vs 开销（Budget vs spending）',
                	        subtext: '纯属虚构'
                	    },
                	    tooltip : {//提示框
                	        trigger: 'axis'//触发类型，默认数据触发
                	    },
                	    legend: {//图例
                	        orient : 'vertical',//布局方式，默认为水平布局，可选为：'horizontal' | 'vertical'
                	        x : 'right',
                	        y : 'bottom',
                	        data:['预算分配（Allocated Budget）','实际开销（Actual Spending）']
                	    },
                	    toolbox: {//工具箱
                	        show : true,
                	        feature : {//启用功能
                	            mark : {show: true},
                	            dataView : {show: true, readOnly: false},//数据显示可编辑
                	            restore : {show: true},//还原
                	            saveAsImage : {show: true}//保存为图片
                	        }
                	    },
                	    polar : [
                	       {
                	           indicator : [//设置6个顶点的最大值
                	               { text: '销售（sales）', max: 6000},
                	               { text: '管理（Administration）', max: 16000},
                	               { text: '信息技术（Information Techology）', max: 30000},
                	               { text: '客服（Customer Support）', max: 38000},
                	               { text: '研发（Development）', max: 52000},
                	               { text: '市场（Marketing）', max: 25000}
                	            ]
                	        }
                	    ],
                	    calculable : true,//启用拖拽重计算特性
                	    series : [//驱动图表生成的数据内容
                	        {
                	            name: '预算 vs 开销（Budget vs spending）',
                	            type: 'radar',
                	            data : [
                	                {
                	                    value : [4300, 10000, 28000, 35000, 50000, 19000],
                	                    name : '预算分配（Allocated Budget）'
                	                },
                	                 {
                	                    value : [5000, 14000, 28000, 31000, 42000, 21000],
                	                    name : '实际开销（Actual Spending）'
                	                }
                	            ]
                	        }//数据 类型 数据
                	    ]
                	};
                	                    
                	                     
        
                // 为echarts对象加载数据 
                myChart.setOption(option); 
            }
        );
    </script>
</body>