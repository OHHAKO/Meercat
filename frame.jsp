<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="dao.MessageDAO"%>
<%@ page import="java.util.ArrayList"%>

<%
   String clientID1 = null;

   if (session.getAttribute("clientID") != null) {
      clientID1 = (String) session.getAttribute("clientID");
   }
   if (clientID1 == null) {
      PrintWriter script = response.getWriter();
      script.println("<script>");
      script.println("alert('접근 권한이 없습니다')");
      script.println("location.href = 'login.jsp?pageNum=frame';");
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

<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="js/bootstrap.js"></script>
<script type="text/javascript"
   src="https://cdnjs.cloudflare.com/ajax/libs/paho-mqtt/1.0.1/mqttws31.min.js"></script>
<script>
   /* function realMainClick(){
      document.getElementById("mainDiv").style.display="block";
      document.getElementById("iframe1Div").style.display="none";
      document.getElementById("iframe2Div").style.display="none";
      document.getElementById("iframe3Div").style.display="none";
   } */
   
   function mainClick(){
      //document.getElementById("mainDiv").style.display="none";
      document.getElementById("iframe1Div").style.display="block";
      document.getElementById("iframe2Div").style.display="none";
      document.getElementById("iframe3Div").style.display="none";
   }
   
   function unAllowedListClick(){
      //document.getElementById("mainDiv").style.display="none";
      document.getElementById("iframe1Div").style.display="none";
      document.getElementById("iframe2Div").style.display="block";
      document.getElementById("iframe3Div").style.display="none";
   }
   
   function readMeClick(){
      //document.getElementById("mainDiv").style.display="none";
      document.getElementById("iframe1Div").style.display="none";
      document.getElementById("iframe2Div").style.display="none";
      document.getElementById("iframe3Div").style.display="block";
   }
   
</script>

</head>

<body class="skin-blue-light sidebar-collapse">
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

            <!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse" id="navbar-collapse">
               <ul class="nav navbar-nav">
                  <li><a href="javascript:;" onclick="mainClick()">실시간 관리</a></li>
                  <li><a href="javascript:;" onclick="unAllowedListClick()">미허용 프로세스
                        관리</a></li>
                  <li><a href="javascript:;" onclick="readMeClick()">사용 설명서</a></li>
               </ul>
               <ul class="nav navbar-nav navbar-right">
                  <li class="dropdown"><a href="#" class="dropdown-toggle"
                     data-toggle="dropdown" role="button" aria-haspopup="true"
                     aria-expanded="false">세션관리<span class="caret"></span></a>
                     <ul class="dropdown-menu">
                        <li><a href="logoutAction.jsp" target="iframe">로그아웃</a></li>
                     </ul></li>
               </ul>
            </div>
            <!-- /.navbar-collapse -->
         </div>
         <!-- /.container-fluid -->
      </nav>
   </header>
   
   <div class="content-wrapper">
      <div id="iframe1Div" style="display:block; position:absolute; top:0px; left:0px; width:100%; height:100%;">
      <iframe id="iframe1" src="main2.jsp" width="100%" height="100%" srcrolling="no"
         frameborder="0" border="0" bordercolor="#000000" marginwidth="0"
         marginheight="0" framespacing="0" vspace="0" name="iframe1"></iframe>
      </div>
      
      <div id="iframe2Div" style="display:none; position:absolute; top:0px; left:0px; width:100%; height:100%;">
      <iframe id="iframe2" src="unAllowedList.jsp" width="100%" height="100%" srcrolling="no"
         frameborder="0" border="0" bordercolor="#000000" marginwidth="0"
         marginheight="0" framespacing="0" vspace="0" name="iframe2"></iframe>
      </div>
         
      <div id="iframe3Div" style="display:none; position:absolute; top:0px; left:0px; width:100%; height:100%;">
      <iframe id="iframe3" src="javascript:;" width="100%" height="100%" srcrolling="no"
         frameborder="0" border="0" bordercolor="#000000" marginwidth="0"
         marginheight="0" framespacing="0" vspace="0" name="iframe3"></iframe>
      </div>
   
   </div>
   
   <footer class="main-footer">
      <div class="pull-right hidden-xs">
         <b>Version</b> 1.0.0
      </div>
      <strong>Copyright &copy; 2018 SolBangUl. </strong> All rights
      reserved.
   </footer>
   
  <!-- <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script> --> 
 	<!-- <script src="js/bootstrap.js"></script> --> 
</body>
</html>
<%
   }
%>