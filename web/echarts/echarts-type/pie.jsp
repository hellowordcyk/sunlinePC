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
                'echarts/chart/pie',
                'echarts/chart/funnel' // 使用柱状图就加载bar模块，按需加载
            ],
            function (ec) {
                // 基于准备好的dom，初始化echarts图表
                var myChart = ec.init(document.getElementById('main')); 
                // 通过require获得echarts接口（或者命名空间）后可实例化图表
                
                var option = {
                		//图表选项（公共选项，组件选项，数据选项）//
                	    title : {
                	    	//标题（只能有一个）//
                	        text: '某站点用户访问来源',//主文本
                	        subtext: '纯属虚构',//副文本
                	        x:'center'//水平安放位置//
                	        
                	    },
                	    tooltip : {
                	    	//提示框
                	        trigger: 'item',//数据触发提示
                	        formatter: "{a} <br/>{b} : {c} ({d}%)" //内容格式 
                	    },
                	    legend: {
                	    	//图例
                	        orient : 'vertical',//布局方式
                	        x : 'left', //水平安放位置
                	        data:['直接访问','邮件营销','联盟广告','视频广告','搜索引擎']
                	    //图例内容数组
                	    },
                	    toolbox: {
                	    	//工具箱
                	        show : true,
                	        //是否显示，隐藏为false
                	        feature : {
                	        	//工具箱自定义功能
                	            mark : {show: true},
                	            //辅助线标志
                	            dataView : {show: true, readOnly: false},
                	            //数据视图 默认为只读，false时可以编辑
                	            magicType : {
                	            	//动态类型切换
                	                show: true, 
                	                type: ['pie', 'funnel'],
                	                //切换可选类型
                	                option: {
                	                    funnel: {
                	                        x: '25%',
                	                        width: '50%',
                	                        funnelAlign: 'left',
                	                        max: 1548
                	                    }
                	            //动态类型配置
                	                }
                	            },
                	            restore : {show: true},
                	            //还原选项
                	            saveAsImage : {show: true}
                	            //保存图片
                	        }
                	    },
                	    calculable : true,
                	    //是否启用拖拽重计算特性，默认关闭，（详见calculable，相关的还有 calculableColor， calculableHolderColor， nameConnector， valueConnector）
                	    series : [
                	              //驱动图表生成的数据内容
                	        {
                	            name:'访问来源',
                	            //系列名称
                	            type:'pie',
                	            //类型
                	            radius : '55%',
                	            //半径
                	            center: ['50%', '60%'],
                	            //圆心坐标
                	            data:[
                	                {value:335, name:'直接访问'},
                	                {value:310, name:'邮件营销'},
                	                {value:234, name:'联盟广告'},
                	                {value:135, name:'视频广告'},
                	                {value:1548, name:'搜索引擎'}
                	            ]//数值
                	        }
                	    ]
                	};
                	                    
                	                    
                	                    
        
                // 为echarts对象加载数据 
                myChart.setOption(option); 
            }
        );
    </script>
</body>