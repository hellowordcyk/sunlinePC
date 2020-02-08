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
                'echarts/chart/chord',
                'echarts/chart/force' // 使用柱状图就加载bar模块，按需加载
            ],
            function (ec) {
                // 基于准备好的dom，初始化echarts图表
                var myChart = ec.init(document.getElementById('main')); 
                // 通过require获得echarts接口（或者命名空间）后可实例化图表
                
                var option = {//图表选项，包含图表实例任何可配置选项： 公共选项 ， 组件选项 ， 数据选项
                	    title : {//图表选项，包含图表实例任何可配置选项： 公共选项 ， 组件选项 ， 数据选项
                	        text: '测试数据',//主标题文本，'\n'指定换行
                	        subtext: 'From d3.js',//副标题文本，'\n'指定换行
                	        x:'right',//水平安放位置，默认为左侧，可选为：'center' | 'left' | 'right' | {number}（x坐标，单位px）
                	        y:'bottom'//垂直安放位置，默认为全图顶端，可选为：'top' | 'bottom' | 'center' | {number}（y坐标，单位px）
                	    },
                	    tooltip : {//提示框，鼠标悬浮交互时的信息提示
                	        trigger: 'item',//触发类型，默认数据触发，见下图，可选为：'item' | 'axis'
                	        formatter: function (params) {//内容格式器
                	            if (params.indicator2) { // is edge
                	                return params.value.weight;
                	            } else {// is node
                	                return params.name
                	            }
                	        }
                	    },
                	    toolbox: {//工具箱，每个图表最多仅有一个工具箱
                	        show : true,
                	        feature : {//启用功能
                	            restore : {show: true},//还原，复位原始图表
                	            magicType: {show: true, type: ['force', 'chord']},//动态类型切换，支持直角系下的折线图、柱状图、堆积、平铺转换
                	            saveAsImage : {show: true}//保存图片
                	        }
                	    },
                	    legend: {//图例，每个图表最多仅有一个图例
                	        x: 'left',//水平安放位置，默认为全图居中，可选为：'center' | 'left' | 'right' | {number}（x坐标，单位px）
                	        data:['group1','group2', 'group3', 'group4']//图例内容数组
                	    },
                	    series : [//驱动图表生成的数据内容
                	        {
                	            type:'chord', //图表类型，必要参数！如为空或不支持类型，则该系列数据不被显示。
                	            sort : 'ascending', //数据排序， 可以取none, ascending, descending
                	            sortSub : 'descending',//数据排序（弦）， 可以取none, ascending, descending
                	            showScale : true,//是否显示刻度, ribbonType为true时有效
                	            showScaleText : true,//是否显示刻度文字, ribbonType为true时有效
                	            data : [  //数据
                	                {name : 'group1'},
                	                {name : 'group2'},
                	                {name : 'group3'},
                	                {name : 'group4'}
                	            ],
                	            itemStyle : {//图形样式
                	                normal : {
                	                    label : {
                	                        show : false
                	                    }
                	                }
                	            },
                	            matrix : [//和弦图的邻接矩阵, 和links二选一
                	                [11975,  5871, 8916, 2868],
                	                [ 1951, 10048, 2060, 6171],
                	                [ 8010, 16145, 8090, 8045],
                	                [ 1013,   990,  940, 6907]
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