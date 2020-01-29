package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AdminDAO {
	private Connection conn = null;
	private PreparedStatement pstmt;
	private ResultSet rs = null;

	public AdminDAO() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/admindb?serverTimezone=UTC&useSSL=false";
			String dbID = "root";
			String dbPassword = "hansung";
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
			
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println(e);
			
		}
	}
	
	public int login(String adminID, String adminPassword) {
		String SQL ="SELECT adminPassword FROM ADMIN WHERE ADMINID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, adminID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				if(rs.getString(1).equals(adminPassword))
					return 1; // 로그인 성공
			} else 
				return 0; // 비밀번호 불일치
			return -1; // 아이디가 없음
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -2; // 데이터베이스 오류
	}
}
