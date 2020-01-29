<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%
	String clientID = null;
	if (session.getAttribute("clientID") != null) {
		clientID = (String) session.getAttribute("clientID");
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta
	content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"
	name="viewport">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet"
	href="bower_components/bootstrap/dist/css/bootstrap.min.css">
<!-- Font Awesome -->
<link rel="stylesheet"
	href="bower_components/font-awesome/css/font-awesome.min.css">
<!-- Ionicons -->
<link rel="stylesheet"
	href="bower_components/Ionicons/css/ionicons.min.css">
<!-- Theme style -->
<link rel="stylesheet" href="dist/css/AdminLTE.css">
<!-- AdminLTE Skins. Choose a skin from the css/skins
       folder instead of downloading all of them to reduce the load. -->
<link rel="stylesheet" href="dist/css/skins/_all-skins.min.css">
<!-- Morris chart -->
<link rel="stylesheet" href="bower_components/morris.js/morris.css">
<!-- jvectormap -->
<link rel="stylesheet"
	href="bower_components/jvectormap/jquery-jvectormap.css">
<!-- Date Picker -->
<link rel="stylesheet"
	href="bower_components/bootstrap-datepicker/dist/css/bootstrap-datepicker.min.css">
<!-- Daterange picker -->
<link rel="stylesheet"
	href="bower_components/bootstrap-daterangepicker/daterangepicker.css">
<!-- bootstrap wysihtml5 - text editor -->
<link rel="stylesheet"
	href="plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.min.css">
<link rel="stylesheet"
	href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,600,700,300italic,400italic,600italic">

<style>
.content-wrapper {
	background-color: white;
}
</style>
<title>Meerkat</title>
</head>

<body class="skin-blue sidebar-collapse">
	<header class="main-header">
		<a href="home.jsp" class="logo"> <!-- mini logo for sidebar mini 50x50 pixels -->
			<span class="logo-lg"><b>미어캣</b></span> <span class="logo-mini"><b>미어캣</b></span>
		</a>
		<nav class="navbar navbar-static-top">
			<div class="container-fluid">
				<div class="navbar-header">
					<button type="button" class="navbar-toggle collapsed"
						data-toggle="collapse" data-target="#navbar-collapse">
						<i class="fa fa-bars"></i>
					</button>
				</div>

				<div class="collapse navbar-collapse" id="navbar-collapse">
					<ul class="nav navbar-nav">
						<li><a href="frame.jsp">실시간 관리</a></li>
						<li><a href="frame2.jsp">미허용 프로세스 관리</a></li>
						<li><a href="frame.jsp">시용설명서</a></li>
					</ul>
					<%
						if (clientID == null) {
					%>
					<ul class="nav navbar-nav navbar-right">
						<li class="dropdown"><a href="#" class="dropdown-toggle"
							data-toggle="dropdown" role="button" aria-haspopup="true"
							aria-expanded="false">세션관리<span class="caret"></span></a>
							<ul class="dropdown-menu">
								<li><a href="login.jsp">로그인</a></li>
							</ul></li>
					</ul>
					<%
						} else {
					%>
					<ul class="nav navbar-nav navbar-right">
						<li class="dropdown"><a href="#" class="dropdown-toggle"
							data-toggle="dropdown" role="button" aria-haspopup="true"
							aria-expanded="false">세션관리<span class="caret"></span></a>
							<ul class="dropdown-menu">
								<li><a href="logoutAction.jsp">로그아웃</a></li>
							</ul></li>
					</ul>
					<%
						}
					%>
				</div>
			</div>
		</nav>
	</header>

	<div class="content-wrapper">
		<div class="row">
			<div id="carousel-example-generic" class="carousel slide"
				data-ride="carousel">
				<ol class="carousel-indicators">
					<li data-target="#carousel-example-generic" data-slide-to="0"
						class="active"></li>
					<li data-target="#carousel-example-generic" data-slide-to="1"
						class=""></li>
					<li data-target="#carousel-example-generic" data-slide-to="2"
						class=""></li>
				</ol>
				<div class="carousel-inner">
					<div class="item active">
						<img
							src="http://placehold.it/1920x400/39CCCC/ffffff&amp;text=I+Love+Meerkat"
							alt="First slide">

						<div class="carousel-caption">First Slide</div>
					</div>
					<div class="item">
						<img
							src="http://placehold.it/1920x400/045FB4/ffffff&amp;text=Group+PC+Management+System"
							alt="Second slide">

						<div class="carousel-caption">Second Slide</div>
					</div>
					<div class="item">
						<img
							src="http://placehold.it/1920x400/04B486/ffffff&amp;text=Don't+Stop+it"
							alt="Third slide">

						<div class="carousel-caption">Third Slide</div>
					</div>
				</div>
				<a class="left carousel-control" href="#carousel-example-generic"
					data-slide="prev"> <span class="fa fa-angle-left"></span>
				</a> <a class="right carousel-control" href="#carousel-example-generic"
					data-slide="next"> <span class="fa fa-angle-right"></span>
				</a>
			</div>
			<div class="container">
				<p class="lead">
					<br> 미어캣을 사용하여 허가되지 않은 소프트웨어 사용을 제한하여 관리하십시오.
					<!-- Bootstrap is the most popular HTML, CSS, and JS framework for developing responsive, mobile first projects on the web.-->
				</p>
				<p class="lead">
					<a
						href="https://github.com/mentalK94/meerkat1.0/archive/master.zip"
						class="btn bg-olive btn-flat margin">미어캣 v1.0 다운로드</a>
				</p>
				<p class="version">현재 v1.0</p>
			</div>
		</div>
		<div class="bs-docs-featurette">
			<div class="container">
				<h2 class="bs-docs-featurette-title">
					단체, 기관, 학교 등 그룹 PC를 관리하기위해 설계되었습니다
					<!--Designed for everyone, everywhere.-->
				</h2>
				<p class="lead">
					미어캣은 관리대상 PC의 미 허용 소프트웨어 사용을 제한하고 웹에서 관리합니다
					<!--Bootstrap makes front-end web development faster and easier. It's made for folks of all skill levels, devices of all shapes, and projects of all sizes.-->
				</p>

				<hr class="half-rule">

				<div class="row">
					<div class="col-sm-4">
						<img src="./images/home_realtime.png" alt="RealTimeManagement"
							width="130px" height="130px" class="img-responsive"><br>
						<h3>
							실시간 관리
							<!--RealTimeManagement-->
						</h3>
						<p>
							PC를 그룹으로 모아 허가되지 않은 소프트웨어 사용을 실시간으로 감시. 웹페이지에서 실시간으로 감시되는 소프트웨어
							사용 PC를 확인하십시오.
							<!--Bootstrap ships with vanilla CSS, but its source code utilizes the two most popular CSS preprocessors, Less and Sass. Quickly get started with precompiled CSS or build on the source.-->
						</p>
					</div>
					<div class="col-sm-4">
						<img src="./images/home_detect&block.png"
							alt="Detect and Block Modes" class="img-responsive"> <br>
						<h3>
							감지모드 & 차단모드
							<!--One framework, every device.-->
						</h3>
						<p>
							허가되지 않은 소프트웨어를 감지하여 웹에서 확인하는 감지모드를 사용하거나 사용 즉시 차단시키는 작업을 수행하는
							차단모드를 사용하십시오.
							<!--Bootstrap easily and efficiently scales your websites and applications with a single code base, from phones to tablets to desktops with CSS media queries.-->
						</p>
					</div>
					<div class="col-sm-4">
						<img src="./images/home_blacklist.png" alt="BlackList" width="150px"
							height="150px" class="img-responsive">
						<h3>
							블랙 리스트 관리
							<!--Full of features-->
						</h3>
						<p>
							그룹 PC에서 사용 허가하지 않을 소프트웨어 목록 추가/삭제를 통해 관리하십시오.
							<!--With Bootstrap, you get extensive and beautiful documentation for common HTML elements, dozens of custom HTML and CSS components, and awesome jQuery plugins.-->
						</p>
					</div>
				</div>
			</div>
		</div>
	</div>

	<footer class="main-footer">
		<div class="pull-right hidden-xs">
			<b>Version</b> 1.0.0
		</div>
		<strong>Copyright &copy; 2018 MeerKat. </strong> All rights reserved.
	</footer>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>