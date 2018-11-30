<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%-- <%@taglib uri="spring.tld" prefix="spring"%> --%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
String servletPath = (String)request.getAttribute("javax.servlet.forward.servlet_path");
String[] list = servletPath.split("\\/");
request.setAttribute("role",list[1]);
request.setAttribute("topMenuId",list[2]);
request.setAttribute("leftMenuId",list[3]);
%>

<!DOCTYPE html>
<html>
    <head>
		<base href="<%=basePath%>">
		<!-- Always force latest IE rendering engine (even in intranet) & Chrome Frame
		Remove this if you use the .htaccess -->
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta charset="utf-8"><meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<title>锡林郭勒盟司法局-在线考试管理平台</title>
		<meta name="viewport"
		content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
		<meta name="apple-mobile-web-app-capable" content="yes">
		<meta name="keywords" content="">
		<link rel="shortcut icon" href="<%=basePath%>resources/images/favicon.ico" />
		<link href="resources/bootstrap/css/bootstrap-huan.css"
		rel="stylesheet">
		<link href="resources/font-awesome/css/font-awesome.min.css"
		rel="stylesheet">
		<link href="resources/css/style.css" rel="stylesheet">
		<!-- jQuery -->
		<script type="text/javascript" src="resources/js/jquery/jquery-1.9.0.min.js"></script>
		<script type="text/javascript" src="resources/js/all.js"></script>
		<!-- Bootstrap JS -->
		<script type="text/javascript" src="resources/bootstrap/js/bootstrap.min.js"></script>
		<script type="text/javascript" src="resources/js/exam-user-list.js"></script>
		<script type="text/javascript" src="resources/echarts/echarts.js"></script>
		
	</head>

	<body>
		<header>
		<input id="examId" value="${examId}" type="hidden"/>
			<span style="display:none;" id="rule-role-val"><%=list[1]%></span>
			<div class="container">
				<div class="row">
					<div class="col-xs-5">
						<div class="logo">
							<a href="#"><img src="resources/images/logo.png" /></a>
						</div>
					</div>
					<div class="col-xs-7" id="login-info">
						<c:choose>
							<c:when test="${not empty sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal.trueName}">
								<div id="login-info-user">
									
									<a href="user-detail/${sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal.trueName}" id="system-info-account" target="_blank">${sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal.trueName}</a>
									<span>|</span>
									<a href="j_spring_security_logout"><i class="fa fa-sign-out"></i> 退出</a>
								</div>
							</c:when>
							<c:otherwise>
								<a class="btn btn-primary" href="user-register">用户注册</a>
								<a class="btn btn-success" href="user-login-page">登录</a>
							</c:otherwise>
						</c:choose>
					</div>
				</div>
			</div>
		</header>
		<!-- Navigation bar starts -->
		<div class="navbar bs-docs-nav" role="banner">
			<div class="container">
				<nav class="collapse navbar-collapse bs-navbar-collapse" role="navigation">
					<c:import url="/common-page/top-menu?topMenuId=${topMenuId}&leftMenuId=${leftMenuId}" charEncoding="UTF-8" />
				</nav>
			</div>
		</div>
		<div>
			<div class="container" style="min-height:500px;">
				<div class="row">
					<div class="col-xs-2" id="left-menu">
						<c:import url="/common-page/left-menu?topMenuId=${topMenuId}&leftMenuId=${leftMenuId}" charEncoding="UTF-8" />
					</div>
					<div class="col-xs-10" id="right-content">
						<div class="page-header">
							<h1><i class="fa fa-list-ul"></i> 各旗县考试参与率统计 </h1>
						</div>
						
						 <!-- 为ECharts准备一个具备大小（宽高）的Dom -->
    <div id="main" style="width: 100%;height:600px;"></div>
    <script type="text/javascript">
        // 基于准备好的dom，初始化echarts实例
      $(function(){
    	  a();
      })
		function a() {
			 var myChart = echarts.init(document.getElementById('main'));
		        var examId = document.getElementById("examId").value;
		    	$.ajax({
					type:"get",
					url:"<%=list[1]%>/exam/canyu",
					data:{"examId":examId},
					success:function(data){
						var rs = new Array();
			    		var ksrs = new Array();
			    		var cyl = new Array();
			    		var name = new Array();
			    		var zrs = 0.00;     //锡林郭勒盟总人数
			    		var kszrs = 0.00;   //参与考试的人数。
			    		for(var i=0;i<data.length;i++){
			    			rs[i] = data[i].groupTotal*1;
			    			zrs+=data[i].groupTotal*1;
			    			ksrs[i] = data[i].examPerson*1;
			    			kszrs+=data[i].examPerson*1;
			    			var a = data[i].canYuLv.split("%");
			    			cyl[i] = parseFloat(a[0]);
			    			name[i] = data[i].name;
			    		}
			    		var zcyl = kszrs/zrs;
			    		var ss = Number(zcyl*100).toFixed(2);//所有的参与率
			        	// 指定图表的配置项和数据
			            option = {
			    				title:{
			    					text:'总人数：'+zrs+'人；'+'参与考试人数：'+kszrs+'人；'+'参与率：'+ss+'%',
			    					 left: '3%',
									 top:20
			    				},
			            	    tooltip : {
			            	        trigger: 'axis',
			            	        axisPointer : {            // 坐标轴指示器，坐标轴触发有效
			            	            type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
			            	        }
			            	    },
			            	    legend: {
							        data: ['参与数量','注册数量','参与率'],
								    align: 'right',
								    right: '7%',
								    top:20
							    },
			            	    grid: {
			            	    	top : '16%',		    	
			        		        left: '2%',
			        		        right: '4%',
			        		        bottom: '20%',
			            	        containLabel: true,
			            	    },
			            	    xAxis : [
			            	        {
			            	            type : 'category',
			            	            data : name,
			            	            axisTick: {
			            			        alignWithLabel: true
			            			    },
			            			    axisLabel:{
			            			    	interval: -10,
			                                rotate:-20
			            			    }
			            	        }
			            	    ],
			            	    yAxis : [
			            	        {
			            	            type : 'value',
			            	            name: '人数',
			            	            boundaryGap: [0, 0.2],
			            	        },
			            	        {
			            	            type: 'value',
			            	            name: '参与率',
			            	            min: 0,
			            	            max: 100,
			            	            axisLabel: {
			            	                formatter: '{value}%'
			            	            }
			            	        }
			            	    ],
			            	    
			            	    series : [
			            	        {
			            	            name:'参与数量',
			            	            type:'bar',
			            	            data:ksrs,
			            	            itemStyle:{
						                    normal:{
						                    	color: 'green'
						                    }//end普通颜色设置
						                }
			            	        },
			            	        {
			            	            name:'注册数量',
			            	            type:'bar',
			            	            data:rs,
			            	            itemStyle:{
						                    normal:{
						                    	color: '#EFE42A'
						                    }//end普通颜色设置
						                }
			            	        },
			            	        {
			            	            name:'参与率',
			            	            type:'line',
			            	            yAxisIndex:1,
			            	            data:cyl,
			            	            label: {
					                        normal: {
					                            show: true,
					                            position: 'top'
					                        }
					                    },
					                    itemStyle:{
						                    normal:{
						                    	color: '#C33531'
						                    }//end普通颜色设置
						                }
			            	        }
			            	    ]
			            	};
			            
			            // 使用刚指定的配置项和数据显示图表。
			            myChart.setOption(option);

			        }
						
					
				})
		<%--         $.get("<%=list[1]%>/exam/canyu",{"examId":examId},
		        		
		        		function(data){
		        	var rs = new Array();
		    		var ksrs = new Array();
		    		var cyl = new Array();
		    		var name = new Array();
		    		for(var i=0;i<data.length;i++){
		    			rs[i] = data[i].groupTotal;
		    			ksrs[i] = data[i].examPerson;
		    			cyl[i] = data[i].canYuLv;
		    			name[i] = data[i].name;
		    		}
		        	// 指定图表的配置项和数据
		            myChart.option = {
		            	    tooltip : {
		            	        trigger: 'axis',
		            	        axisPointer : {            // 坐标轴指示器，坐标轴触发有效
		            	            type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
		            	        }
		            	    },
		            	    legend: {
		            	        data:name
		            	    },
		            	    grid: {
		            	        left: '3%',
		            	        right: '4%',
		            	        bottom: '3%',
		            	        containLabel: true
		            	    },
		            	    xAxis : [
		            	        {
		            	            type : 'category',
		            	            data : name
		            	        }
		            	    ],
		            	    yAxis : [
		            	        {
		            	            type : 'value'
		            	        }
		            	    ],
		            	    series : [
		            	        {
		            	            name:'参与数量',
		            	            type:'bar',
		            	            data:ksrs
		            	        },
		            	        {
		            	            name:'注册数量',
		            	            type:'bar',
		            	            stack: '广告',
		            	            data:rs
		            	        },
		            	        {
		            	            name:'参与率',
		            	            type:'bar',
		            	            stack: '广告',
		            	            data:cyl
		            	        }
		            	    ]
		            	};
		            
		            // 使用刚指定的配置项和数据显示图表。
		            myChart.setOption(option);

		        }) --%>
		       
		}

		</script>
          
						
						
						
						
					</div>
				</div>
			</div>
		</div>
	
		<footer>
			<%@ include file="footer.jsp" %>
		</footer>
    
	</body>
	
</html>