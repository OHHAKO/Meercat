<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="dao.MessageDAO"%>
<%@ page import="mqttDataIntoWeb.*"%>
<%@ page import="java.util.ArrayList"%>
<%
	String clientID = null;
	if (session.getAttribute("clientID") != null) {
		clientID = (String) session.getAttribute("clientID");
	}
	if (clientID == null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("location.href = 'login.jsp';");
		script.println("</script>");
	} else {
%>
<!DOCTYPE html>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta
	content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"
	name="viewport">

<link rel="stylesheet"
	href="./bower_components/bootstrap/dist/css/bootstrap.min.css">
<!-- Font Awesome -->
<link rel="stylesheet"
	href="./bower_components/font-awesome/css/font-awesome.min.css">
<!-- Ionicons -->
<link rel="stylesheet"
	href="./bower_components/Ionicons/css/ionicons.min.css">
<!-- Theme style -->
<link rel="stylesheet" href="./dist/css/AdminLTE.min.css">
<!-- AdminLTE Skins. Choose a skin from the css/skins
       folder instead of downloading all of them to reduce the load. -->
<link rel="stylesheet" href="./dist/css/skins/_all-skins.min.css">
<link rel="stylesheet" href="./plugins/bootstrap-slider/slider.css">
<link rel="stylesheet"
	href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,600,700,300italic,400italic,600italic">
<script src="controlSetting_JavascriptResource.js"></script>
<script>
	var controlClient;
	var controlClientId="<%=clientID%>";
	
	var controlTopicFloor;
	var controlTopicGroup;
	var controlTopicPC="All";

	var selectGroup;
	var selectGroupValue;
	var selectFloor;
	var selectFloorValue;
	var selectPC;
	var selectPCValue;
	
	blackClient = new Paho.MQTT.Client("113.198.84.66", Number(9001), controlClientId+"control"); //로그인한 id로 client 생성
	
	blackClient.onMessageArrived = onMessageArrived3;
	blackClient.onConnectionLost = onConnectionLost3;
	blackClient.connect({
		onSuccess : onConnect3
	});
	
	function onConnect3() {
		console.log("onConnect-control");
	}
	
	function onConnectionLost3(responseObject) {
		if (responseObject.errorCode != 0)
			console.log("onConnectionLost-control: "
					+ responseObject.errorMessage);
		alert(controlClientId.clientId + "\n" + responseObject.errorCode);
	}
	
	function onMessageArrived3(message) {
		
	}
	
	function setControlTopic() {
		selectFloor = document.getElementById("selectFloor"); //selectFloor라는 id가진애 가져옴
		selectFloorValue = selectFloor.options[selectFloor.selectedIndex].value; //그 selectFloor의 선택된 인덱스의 value를 가져옴
		
		selectGroup = document.getElementById("selectGroup"); //selectGroup이라는 id가진애 가져옴
		selectGroupValue = selectGroup.options[selectGroup.selectedIndex].value; //그 selectGroup의 선택된 인덱스의 value를 가져옴

		selectPC = document.getElementById("selectPC");
		selectPCValue = selectPC.options[selectPC.selectedIndex].value;

		controlTopicFloor = selectFloorValue;
		controlTopicGroup = selectGroupValue;
		controlTopicPC = selectPCValue;
		
	}
</script>

<title>미어캣</title>

<style>
.example-modal .modal {
	position: relative;
	top: auto;
	bottom: auto;
	right: auto;
	left: auto;
	display: block;
	z-index: 1;
}

.example-modal .modal {
	background: transparent !important;
}
</style>
</head>

<body class="skin-blue sidebar-collapse">
	<!-- <header class="main-header">
		<a href="home.jsp" class="logo"> <span class="logo-lg"><b>미어캣</b></span>
			<span class="logo-mini"><b>미어캣</b></span>
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
						<li class="active"><a href="controlSetting.jsp">관리자 설정</a></li>
					</ul>
					<ul class="nav navbar-nav navbar-right">
						<li class="dropdown"><a href="#" class="dropdown-toggle"
							data-toggle="dropdown" role="button" aria-haspopup="true"
							aria-expanded="false">세션관리<span class="caret"></span></a>
							<ul class="dropdown-menu">
								<li><a href="logoutAction.jsp">로그아웃</a></li>
							</ul></li>
					</ul>
				</div>
			</div>
		</nav>
	</header> -->

	<div class="content-wrapper">

		<section class="content-header">
			<h1>관리자 설정</h1>
		</section>

		<section class="content">
			<div class="row">
				<div class="col-md-1"></div>
				<div class="col-md-9">
					<div class="box box-default">
						<div class="box-header with-border">
							<h3 class="box-title">감지모드 선택</h3>

							<div class="box-tools pull-right">
								<button type="button" class="btn btn-box-tool"
									data-widget="collapse">
									<i class="fa fa-minus"></i>
								</button>
							</div>
							<!-- /.box-tools -->
						</div>
						<!-- /.box-header -->
						<div class="box-body">
							<div class="row">
								<div class="col-md-4">
									<div class="form-group">
										<label>Floor</label> 
										<select id="selectFloor" class="form-control selectFloor"
											style="width: 100%;"
											ng-options="t.id as t.name for t in tags" ng-model="t_id">
											<option>All Floor</option>
										</select>
									</div>
								</div>
								<div class="col-md-4">
									<div class="form-group">
										<label>Classroom</label> <select
											id="selectGroup" class="form-control selectGroup" style="width: 100%;"
											ng-options="t.id as t.name for t in tags" ng-model="t_id">
											<option>All Class</option>
										</select>
									</div>
								</div>
								<div class="col-md-4">
									<div class="form-group">
										<label>PC Number</label> <select
											id="selectPC" class="form-control selectPC" style="width: 100%;"
											ng-options="t.id as t.name for t in tags" ng-model="t_id">
											<option selected="selected">All</option>
										</select>
									</div>
								</div>
								<div class="col-md-2">
									<div class="form-group">
										<div class="radio">
											<label> <input type="radio" name="detectOptionRadios"
												id="detectOptionRadios1" value="manualKill" checked>수동 종료모드
											</label>
										</div>
									</div>
								</div>
								<div class="col-md-2">
									<div class="form-group">
										<div class="radio">
											<label> <input type="radio" name="detectOptionRadios"
												id="detectOptionRadios2" value="autoKill">자동 종료모드
											</label>
										</div>
									</div>
								</div>
							</div>
						</div>
						<!-- /.box-body -->
						<div class="box-footer">
							<div class="form-group">
								 <a	href="javascript:void(0)"
									class="btn btn-sm btn-primary btn pull-right" onclick="detectModeClick();">변경사항 적용</a>
							</div>
						</div>
					</div>

				</div>
			</div>
			<!-- /.box -->
			<div class="row">
				<div class="col-md-1"></div>
				<div class="col-md-9">
					<div class="box box-default collapsed-box">
						<div class="box-header with-border">
							<h3 class="box-title">차단 기능</h3>

							<div class="box-tools pull-right">
								<button type="button" class="btn btn-box-tool"
									data-widget="collapse">
									<i class="fa fa-plus"></i>
								</button>
							</div>
							<!-- /.box-tools -->
						</div>
						<!-- /.box-header -->
						<div class="box-body">
							<div class="row">
								<div class="col-md-4">
									<div class="form-group">
										<label>Floor</label> <select class="form-control selectFloor"
											style="width: 100%;"
											ng-options="t.id as t.name for t in tags" ng-model="t_id">
											<option>All Floor</option>
										</select>
									</div>
								</div>
								<div class="col-md-4">
									<div class="form-group">
										<label>Classroom</label> <select
											class="form-control selectGroup" style="width: 100%;"
											ng-options="t.id as t.name for t in tags" ng-model="t_id">
											<option>All Class</option>
										</select>
									</div>
								</div>
								<div class="col-md-4">
									<div class="form-group">
										<label>PC Number</label> <select
											class="form-control selectPC" style="width: 100%;"
											ng-options="t.id as t.name for t in tags" ng-model="t_id">
											<option>All Group</option>
										</select>
									</div>
								</div>
								<div class="col-md-2">
									<div class="form-group">
										<div class="radio">
											<label> <input type="radio" name="blockOptionRadios"
												id="blockOptionRadios1" value="noneBlockMode" checked>차단 헤제
											</label>
										</div>
									</div>
								</div>
								<div class="col-md-2">
									<div class="form-group">
										<div class="radio">
											<label> <input type="radio" name="blockOptionRadios"
												id="blockOptionRadios2" value="BlockMode">차단 모드
											</label>
										</div>
									</div>
								</div>
							</div>
						</div>
						<!-- /.box-body -->
						<div class="box-footer">
							<div class="form-group">
								 <a	href="javascript:void(0)" class="btn btn-sm btn-primary btn pull-right" onclick="blockModeClick();">변경사항 적용</a>
							</div>
						</div>
						<!-- /.box-body -->
					</div>
					<!-- /.box -->
				</div>
			</div>
			<div class="row">
				<div class="col-md-1"></div>
				<div class="col-md-9">
					<div class="box box-default collapsed-box">
						<div class="box-header with-border">
							<h3 class="box-title">볼륨 기능</h3>

							<div class="box-tools pull-right">
								<button type="button" class="btn btn-box-tool"
									data-widget="collapse">
									<i class="fa fa-plus"></i>
								</button>
							</div>
							<!-- /.box-tools -->
						</div>
						<!-- /.box-header -->
						<div class="box-body">
							<div class="col-sm-6">
								<div class="slider slider-horizontal" id="red">
									<div class="slider-track">
										<div class="slider-track-low" style="left: 0px; width: 0%;"></div>
										<div class="slider-selection" style="left: 32.5%; width: 50%;"></div>
										<div class="slider-track-high" style="right: 0px; width: 25%;"></div>
										<div class="slider-handle min-slider-handle round"
											role="slider" aria-valuemin="0" aria-valuemax="100"
											aria-valuenow="30" tabindex="0" style="left: 30%;"></div>
									</div>
									<div class="tooltip tooltip-min top" role="presentation"
										style="left: 20%; margin-left: 0px; display: none;">
										<div class="tooltip-arrow"></div>
										<div class="tooltip-inner">100</div>
									</div>
								</div>
							</div>
							<div class="col-sm-3">
								<div class="checkbox">
									<label><input type="checkbox"> 음소거 </label>
								</div>
							</div>
						</div>
						<div class="box-footer">
							<div class="form-group">
								<a href="javascript:void(0)"
									class="btn btn-sm btn-default btn pull-right">취소</a> <a
									href="javascript:void(0)"
									class="btn btn-sm btn-primary btn pull-right">변경사항 적용</a>
							</div>
						</div>
						<!-- /.box-body -->
					</div>
					<!-- /.box -->
				</div>
			</div>

			<div class="row">
				<div class="col-md-1"></div>
				<div class="col-md-9">
					<div class="box box-default collapsed-box">
						<div class="box-header with-border">
							<h3 class="box-title">관리자 암호 설정</h3>

							<div class="box-tools pull-right">
								<button type="button" class="btn btn-box-tool"
									data-widget="collapse">
									<i class="fa fa-plus"></i>
								</button>
							</div>
							<!-- /.box-tools -->
						</div>
						<!-- /.box-header -->
						<div class="box-body">
							<div class="col-md-3">
								<div class="form-group">
									<label for="currentPassword">현재 비밀번호</label> <input
										type="password" class="form-control" id="currentPassword"
										placeholder="현재 비밀번호 입력">
								</div>

								<div class="form-group">
									<label for="changePassword">새로운 비밀번호</label> <input
										type="password" class="form-control" id="changePassword"
										placeholder="새로운 비밀번호 입력" onchange="isSame()">

								</div>
								<div class="form-group">
									<label for="confirmPassword">비밀번호 확인</label> <input
										type="password" class="form-control" id="confirmPassword"
										placeholder="비밀번호 확인 입력" onchange="isSame()">
								</div><div class="form-group">
									<span id="same"></span>
								</div>								
							</div>							
						</div>
						<!-- /.box-body -->
						<div class="box-footer">
							<div class="form-group">
								<a href="javascript:void(0)"
									class="btn btn-sm btn-default btn pull-right">취소</a> <a
									href="javascript:void(0)"
									class="btn btn-sm btn-primary btn pull-right">변경사항 적용</a>
							</div>
						</div>
					</div>
					<!-- /.box -->
				</div>
			</div>
		</section>
	</div>

	<!-- <footer class="main-footer">
		<div class="pull-right hidden-xs">
			<b>Version</b> 1.0.0
		</div>
		<strong>Copyright &copy; 2018 SolBangUl. </strong> All rights
		reserved.
	</footer> -->

	<script src="./bower_components/jquery/dist/jquery.min.js"></script>
	<!-- Bootstrap 3.3.7 -->
	<script src="./bower_components/bootstrap/dist/js/bootstrap.min.js"></script>
	<!-- Slimscroll -->
	<script
		src="./bower_components/jquery-slimscroll/jquery.slimscroll.min.js"></script>
	<!-- FastClick -->
	<script src="./bower_components/fastclick/lib/fastclick.js"></script>
	<script src="./plugins/bootstrap-slider/bootstrap-slider.js"></script>
	<!-- AdminLTE App -->
	<script src="./dist/js/adminlte.min.js"></script>
	<!-- AdminLTE for demo purposes -->
	<script src="./dist/js/demo.js"></script>
	
	<script>
	window.onload = function() {
		var request;
		if (window.XMLHttpRequest) {
			request = new XMLHttpRequest();
		} else {
			request = new ActiveXObject("Microsoft.XMLHTTP");
		}

		request.open("GET", "OfficeBuildingInfo.xml");
		request.send();
		request.onreadystatechange = function() {
			if (request.readyState == 4 && request.status == 200) {
				xmlData = request.responseXML;
				getSelectElement(xmlData); //select box에 강의실 option 추가

			}
		}
	
	
	</script>
	<script>
		$(function() {
			/* BOOTSTRAP SLIDER */
			$('.slider').slider()
		})
	</script>
	<script>
		function isSame() {

			if(changePassword.length < 6 || changePassword.length > 11) { // 6글자 이상 10글자 이하
				window.alert("관리자 암호는 6글자 이상, 10글자 이하만 사용 가능합니다.");
				document.getElementById('changePassword').value = document.getElementById('confirmPassword').value='';
				document.getElementById('same').innerHTML='';
			}
			if(document.getElementById('changePassword').value!='' && document.getElementById('confirmPassword').value!='') {
				if(document.getElementById('changePassword').value == document.getElementById('confirmPassword').value) {
					document.getElementById('same').innerHTML='비밀번호가 일치합니다.';
					document.getElementById('same').style.color='blue';
				} else {
					document.getElementById('same').innerHTML='비밀번호가 일치하지 않습니다.';
					document.getElementById('same').style.color='red';
				}
			}
		}
	</script>
	<script type="text/javascript">
		function detectModeClick() {
			setControlTopic();
			var killModeSelect = document.getElementsByName('detectOptionRadios');
			if(killModeSelect[0].checked == true) {
				
				if(controlTopicGroup=="102" && controlTopicPC=="All"){
					for(var i=0;i<42;i++){
						message = new Paho.MQTT.Message(killModeSelect[0].value);
						message.destinationName = "hansung/controlSettings/" + controlTopicFloor
								+ "/" + controlTopicGroup + "/"+controlTopicPC;
						console.log(message.destinationName);

						blackClient.send(message);
						console.log("publish success : " + message);
					}
				} else{
					message = new Paho.MQTT.Message(killModeSelect[0].value);
					message.destinationName = "hansung/controlSettings/" + controlTopicFloor
							+ "/" + controlTopicGroup + "/"+controlTopicPC;
					console.log(message.destinationName);

					blackClient.send(message);
					console.log("publish success : " + message);
				}
				
			} else if(killModeSelect[1].checked == true) {
				
			}
		}
	</script>
	<script type="text/javascript">
		function blockModeClick() {
			var blockModeSelect = document.getElementsByName('blockOptionRadios');
			if(blockModeSelect[0].checked == true) {
				alert(blockModeSelect[0].value);	
				
				
			} else {
				alert(blockModeSelect[1].value);
			}
		}
	</script>
</body>
</html>
<%
	}
%>