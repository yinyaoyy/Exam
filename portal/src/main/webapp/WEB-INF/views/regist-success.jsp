<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme() + "://"
+ request.getServerName() + ":" + request.getServerPort()
+ path + "/";
%>

<!DOCTYPE html>
<html>
	<head>
		<base href="<%=basePath%>">
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta charset="utf-8"><meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<title>锡林郭勒盟司法局-在线考试平台</title>
		
		<meta name="apple-mobile-web-app-capable" content="yes">
		<meta name="keywords" content="">
		<link rel="shortcut icon" href="<%=basePath%>resources/images/favicon.ico" />
		<link href="resources/bootstrap/css/bootstrap-huan.css" rel="stylesheet">
		<link href="resources/font-awesome/css/font-awesome.min.css" rel="stylesheet">
		<link href="resources/css/style.css" rel="stylesheet">
		
	</head>
	<body>
		<header>
			<div class="container">
				<div class="row">
					<div class="col-xs-5">
						<div class="logo">
							<h1><a href="#"><img alt="" src="resources/images/logo.png"></a></h1>
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
					<ul class="nav navbar-nav">
						<li>
							<a href="home"><i class="fa fa-home"></i>主页</a>
						</li>
						<li>
							<a href="student/practice-list"><i class="fa fa-edit"></i>试题练习</a>
						</li>
						<li>
							<a href="exam-list"><i class="fa  fa-paper-plane-o"></i>在线考试</a>
						</li>
						<li>
							<a href="training-list"><i class="fa fa-book"></i>培训资料</a>
						</li>
						<li>
							<a href="student/usercenter"><i class="fa fa-dashboard"></i>会员中心</a>
						</li>
						<li>
							<a href="student/setting"><i class="fa fa-cogs"></i>个人设置</a>
						</li>
					</ul>
				</nav>
			</div>
		</div>

		<!-- Navigation bar ends -->

		<!-- Slider starts -->

		<div>
			<!-- Slider (Flex Slider) -->

			<div class="container" style="height:500px;margin-top: 50px;">
				<h2>欢迎注册ExamStack</h2>
				<p class="big grey">
					您的账号为<span>${username}</span>
				</p>
				<a href="user-login-page" class="btn btn-success"><i class="fa fa-sign-in"></i> 登录系统</a>
				<hr>
				<div class="link-list">
					<h5>您可以选择访问其他页面</h5>
					<a href="#">主页</a><a href="#">试题练习</a><a href="#">练习历史</a><a href="#">联系我们</a><a href="#">FAQ</a>
				</div>
				<div class="row">

				</div>
			</div>
		</div>

		<footer>
			<div class="container">
				<div class="row">
					<div class="col-md-12">
						<div class="copy">
							<p>
								<a href="javascript:void(0);" target="_blank">内蒙古自治区锡林郭勒盟司法局  © </a> - 
								<a href="." target="_blank">主页</a> | 
								<a href="javascript:void(0);" target="_blank">关于我们</a> | 
								<a href="javascript:void(0);" target="_blank">FAQ</a> | 
								<a href="javascript:void(0);" target="_blank">联系我们</a> | 技术支持：内蒙古“智慧司法”云平台研发中心
							</p>
						</div>
					</div>
				</div>
			</div>
		</footer>

		<!-- Slider Ends -->

		<!-- Javascript files -->
		<!-- jQuery -->
		<script type="text/javascript" src="resources/js/jquery/jquery-1.9.0.min.js"></script>
		<!-- Bootstrap JS -->
		<script type="text/javascript" src="resources/bootstrap/js/bootstrap.min.js"></script>

	</body>
</html>
