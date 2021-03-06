<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
String servletPath = (String)request.getAttribute("javax.servlet.forward.servlet_path");
String[] list = servletPath.split("\\/");
request.setAttribute("role",list[1]);
request.setAttribute("topMenuId",list[2]);
request.setAttribute("leftMenuId",list[3]);
%>

<!DOCTYPE HTML>
<html>
    <head>
    	<base href="<%=basePath%>">
    	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta charset="utf-8"><meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<title>锡林郭勒盟司法局-在线考试管理平台</title>
		<meta name="viewport"
		content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
		<meta name="apple-mobile-web-app-capable" content="yes">
		<meta name="keywords" content="">
		<link rel="shortcut icon" href="<%=basePath%>resources/images/favicon.ico" />
		<link href="<%=basePath%>resources/bootstrap/css/bootstrap-huan.css"
		rel="stylesheet">
		<link href="<%=basePath%>resources/font-awesome/css/font-awesome.min.css"
		rel="stylesheet">
		<link href="<%=basePath%>resources/css/style.css" rel="stylesheet">
    	<script type="text/javascript" src="<%=basePath%>resources/echarts/echarts.js"></script>
    	<style>
    		table{
    			width:95%;
    			border:1px solid;
    			margin:auto;
    		}
    		
    		tr{
    			border:1px solid;
    		}
    		
    		th{
    			border:1px solid;
    			text-align:center;
    			background-color:#B8B8B8;
    		}
    		
    		td{
    			border:1px solid;
    			text-align:center;
    		}
    		
    		
    	</style>
    </head>
    <body onload="getTableData()">
    	<header>
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
		<div class="navbar bs-docs-nav" role="banner">
			<div class="container">
				<nav class="collapse navbar-collapse bs-navbar-collapse" role="navigation">
					<c:import url="/common-page/top-menu?topMenuId=${topMenuId}&leftMenuId=${leftMenuId}" charEncoding="UTF-8" />
				</nav>
			</div>
		</div>
		<div>
			<!-- Slider (Flex Slider) -->
			<div class="container" style="min-height:500px;">
				<div class="row">
					<div class="col-xs-2" id="left-menu">
						<c:import url="/common-page/left-menu?topMenuId=${topMenuId}&leftMenuId=${leftMenuId}" charEncoding="UTF-8" />
					</div>
					<div class="col-xs-10" id="right-content">
						<div class="page-header">
							<h1><i class="fa fa-list-ul"></i> 高分榜 </h1>							
						</div>
				    	<div id="mychart" style="width:100%;height:500px;"></div>
				    	<table>
				    		<thead>
				    			<tr>
				    				<th>序号</th>
				    				<th>旗县</th>
				    				<th>姓名</th>
				    				<th>得分</th>
				    				<th>交卷时间</th>
				    				<th>身份证号</th>
				    				<th>电话</th>
				    			</tr>
				    		<thead>
				    		<tbody>
				    			<c:forEach items="${dlist}" var="item" varStatus="status">
				    				<tr>
					    				<td>${status.index+1}</td>
					    				<td>${item.depName}</td>
					    				<td>${item.trueName}</td>
					    				<td>${item.pointGet}</td>
					    				<td><fmt:formatDate value="${item.submitTime}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
					    				<td>${item.nationalId}</td>
					    				<td>${item.phoneNum}</td>
					    			</tr>
				    			</c:forEach>
				    		</tbody>
						</table>
				    	<script type="text/javascript">
				    		var alist = ${alist};
				    		var blist = ${blist};
				    		var clist = ${clist};
				    		var flist = ${flist};
				    	</script>
				    	<script type="text/javascript">
							// 基于准备好的dom，初始化echarts实例
							var myChart = echarts.init(document.getElementById('mychart'));
							var option = {
									title: {
										text:'总人数：'+flist[0]+'人 ；'+'满分人数：'+flist[1]+'人 ；'+'90-99分人数：'+flist[2]+'人',
										left: '3%',
										 top:20
									},
									tooltip: {
								        trigger: 'axis',
								        axisPointer: {
								            type: 'shadow'
								        },
								    },
								    legend: {
								        data: ['满分','90分以上'],
									    align: 'right',
									    right: 30,
									    top:20
								    },
								    grid: {
								    	top : '14%',		    	
				        		        left: '2%',
				        		        right: '4%',
				        		        bottom: '20%',
								        containLabel: true
								    },
								    xAxis: {
								        type: 'category',
								        data: alist,
								        axisLabel:{  
					                        interval: 0 ,
					                        rotate:-40 
					                    }
								    },
								    yAxis: {
								        type: 'value',
								        boundaryGap: [0, 0.2]
								    },
								    series: [
								        {
								        	name:'满分',
								            type:'bar',
											data : blist,
											itemStyle:{
							                    normal:{
							                    	color: '#64BD3D'
							                    }//end普通颜色设置
							                }
								        },
								        {
								        	name:'90分以上',
								            type:'bar',
											data : clist,
											itemStyle:{
							                    normal:{
							                    	color: '#EFE42A'
							                    }//end普通颜色设置
							                }
								        }
								    ]
								};
							myChart.setOption(option);
						</script>
					</div>
				</div>
			</div>
		</div>
		<br>
		<!-- 关联用户modal -->
		<div class="modal fade" id="link-user-modal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"
							aria-hidden="true">&times;</button>
						<h6 class="modal-title" id="myModalLabel">关联用户</h6>
					</div>
					<div class="modal-body">
						<form id="link-user-form">
							<div class="form-line form-user-id" style="display: block;">
								<span class="form-label"><span class="warning-label"></span>用户ID：</span>
								<input type="text" class="df-input-narrow" id="name-add-link">
								<span class="form-message"></span> <br>
							</div>
						</form>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">
							关闭窗口</button>
						<button id="link-user-btn" type="button" class="btn btn-primary">
							确定添加</button>
					</div>
				</div>
			</div>
		</div>
		<!-- 管理用户组modal -->
		<div class="modal fade" id="link-user-group-modal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"
							aria-hidden="true">&times;</button>
						<h6 class="modal-title" id="myModalLabel">关联用户组</h6>
					</div>
					<div class="modal-body">
						<form id="link-user-group-form">
							<div class="form-line form-user-id" style="display: block;">
								<fieldset>
									<c:forEach items="${groupList }" var="item">
										<label><input type="checkbox" value="${item.groupId }"/></label>
										<label>${item.groupName }</label>
										<br>
									</c:forEach>
								</fieldset>
							</div>
						</form>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">
							关闭窗口</button>
						<button id="link-user-group-btn" type="button" class="btn btn-primary">
							确定添加</button>
					</div>
				</div>
			</div>
		</div>
		
		<footer>
			<%@ include file="footer.jsp" %>
		</footer>
		<!-- Slider Ends -->

		<!-- Javascript files -->
		<!-- jQuery -->
		<script type="text/javascript" src="resources/js/jquery/jquery-1.9.0.min.js"></script>
		<script type="text/javascript" src="resources/js/all.js"></script>
		<!-- Bootstrap JS -->
		<script type="text/javascript" src="resources/bootstrap/js/bootstrap.min.js"></script>
		<script type="text/javascript" src="resources/js/exam-user-list.js"></script>
		<script type="text/javascript">
			$(function(){
				$("#link-user-r-btn").click(function(){
				//	$("#link-user-btn").data("id",$(this).data("id"));
					$("#link-user-modal").modal({
						backdrop : true,
						keyboard : true
					});
				});
				$("#link-user-group-r-btn").click(function(){
				//	$("#link-user-btn").data("id",$(this).data("id"));
					$("#link-user-group-modal").modal({
						backdrop : true,
						keyboard : true
					});
				});
			});
		</script>
	</body>
</html>