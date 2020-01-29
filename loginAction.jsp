<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="dao.AdminDAO" %>
<%@ page import="dao.RandomSession" %>
<%
	request.setCharacterEncoding("UTF-8");
	String pageNum=request.getParameter("pageNum");  //frame 또는 frame2
%>
<jsp:useBean id="admin" class="dao.Admin" scope="page" />
<jsp:setProperty property="adminID" name="admin" />
<jsp:setProperty property="adminPassword" name="admin" />
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
	<%
		String clientID = null;
		if (session.getAttribute("clientID") != null) {
			clientID = (String) session.getAttribute("clientID");
		}
		if (clientID != null) {
			PrintWriter script = response.getWriter();
			if(pageNum=="frame"){
				script.println("<script>");
				script.println("alert('이미 로그인이 되어있습니다.')");
				script.println("location.href = 'frame.jsp'");
				script.println("</script>");
			}
			else{
				script.println("<script>");
				script.println("alert('이미 로그인이 되어있습니다.')");
				script.println("location.href = 'frame2.jsp'");
				script.println("</script>");
			}
		}

		AdminDAO adminDAO = new AdminDAO(); // 로그인처리 객체생성
		int result = adminDAO.login(admin.getAdminID(), admin.getAdminPassword()); // 로그인 결과값
		if (result == 1) { // 로그인 성공시
			session.setAttribute("clientID", RandomSession.getRandomSession());  // 세션 값 부여
			PrintWriter script = response.getWriter();
			if(pageNum=="frame"){
				script.println("<script>");
				script.println("location.href = 'frame.jsp'");
				script.println("</script>");
			}
			else if(pageNum=="frame2"){
				script.println("<script>");
				script.println("location.href = 'frame2.jsp'");
				script.println("</script>");
			}else{
				script.println("<script>");
				script.println("location.href = 'frame.jsp'");
				script.println("</script>");
			}
		} else if (result == 0 || result == -1) { // 로그인 실패시
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('아이디 또는 비밀번호가 틀립니다.')");
			script.println("history.back()");
			script.println("</script>");
		} else if (result == -2) { // DB 오류시
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('데이터베이스 오류')");
			script.println("history.back()");
			script.println("</script>");
		}
	%>
</body>
</html>