<?xml version="1.0" encoding="UTF-8" ?>
<%@ page import="java.util.*"%>
<%@ page import="dao.MessageVO"%>
<%@ page import="mqttSubscriber.MqttSubscribeSample"%>
<%@ page import="dao.MessageDAO"%>
<%@ page import="mqttDataIntoWeb.MessageIntoXMLDAO"%>
<%@ page import="mqttDataIntoWeb.*"%>
<%@ page contentType="text/xml" pageEncoding="UTF-8"%>



	 <%  
		request.setCharacterEncoding("UTF-8");
	 	
		Vector<RecentMessageVO> recentMessage  = new Vector<RecentMessageVO>(); //리턴받을 dbDO 배열 객체 생성
		Vector<DetectMessageVO> detectMessage = new Vector<DetectMessageVO>();
		Vector<AliveMessageVO> aliveMessage = new Vector<AliveMessageVO>();
		Vector<LogMessageVO> logMessage = new Vector<LogMessageVO>();
		
		MessageIntoXMLDAO messageIntoXMLdao = new MessageIntoXMLDAO();
		recentMessage = messageIntoXMLdao.getAllDataFromRecentTable();
		detectMessage = messageIntoXMLdao.getAllDataFromDetectTable();
		aliveMessage = messageIntoXMLdao.getAllDataFromAliveTable();
		logMessage = messageIntoXMLdao.getAllDataFromLogTable();
		
	 %>	
	 
	 
	 <contents>
	 
	 
	 	<recentTable> 
	 		<% for(int i=0;i<recentMessage.size();i++){ %>
			<record>	
	 			<classroom><%=recentMessage.elementAt(i).getClassroom()%></classroom>
				<pcNumber><%=recentMessage.elementAt(i).getPcNumber()%></pcNumber>
				<recentProcess><%=recentMessage.elementAt(i).getProcessName()%></recentProcess>
				<processCount><%=recentMessage.elementAt(i).getProcessCount()%></processCount>
				<time><%=recentMessage.elementAt(i).getTime()%></time>
				<state><%=aliveMessage.elementAt(i).getAlive()%></state>
			</record>			
		<% } %>		
		</recentTable>
			
		<detectTable>
			<% for(int i=0;i<detectMessage.size();i++){ %>
			<record>	
	 			<classroom><%=detectMessage.elementAt(i).getClassroom()%></classroom>
				<pcNumber><%=detectMessage.elementAt(i).getPcNumber()%></pcNumber>
				<processName><%=detectMessage.elementAt(i).getProcessName()%></processName>
				<time><%=detectMessage.elementAt(i).getTime()%></time>		
			</record>			
		<% } %>		
		</detectTable>
		
			
		<aliveTable>
			<% for(int i=0;i<aliveMessage.size();i++){ %>
			<record>	
	 			<classroom><%=aliveMessage.elementAt(i).getClassroom()%></classroom>
				<pcNumber><%=aliveMessage.elementAt(i).getPcNumber()%></pcNumber>
				<recentProcess><%=aliveMessage.elementAt(i).getAlive()%></recentProcess>
			</record>			
		<% } %>		
		</aliveTable>	
			
		<logTable>
			<% for(int i=0;i<logMessage.size();i++){ %>
			<record>	
	 			<classroom><%=logMessage.elementAt(i).getClassroom()%></classroom>
				<pcNumber><%=logMessage.elementAt(i).getPcNumber()%></pcNumber>
				<processName><%=logMessage.elementAt(i).getProcessName()%></processName>
				<time><%=logMessage.elementAt(i).getTime()%></time>
				<detectionState><%=logMessage.elementAt(i).getRequest()%></detectionState>
			</record>			
		<% } %>		
		</logTable>
		
	
			
			
	 </contents>
	 
	 
	 
	 
	 
		
