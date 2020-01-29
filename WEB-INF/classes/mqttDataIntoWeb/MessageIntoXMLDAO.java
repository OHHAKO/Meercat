package mqttDataIntoWeb;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Vector;

public class MessageIntoXMLDAO {

   private Connection conn = null;
   private ResultSet rs = null;

   public MessageIntoXMLDAO() { 
      try {
         String dbURL = "jdbc:mysql://localhost:3306/mqttdb?serverTimezone=UTC";
         String dbID = "root";
         String dbPassword = "hansung";
         Class.forName("com.mysql.cj.jdbc.Driver");
         conn = DriverManager.getConnection(dbURL, dbID, dbPassword);

      } catch (Exception e) {
         e.printStackTrace();

      }
   }

   /*public void RecentTable(String classroom) { 
      String SQL = "SELECT * FROM RECENTTABLE";
      try {
         PreparedStatement pstmt = conn.prepareStatement(SQL);      
         ResultSet rs = pstmt.executeQuery();
         while (rs.next()) {
            RecentMessageVO recentMessageVO = new RecentMessageVO();
            recentMessageVO.setClassroom(rs.getString("classroom"));
            recentMessageVO.setPcNumber(rs.getInt("pcNumber"));
            recentMessageVO.setProcessName(rs.getString("recentProcess"));
            recentMessageVO.setProcessCount(rs.getInt("processCount"));
            recentMessageVO.setTime(rs.getString("time"));
         }
      } catch (Exception e) {
         e.printStackTrace();
         System.out.println(e);
      }
   }
   public void DetectTable(String classroom, int pcNumber) {
      String SQL = "SELECT * FROM DETECTTABLE ";
      try {
         PreparedStatement pstmt = conn.prepareStatement(SQL);
         ResultSet rs = pstmt.executeQuery();
         while (rs.next()) {
            DetectMessageVO dectMessageVO=new DetectMessageVO();
            int pcNo = rs.getInt("pcNumber");
            String processName = rs.getString("processName");
            String time = rs.getString("time");
            dectMessageVO.setClassroom(rs.getString("classroom"));
            dectMessageVO.setPcNumber(pcNo);
            dectMessageVO.setProcessName(processName);
            dectMessageVO.setTime(time);
         }
      } catch (Exception e) {
         e.printStackTrace();
      }
   }

   public void AliveTable(String classroom) {
      String SQL = "SELECT * FROM ALIVETABLE";
      AliveMessageVO aliveMessageVO;
      try {         
         PreparedStatement pstmt = conn.prepareStatement(SQL);
         ResultSet rs = pstmt.executeQuery();
         while (rs.next()) {
            aliveMessageVO=new AliveMessageVO();
            int pcNumber = rs.getInt("pcNumber");
            String alive = rs.getString("alive");
            aliveMessageVO.setClassroom(rs.getString("classroom"));
            aliveMessageVO.setPcNumber(pcNumber);
            aliveMessageVO.setAlive(alive);
         }
      } catch (Exception e) {
         e.printStackTrace();
      }
   }*/
   
   public Vector<RecentMessageVO> getAllDataFromRecentTable() { 
      int i=0;
      Vector<RecentMessageVO> dbResultSet = new Vector<RecentMessageVO>();
      RecentMessageVO dbResult;
      
      System.out.println("getAllDataToRecentTable fun is working");
      String SQL = "SELECT * FROM RECENTTABLE";
      try {
         PreparedStatement pstmt = conn.prepareStatement(SQL);
         ResultSet rs = pstmt.executeQuery();
         while (rs.next()) {
            dbResult = new RecentMessageVO();
            
            dbResult.setClassroom(rs.getString("classroom"));
            dbResult.setPcNumber(rs.getInt("pcNumber"));
            dbResult.setProcessName(rs.getString("recentProcess"));
            dbResult.setProcessCount(rs.getInt("processCount"));
            dbResult.setTime(rs.getString("time"));
            
            dbResultSet.add(i,dbResult);
            //System.out.println(i+" dbResultSet : "+dbResultSet.get(i).getPcNumber());
            i++;            
         }
         
      } catch (Exception e) {
         e.printStackTrace();
         System.out.println("getRecentTable error");
         System.out.println(e);
      }
      
   
      return dbResultSet;
   }
   public Vector<DetectMessageVO> getAllDataFromDetectTable() {
      
      int i=0;
      Vector<DetectMessageVO> dbResultSet = new Vector<DetectMessageVO>();
      DetectMessageVO dbResult;
      
      String SQL = "SELECT * FROM DETECTTABLE ";
      try {
         PreparedStatement pstmt = conn.prepareStatement(SQL);
         ResultSet rs = pstmt.executeQuery();
         while (rs.next()) {
            dbResult = new DetectMessageVO();
            dbResult.setClassroom(rs.getString("classroom"));
            dbResult.setPcNumber(rs.getInt("pcNumber"));
            dbResult.setProcessName(rs.getString("processName"));
            dbResult.setTime(rs.getString("time"));
            dbResultSet.add(i,dbResult);
           // System.out.println(i+" dbResultSet : "+dbResultSet.get(i).getPcNumber());
            i++;
            
         }
         
      } catch (Exception e) {
         e.printStackTrace();
         System.out.println("getDectectTable error");
         System.out.println(e);
      }
      
   
      return dbResultSet;
   }
   public Vector<AliveMessageVO> getAllDataFromAliveTable() { 
      int i=0;
      Vector<AliveMessageVO> dbResultSet = new Vector<AliveMessageVO>();
      AliveMessageVO dbResult; 
      
      String SQL = "SELECT * FROM ALIVETABLE ";
      try {
         PreparedStatement pstmt = conn.prepareStatement(SQL);
         ResultSet rs = pstmt.executeQuery();
         while (rs.next()) {
            dbResult = new AliveMessageVO();         
            dbResult.setClassroom(rs.getString("classroom"));
            dbResult.setPcNumber(rs.getInt("pcNumber"));
            dbResult.setAlive(rs.getString("alive"));
            dbResultSet.add(i,dbResult);
        //    System.out.println(i+" dbResultSet : "+dbResultSet.get(i).getPcNumber());
            i++;            
         }
         
      } catch (Exception e) {
         e.printStackTrace();
         System.out.println("aliveTable error");
         System.out.println(e);
      }
      
   
      return dbResultSet;
   }
   public Vector<LogMessageVO> getAllDataFromLogTable() { 
      int i=0;
      Vector<LogMessageVO> dbResultSet = new Vector<LogMessageVO>();
      LogMessageVO dbResult; 
      
      String SQL = "SELECT * FROM LOGTABLE ORDER BY TIME DESC ";
      try {
         PreparedStatement pstmt = conn.prepareStatement(SQL);
         ResultSet rs = pstmt.executeQuery();
         while (rs.next()) {
            dbResult = new LogMessageVO();    
            
            dbResult.setClassroom(rs.getString("classroom"));
            dbResult.setPcNumber(rs.getInt("pcNumber"));
            dbResult.setProcessName(rs.getString("processName"));
            dbResult.setTime(rs.getString("time"));
            dbResult.setRequest(rs.getString("request"));
            
            dbResultSet.add(i,dbResult);
        //    System.out.println(i+" LogTable ResultSet : "+dbResultSet.get(i).getPcNumber());
            i++;            
         }
         
      } catch (Exception e) {
         e.printStackTrace();
         System.out.println("logtable error");
         System.out.println(e);
      }
      
   
      return dbResultSet;
   }
    
   
   

}
