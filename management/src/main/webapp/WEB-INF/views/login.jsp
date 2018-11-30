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
		<title>锡林郭勒盟司法局-在线考试管理平台</title>
		
		<meta name="apple-mobile-web-app-capable" content="yes">
		<meta name="keywords" content="">
		<link rel="shortcut icon" href="<%=basePath%>resources/images/favicon.ico" />
		<link href="resources/bootstrap/css/bootstrap-huan.css" rel="stylesheet">
		<link href="resources/font-awesome/css/font-awesome.min.css" rel="stylesheet">
		<link href="resources/css/style.css" rel="stylesheet">
		<style type="text/css">
			.form-group {
				margin-bottom: 5px;
				height: 59px;
			}
			.lrform{
				text-align:center;
			}
			.form-control{
				height:40px;
			}
			.form-horizontal{
				margin-top:20px;
			}
			.login{
				background-color:#428bca;
				color:#fff;
				width:100%;
				height:40px;
			}
		</style>
	</head>
	<body>
		<header>
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
							<!-- 	<a class="btn btn-primary" href="user-register">用户注册</a>
								<a class="btn btn-success" href="user-login-page">登录</a> -->
							</c:otherwise>
						</c:choose>
					</div>
				</div>
			</div>
		</header>
		<!-- Navigation bar starts -->
		<!--
		<div class="navbar bs-docs-nav" role="banner">
			<div class="container">
				<nav class="collapse navbar-collapse bs-navbar-collapse" role="navigation" >
				</nav>
			</div>
		</div>
		-->
		<!-- Navigation bar ends -->

		<!--<div class="content" style="margin-bottom: 100px;background: rgb(77,191,217);margin-top:0;"> -->
 		<div class="content" style="margin-bottom: 100px;background-image: rgb(77,191,217);margin-top:0;">
			<div class="container">
				<div class="row" id="admin-login-bg">
					<div class="col-md-7" id="admin-login-bg-bak">
						<p>
							
						</p>
					</div>
					<div class="col-md-4">
						<div class="lrform">
							<h5>登录在线考试管理平台</h5>
							<div class="form">
								<!-- Login form (not working)-->
								<form class="form-horizontal" action="j_spring_security_check" method="post">
									<!-- Username -->
									<div class="form-group">
										<!--<label class="control-label col-md-3" for="username">用户名</label> -->
										<div class="col-md-12">
											<input type="text" class="form-control" name="j_username" placeholder="用户名">
										</div>
									</div>
									<!-- Password -->
									<div class="form-group">
										<!-- <label class="control-label col-md-3" for="password">密码</label> -->
										<div class="col-md-12">
											<input type="password" class="form-control" name="j_password" placeholder="密码">
										</div>
									</div>
									<!-- Buttons -->
									<div class="form-group">
										<!-- Buttons -->
										<div class="col-md-12">
											<button type="submit" class="btn btn-default login">
												登录
											</button>
											<!-- 
											<button type="reset" class="btn btn-default">
												取消
											</button>
											 -->
											<span class="form-message">${result}</span>
										</div>
									</div>
								</form>
								<i class="fa fa-info"></i> 
								通过教师/管理员账号登陆系统
							</div>
						</div>

					</div>
					<div class="col-md-1"></div>
				</div>

			</div>

		</div>
		<footer>
			<%@ include file="footer.jsp" %>
		</footer>

		<!-- Slider Ends -->

		<!-- Javascript files -->
		<!-- jQuery -->
		<script type="text/javascript"
		src="resources/js/jquery/jquery-1.9.0.min.js"></script>
		<!-- Bootstrap JS -->
		<script type="text/javascript"
		src="resources/bootstrap/js/bootstrap.min.js"></script>

	</body>
</html>