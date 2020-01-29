<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="dao.MessageDAO"%>
<%@ page import="java.util.ArrayList"%>
<%
	String clientID = null;
	if (session.getAttribute("clientID") != null) {
		clientID = (String) session.getAttribute("clientID");
	}
%>
<%
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
<title>Meerkat</title>

<script type="text/javascript"
	src="https://cdnjs.cloudflare.com/ajax/libs/paho-mqtt/1.0.1/mqttws31.min.js"></script>
<script src="unAllowedList_JavascriptResource.js"></script>
<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script>
	var blackClient;
	var blackClientId="<%=clientID%>";
	
	blackClient = new Paho.MQTT.Client("113.198.84.66", Number(9001), blackClientId+"black"); //로그인한 id로 client 생성

	blackClient.onMessageArrived = onMessageArrived2;
	blackClient.onConnectionLost = onConnectionLost2;
	blackClient.connect({
		onSuccess : onConnect2
	});

	function onConnect2() {
		console.log("onConnect-black");
	}

	function onConnectionLost2(responseObject) {
		if (responseObject.errorCode != 0)
			console.log("onConnectionLost-black: "
					+ responseObject.errorMessage);
		alert(blackClient.clientId + "\n" + responseObject.errorCode);
	}
</script>

</head>

<body class="skin-blue-light sidebar-collapse">
	

	<div class="content-wrapper">
		<section class="content-header">
			<h1>
				블랙리스트 관리<small>미허용 프로세스 관리</small>
			</h1>
		</section>

		<section class="content">
			<div class="row">
				<div class="col-sm-4">
					<div class="box box-info">
						<div class="box-header with-border">
							<h3 class="box-title">미허용 프로세스 목록</h3>
							<span id="blackNum" class="label label-warning pull-right">0</span></a>
						</div>
						<!-- /.box-header -->
						<div class="box-body">
							<div class="selectBox">
								<div class="col-md-4">
									<div class="form-group">
										<select id="selectFloor" class="form-control selectFloor"
											style="width: 100%;"
											ng-options="t.id as t.name for t in tags" ng-model="t_id">
											<option selected="selected" id="noFloor1">Floor</option>
										</select>
									</div>
								</div>
								<div class="col-md-4">
									<div class="form-group">
										<select id="selectGroup" class="form-control selectClass"
											style="width: 100%;"
											ng-options="t.id as t.name for t in tags" ng-model="t_id">
											<option selected="selected">Group</option>
										</select>
									</div>
								</div>
							</div>
							<div class="col-md-4">
								<div class="form-group">
									<a href="javascript:void(0)"
										class="btn btn-sm btn-primary btn-flat pull-left"
										onclick="setBlackTopic();">Show List</a>
								</div>
							</div>
							<div class="table" style="overflow-y: auto; max-height: 400px">
								<table class="table table-hover table-striped table-condensed"
									style="text-align: center">
									<thead>
										<tr>
											<th style="background-color: #eeeeee; text-align: center;">프로세스
												이름</th>
											<th style="background-color: #eeeeee; text-align: center;">삭제</th>
										</tr>
									</thead>
									<tbody class="list-group" id="unAllowList">

									</tbody>
								</table>
							</div>
							<!-- /.table-responsive -->
						</div>
						<!-- /.box-body -->
						<div class="box-footer clearfix">
							<div class="col-sm-6">
								<div class="has-feedback">
									<input class="form-control" id="unAllowSearch" type="text"
										placeholder="Search"> <span
										class="glyphicon glyphicon-search form-control-feedback"></span>
								</div>
							</div>
							<div class="form-group">
								<a href="javascript:void(0)"
									class="btn btn-sm btn-danger btn-flat pull-right" onclick="delBlackList()">Delete</a>
							</div>
						</div>
						<!-- /.box-footer -->
					</div>
				</div>

				<!-- /.box -->
				<div class="col-sm-4">

					<div class="box box-info">
						<div class="box-header with-border">
							<h3 class="box-title">미허용 프로세스 추가</h3>
						</div>
						<!-- /.box-header -->
						<!-- form start -->
						<form role="form">
							<div class="box-body">
								<div class="form-group">
									<label for="processAdd">Process Add</label> <input type="text"
										class="form-control" id="processAdd" placeholder="추가할 프로세스 입력">
								</div>
								<div class="form-group">
									<label for="inputFile">File input</label> <input type="file"
										id="exampleInputFile">

									<p class="help-block">추가할 프로세스 목록이 여러개인 경우 .txt파일에 양식에 맞게
										작성하여 첨부 하십시오</p>
								</div>
							</div>
							<!-- /.box-body -->

							<div class="box-footer">
								<a href="javascript:void(0)" onclick="addBlackList();"
									class="btn btn-sm btn-primary btn-flat pull-left">Add</a>
							</div>
						</form>
					</div>
				</div>
				<div class="col-sm-4">
					<div class="box box-success">
						<div class="box-header with-border">
							<h3 class="box-title">현재 실행중인 프로세스 목록</h3>
							<span id="processNum" class="label label-warning pull-right">0</span></a>
						</div>
						<!-- /.box-header -->
						<div class="box-body">
							<div class="selectBox">
								<div class="col-xs-3">
									<div class="form-group">
										<select id="selectProcessFloor"
											class="form-control selectFloor" style="width: 100%;"
											ng-options="t.id as t.name for t in tags" ng-model="t_id">
											<option selected="selected" id="noFloor2">Floor</option>
										</select>
									</div>
								</div>
								<div class="col-xs-3">
									<div class="form-group">
										<select id="selectProcessGroup"
											class="form-control selectClass" style="width: 100%;"
											ng-options="t.id as t.name for t in tags" ng-model="t_id">
											<option selected="selected" id="noGroup">Group</option>
										</select>
									</div>
								</div>
								<div class="col-xs-3">
									<div class="form-group">
										<select select id="selectProcessPC"
											class="form-control selectPC" style="width: 100%;"
											ng-options="t.id as t.name for t in tags" ng-model="t_id">
											<option selected="selected">PC Number</option>
										</select>
									</div>
								</div>
							</div>

							<div class="col-xs-3">
								<div class="form-group">
									<a href="javascript:void(0)"
										class="btn btn-sm btn-primary btn-flat pull-left"
										onclick="setProcessTopic();">Show List</a>
								</div>
							</div>
							<div class="table" style="overflow-y: auto; max-height: 400px">
								<table class="table table-striped table-condensed"
									style="text-align: left">
									<thead>
										<tr>
											<th style="background-color: #eeeeee; text-align: center;">프로세스 이름</th>
										</tr>
									</thead>
									<tbody class="list-group" id="pcProcessList">
									
									</tbody>
								</table>
							</div>
							<!-- /.table-responsive -->
						</div>
						<!-- /.box-body -->
						<div class="box-footer clearfix">
							<div class="col-sm-6">
								<div class="has-feedback">
									<input class="form-control" id="pcProcessSearch" type="text"
										placeholder="Search"> <span
										class="glyphicon glyphicon-search form-control-feedback"></span>
								</div>
							</div>
							<a href="javascript:void(0)"
								class="btn btn-sm btn-success btn-flat pull-right">copy</a>
						</div>
						<!-- /.box-footer -->
					</div>
				</div>
			</div>
			<!-- /.col -->
		</section>"WebContent/main_백업.jsp"
	</div>


	
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
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
			if (request.readyState == 4) {
				if (request.status >= 200 && request.status < 300) {
					xml = request.responseXML;
					getSelectElement(xml);
					/* var classes=xml.getElementsByTagName("class");   
					var output=""; 
					
					for(var i=0;i<classes.length;i++){  
					   output+=classes[i].childNodes[0].nodeValue+" ";   
					}
					content.innerHTML=output; */
				}
			}
		}

		/* $("#hansung").click(function() {
			showFloor(this);

			$('.floor').click(function() {

				// alert($(this).attr('floor'));
			});
		}) */
	}
	
	$(document)
			.ready(
					function() {
						$("#unAllowSearch")
								.on(
										"keyup",
										function() {
											var value = $(this).val()
													.toLowerCase();
											$("#unAllowList tr")
													.filter(
															function() {
																$(this)
																		.toggle(
																				$(
																						this)
																						.text()
																						.toLowerCase()
																						.indexOf(
																								value) > -1)
															});
										});
					});
	$(document)
			.ready(
					function() {
						$("#pcProcessSearch")
								.on(
										"keyup",
										function() {
											var value = $(this).val()
													.toLowerCase();
											$("#pcProcessList tr")
													.filter(
															function() {
																$(this)
																		.toggle(
																				$(
																						this)
																						.text()
																						.toLowerCase()
																						.indexOf(
																								value) > -1)
															});
										});
					});
	</script>
</body>
</html>
<%
	}
%>
