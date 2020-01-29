<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="mqttDataIntoWeb.*"%>
<%@ page import="dao.MessageDAO"%>
<%@ page import="java.util.ArrayList"%>
<%
	String clientID = "abc";
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
	href="./bower_components/bootstrap/dist/css/bootstrap.min.css">
<!-- Font Awesome -->
<link rel="stylesheet"
	href="./bower_components/font-awesome/css/font-awesome.min.css">
<!-- Ionicons -->
<link rel="stylesheet"
	href="./bower_components/Ionicons/css/ionicons.min.css">
<!-- Theme style -->
<link rel="stylesheet" href="dist/css/AdminLTE.css">
<!-- AdminLTE Skins. Choose a skin from the css/skins
       folder instead of downloading all of them to reduce the load. -->
<link rel="stylesheet" href="./dist/css/skins/_all-skins.min.css">
<!-- Morris chart -->
<link rel="stylesheet" href="./bower_components/morris.js/morris.css">
<!-- jvectormap -->
<link rel="stylesheet"
	href="./bower_components/jvectormap/jquery-jvectormap.css">
<!-- Date Picker -->
<link rel="stylesheet"
	href="./bower_components/bootstrap-datepicker/dist/css/bootstrap-datepicker.min.css">
<!-- Daterange picker -->
<link rel="stylesheet"
	href="./bower_components/bootstrap-daterangepicker/daterangepicker.css">
<!-- bootstrap wysihtml5 - text editor -->
<link rel="stylesheet"
	href="./plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.min.css">
<link rel="stylesheet"
	href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,600,700,300italic,400italic,600italic">
<title>Meerkat</title>

<script type="text/javascript"
	src="https://cdnjs.cloudflare.com/ajax/libs/paho-mqtt/1.0.1/mqttws31.min.js"></script>
<script src="js/bootstrap.js"></script>
<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="main_JavascriptResource.js"></script>



</head>

<body class="skin-blue-light sidebar-collapse">
	<div class="content-wrapper">

		<section class="content-header">
			<h1>
				실시간 관리 <small>그룹 PC 통합관리 시스템</small>
			</h1>
		</section>

		<section class="content">
			<div class="row">
				<div class="col-sm-6">
				
					<div class="nav-tabs-custom">
						<ul id="groupTab" class="nav nav-pills" role="tablist">
							<li role="presentation" class="active"><a
								href="#groupManagement" id="detect-tab" role="tab"
								data-toggle="tab" aria-controls="group" aria-expanded="false">그룹별
									관리</a></li>
							<li role="presentation"><a href="#detectControl" role="tab"
								id="detect-tab" data-toggle="tab" aria-controls="group"
								aria-expanded="true">감지 ON/OFF</a></li>
						</ul>
						<div id="groupTabContent" class="tab-content">
							<div role="tabpanel" class="tab-pane active in"
								id="#groupManagement" aria-labelledby="detect-tab">
								
								<div class="box box-primary">
									<div class="box-header with-border">
										<h3 class="box-title">그룹별 관리</h3>
									</div>
									<!-- /.box-header -->
									<div class="box-body">
										<div class="selectBox">
											<div class="col-md-4">
												<div class="form-group">
													<select class="form-control selectFloor"
														id="selectFloorInGMT" style="width: 100%;"
														ng-options="t.id as t.name for t in tags" ng-model="t_id"
														onclick="setFloor();">
														<option class="optionFloor" id="allFloor">All
															Floor</option>
													</select>
												</div>
											</div>
											<div class="col-md-4">
												<div class="form-group">
													<select class="form-control selectClass"
														id="selectGroupInGMT" style="width: 100%;"
														ng-options="t.id as t.name for t in tags" ng-model="t_id"
														disabled="disabled" onclick="setGroup();">
														<option class="optionClass" optionClass="all">All
															Class</option>
													</select>
												</div>
											</div>
										</div>
										<div class="col-sm-4">
											<div class="form-group">
												<div class="has-feedback">
													<input class="form-control"
														id="groupManagementProcessSearch" type="text"
														placeholder="Search"> <span
														class="glyphicon glyphicon-search form-control-feedback"></span>
												</div>
											</div>
										</div>
										<div class="table" style="overflow-y: auto; max-height: 520px">
											<table class="table table-striped table-condensed"
												id="groupManagementTable" style="text-align: center">
												<thead>
													<tr>
														<th style="background-color: #eeeeee; text-align: center;">강의실</th>
														<th style="background-color: #eeeeee; text-align: center;">PC번호</th>
														<th style="background-color: #eeeeee; text-align: center;">프로세스</th>
														<th style="background-color: #eeeeee; text-align: center;">프로세스수</th>
														<th style="background-color: #eeeeee; text-align: center;">시간</th>
														<th style="background-color: #eeeeee; text-align: center;">연결상태</th>
													</tr>
												</thead>
												<tbody class="list-group" id="groupManagementList">
												</tbody>
											</table>
										</div>
									</div>
								</div>
							</div>
						</div>

						<div role="tabpanel" class="tab-pane fade" id="#detectControl"
							aria-labelledby="detect-tab">
							<div class="box box-primary">
								<!-- /.box-header -->
								<div class="box-body">
									<div class="selectBox">
										<div class="col-md-4">
											<div class="form-group">
												<select class="form-control selectFloor"
													style="width: 100%;"
													ng-options="t.id as t.name for t in tags" ng-model="t_id">
													<option selected="selected">All Floor</option>
												</select>
											</div>
										</div>
										<div class="col-md-4">
											<div class="form-group">
												<select class="form-control selectClass"
													style="width: 100%;"
													ng-options="t.id as t.name for t in tags" ng-model="t_id">
													<option selected="selected">All Class</option>
												</select>
											</div>
										</div>
									</div>
									<div class="table" style="overflow-y: auto; max-height: 440px">
										<table class="table table-striped table-condensed"
											style="text-align: center">
											<thead>
												<tr>
													<th style="background-color: #eeeeee; text-align: center;">강의실</th>
													<th style="background-color: #eeeeee; text-align: center;">PC번호</th>
													<th style="background-color: #eeeeee; text-align: center;">연결상태</th>
													<th style="background-color: #eeeeee; text-align: center;">감지
														ON/OFF&nbsp;&nbsp;&nbsp;&nbsp;<label class="switch">
															<input type="checkbox" class="detectControl-all" checked>
															<span class="slider round"></span>
													</label>
													</th>
												</tr>
											</thead>
											<tbody class="list-group" id="detectControlTable">
												<%
													MessageDAO messageDAO = new MessageDAO();

														ArrayList<DetectControlVO> controlList = messageDAO.getDetectControlList();
														ArrayList<AliveMessageVO> aliveList = messageDAO.getAliveList();

														for (int i = 0; i < aliveList.size(); i++) {
												%>
												<tr id="detectControlTr">
													<td><%=controlList.get(i).getClassroom()%></td>
													<td><%=controlList.get(i).getPcNumber()%></td>
													<td><%=aliveList.get(i).getAlive()%></td>
													<td>
														<%
															if (aliveList.get(i).getAlive().equals("n") || aliveList.get(i).getAlive().equals("N")) {
														%>
														<label class="switch"><input type="checkbox"
															class="detectControl" disabled> <span
															class="slider round"></span></label> <%
 	} else {
 				if (controlList.get(i).getControl() == 1) {
 %>
														<%-- 프로그램 살아있고 감지ON인 경우 --%> <label class="switch"><input
															id=<%=controlList.get(i).getClassroom()%>
															-<%=controlList.get(i).getPcNumber()%> type="checkbox"
															class="detectControl" checked> <span
															class="slider round"></span></label> <%
 	} else if (controlList.get(i).getControl() == 0) {
 %>
														<%-- 프로그램 살아있고 감지OFF인 경우 --%> <label class="switch"><input
															id=<%=controlList.get(i).getPcNumber()%> type="checkbox"
															class="detectControl"> <span class="slider round"></span></label>
														<%
															}
														%>
														<%
															}
														%>
													</td>
												</tr>
												<%
													}
												%>
											</tbody>
										</table>
									</div>
									<!-- /.table-responsive -->
								</div>
							</div>
						</div>
					</div>
				</div>
				<!-- ------------------------------------------------------------------------------------------------------------------------------------- -->

				<div class="col-sm-6">
					<div class="nav-tabs-custom">
						<ul id="groupTab" class="nav nav-pills" role="tablist">
							<li role="presentation" class="active"><a
								href="#pcManagement" id="group-tab" role="tab" data-toggle="tab"
								aria-controls="group" aria-expanded="false">PC별 관리</a></li>
							<li role="presentation"><a href="#detectCheck" role="tab"
								id="detect-tab" data-toggle="tab" aria-controls="group"
								aria-expanded="true">감지 확인&nbsp;&nbsp;&nbsp;&nbsp;<span
									id="detectedCheckNum" class="label label-danger pull-right">0</span></a></li>
							<li role="presentation"><a href="#detectLog" role="tab"
								id="detect-tab" data-toggle="tab" aria-controls="group"
								aria-expanded="true">감지 기록&nbsp;&nbsp;&nbsp;&nbsp;<span
									id="detectedLogNum" class="label label-danger pull-right">0</span></a></li>
						</ul>
						<div id="groupTabContent" class="tab-content">
							<div role="tabpanel" class="tab-pane active in" id="pcManagement"
								aria-labelledby="group-tab">
								<div class="box box-primary">
									<!-- /.box-header -->
									<div class="box-body">
										<div class="col-sm-8"></div>
										<div class="col-sm-4">
											<div class="form-group">
												<div class="has-feedback">
													<input class="form-control detecttable"
														id="pcManagementProcessSearch" type="text"
														placeholder="Search"> <span
														class="glyphicon glyphicon-search form-control-feedback"></span>
												</div>
											</div>
										</div>
										<div class="table" style="overflow-y: auto; max-height: 440px">
											<table class="table table-striped table-condensed"
												id="pcManagementTable" style="text-align: center">
												<thead>
													<tr>
														<th style="background-color: #eeeeee; text-align: center;">강의실</th>
														<th style="background-color: #eeeeee; text-align: center;">PC번호</th>
														<th style="background-color: #eeeeee; text-align: center;">프로세스</th>
														<th style="background-color: #eeeeee; text-align: center;">시간</th>
														<th style="background-color: #eeeeee; text-align: center;">종료
															<input type="checkbox" id="pcManagementItem-all">
														</th>
													</tr>
												</thead>
												<!-- pc별 관리 테이블의 바디 -->
												<tbody class="list-group" id="pcManagementList">
												</tbody>
											</table>
										</div>
									</div>
									<div class="form-group">
										<a href="javascript:void(0)"
											class="btn btn-sm btn-danger btn-flat pull-right"
											onclick="killPCProcess()">Kill</a>
									</div>
								</div>

							</div>
							<div role="tabpanel" class="tab-pane fade" id="detectCheck"
								aria-labelledby="detect-tab">
								<div class="box box-primary">
									<!-- /.box-header -->
									<div class="box-body">
										<div class="selectBox">
											<div class="col-md-4">
												<div class="form-group">
													<select class="form-control selectFloor"
														id="selectFloorInDCT" style="width: 100%;"
														ng-options="t.id as t.name for t in tags" ng-model="t_id"
														onclick="setFloor2();">
														<option selected="selected">All Floor</option>
													</select>
												</div>
											</div>
											<div class="col-md-4">
												<div class="form-group">
													<select class="form-control selectClass"
														id="selectGroupInDCT" style="width: 100%;"
														ng-options="t.id as t.name for t in tags" ng-model="t_id"
														disabled="disabled" onclick="setGroup2();">
														<option selected="selected">All Classroom</option>
													</select>
												</div>
											</div>
										</div>
										<div class="col-sm-4">
											<div class="form-group">
												<div class="has-feedback">
													<input class="form-control" id="detectCheckProcessSearch"
														type="text" placeholder="Search"> <span
														class="glyphicon glyphicon-search form-control-feedback"></span>
												</div>
											</div>
										</div>
										<div class="table" style="overflow-y: auto; max-height: 440px">
											<table class="table table-striped table-condensed"
												style="text-align: center" id="detectCheckTable">

												<thead>
													<tr>
														<th style="background-color: #eeeeee; text-align: center;">강의실</th>
														<th style="background-color: #eeeeee; text-align: center;">PC번호</th>
														<th style="background-color: #eeeeee; text-align: center;">프로세스</th>
														<th style="background-color: #eeeeee; text-align: center;">시간</th>
														<th style="background-color: #eeeeee; text-align: center;">종료
															<input type="checkbox" id="detectCheckItem-all">
														</th>
													</tr>
												</thead>
												<!--  감지확인 테이블의 바디 -->
												<tbody class="list-group" id="detectCheckList">
												</tbody>
											</table>
										</div>
										<!-- /.table-responsive -->
									</div>
									<div class="form-group">
										<a href="javascript:void(0)"
											class="btn btn-sm btn-danger btn-flat pull-right"
											onclick="killProcess()">Kill</a>
									</div>
								</div>
							</div>
							<div role="tabpanel" class="tab-pane fade" id="detectLog"
								aria-labelledby="detect-tab">
								<div class="box box-primary">
									<!-- /.box-header -->
									<div class="box-body">
										<div class="selectBox">
											<div class="col-md-4">
												<div class="form-group">
													<select class="form-control selectFloor"
														id="selectFloorInDLT" style="width: 100%;"
														ng-options="t.id as t.name for t in tags" ng-model="t_id"
														onclick="setFloor3();">
														<option selected="selected">All Floor</option>
													</select>
												</div>
											</div>
											<div class="col-md-4">
												<div class="form-group">
													<select class="form-control selectClass"
														id="selectGroupInDLT" style="width: 100%;"
														ng-options="t.id as t.name for t in tags" ng-model="t_id"
														disabled="disabled" onclick="setGroup3();">
														<option selected="selected">All Class</option>
													</select>
												</div>
											</div>
										</div>
										<div class="col-sm-4">
											<div class="form-group">
												<div class="has-feedback">
													<input class="form-control" id="detectCheckProcessSearch"
														type="text" placeholder="Search"> <span
														class="glyphicon glyphicon-search form-control-feedback"></span>
												</div>
											</div>
										</div>
										<div class="table" style="overflow-y: auto; max-height: 440px">
											<table class="table table-striped table-condensed"
												style="text-align: center" id="detectionLogTable">
												<thead>
													<tr>
														<th style="background-color: #eeeeee; text-align: center;">강의실</th>
														<th style="background-color: #eeeeee; text-align: center;">PC번호</th>
														<th style="background-color: #eeeeee; text-align: center;">프로세스</th>
														<th style="background-color: #eeeeee; text-align: center;">시간</th>
														<th style="background-color: #eeeeee; text-align: center;">감지상태</th>
													</tr>
												</thead>
												<!-- 감지기록 테이블의 바디 -->
												<tbody class="list-group " id="detectLogList">
												</tbody>
											</table>
										</div>
										<!-- /.table-responsive -->
									</div>
								</div>
							</div>


							<br>
						</div>
					</div>
					<!-- /.col -->
				</div>
			</div>
		</section>
	</div>

	<footer class="main-footer">
		<div class="pull-right hidden-xs">
			<b>Version</b> 1.0.0
		</div>
		<strong>Copyright &copy; 2018 SolBangUl. </strong> All rights
		reserved.
	</footer>

	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
	<script src="main_JavascriptResource.js"></script>
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
						xmlOfDBAndSub = request.responseXML;
						getSelectElement(xmlOfDBAndSub); //select box에 강의실 option 추가

					}
				}
			}

			//db에서 table 가져오는 함수 필요
		}

		$(document)
				.ready(
						function() {
							$("#groupManagementProcessSearch")
									.on(
											"keyup",
											function() {
												var value = $(this).val()
														.toLowerCase();
												$(
														"#groupManagementRecordList tr")
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

							$("#pcManagementProcessSearch")
									.on(
											"keyup",
											function() {
												var value = $(this).val()
														.toLowerCase();
												$("#pcManagementList tr")
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

							$("#detectCheckProcessSearch")
									.on(
											"keyup",
											function() {
												var value = $(this).val()
														.toLowerCase();
												$("#detectCheckList tr")
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

							$("#detectLogSearch")
									.on(
											"keyup",
											function() {
												var value = $(this).val()
														.toLowerCase();
												$("#detectLogList tr")
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
	<script>
		/*$(document).ready(function() {
				 $("#pcManagementProcessSearch").on("keyup",function() {
					var value = $(this).val().toLowerCase();
					$("#pcManagementProcessList tr").filter(function() {
							$(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
																	});
												}); 
							});*/
	</script>
	<script>
		/* 	$(document).ready(function() {
				$("#detectCheckProcessSearch").on("keyup",
						function() {var value = $(this).val().toLowerCase();
						$("#detectCheckProcessList tr").filter(function() {
								$(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
																	});
												});
							}); */
	</script>
	<script>
		/* $(document).ready(function() {
				$("#detectLogSearch").on(
					"keyup",function() {
						var value = $(this).val().toLowerCase();
						$("#detectLogList tr").filter(function() {
								$(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
																});
											});
						}); */
	</script>
	<script>
		$(document).ready(
				function() {
					$('.detectControl-all').click(
							function() {
								$('.detectControl').not(':disabled').prop(
										'checked', this.checked);
								if ($(this).prop('checked') == true) {

								} else {
									alert("OFF");
								}
							});
				});
	</script>
	<script>
		/* 이 부분에서 mqttPub코드 삽입  */
		$(document).ready(function() {
			$('.detectControl').click(function() {
				var clientID = $(this).attr("id"); // ex) 102-10 형태로 데이터 가져옴
				var topic = clientID.split("-"); // '-'으로 분해
				var classroom = topic[0]; // classroom 정보(토픽)
				var pcNumber = topic[1]; // pcNumber 정보(토픽)

				if (classroom.substring(0, 1) == "1")
					floor = "1floor";
				else if (classroom.substring(0, 1) == "2")
					floor = "2floor";
				else if (classroom.substring(0, 1) == "3")
					floor = "3floor";

				if ($(this).prop('checked') == true) {
					message = new Paho.MQTT.Message("detectionControl;1");
		            message.destinationName = "hansung/controlSettings/" + floor + "/" + classroom + "/" +pcNumber;
		            client.send(message);

		            var messageDao = new message.MessageDAO();
		            messageDao.detectControlTableWrite(classroom, 1);								
				} else {
					 message = new Paho.MQTT.Message("detectionControl;0");
			            message.destinationName = "hansung/controlSettings/" + floor + "/" + classroom + "/" +pcNumber;
			            client.send(message);

			            var messageDao = new message.MessageDAO();
			            messageDao.detectControlTableWrite(classroom, 0);
			            alert("OFF");

				}
			});
		});
	</script>
</body>
</html>
<%
	}
%>