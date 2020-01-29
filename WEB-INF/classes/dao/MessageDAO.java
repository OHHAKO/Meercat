package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Vector;

import mqttDataIntoWeb.AliveMessageVO;
import mqttDataIntoWeb.DetectControlVO;

public class MessageDAO { // db泥섎━�븯�뒗 �븿�닔 �룷�븿

	private Connection conn = null;
	private ResultSet rs = null;

	public MessageDAO() { // �깮�꽦�옄�뿉�꽌 db�뿰寃�
		try {
			String dbURL = "jdbc:mysql://localhost:3306/mqttdb?serverTimezone=UTC";
			String dbID = "root";
			String dbPassword = "hansung";
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
			System.out.println("MessageDAO");
			// 媛앹껜 �깮�꽦�릺硫댁꽌 �씠 �궡�슜�씠 諛섏쁺�씠 �릺�빞�븯�뒗�뜲 吏�湲� �뼱�뼡�씠�쑀濡� 而댄뙆�씪�씠 怨꾩냽 �븞�릺�꽌
			// �씠�쟾�궡�슜留� 遺덈윭��吏�
		} catch (Exception e) {
			e.printStackTrace();

		}
	}

	public void selectRecentTable(String classroom) { // �꽆�뼱�삩 classroom 踰덊샇濡�
														// 理쒓렐classroom �뀒�씠釉� 議고쉶�썑
														// �씠�겢由쎌뒪 肄섏넄李� 異쒕젰
		System.out.println("selectRecentTable working");
		String SQL = "SELECT * FROM RECENTTABLE WHERE CLASSROOM = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, classroom);

			ResultSet rs = pstmt.executeQuery();
			while (rs.next()) {
				String pcNumber = rs.getString("pcNumber");
				String recentProcess = rs.getString("recentProcess");
				int processCount = rs.getInt("processCount");
				String time = rs.getString("time");
				System.out.println(
						classroom + " | " + pcNumber + " | " + recentProcess + " | " + processCount + " | " + time);
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println(e);
		}
	}

	public void selectDetectTable(String classroom, int pcNumber) {
		String SQL = "SELECT * FROM DETECTTABLE WHERE CLASSROOM = ? AND PCNUMBER = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, classroom);
			pstmt.setInt(2, pcNumber);
			ResultSet rs = pstmt.executeQuery();
			while (rs.next()) {
				int pcNo = rs.getInt("pcNumber");
				String processName = rs.getString("processName");
				String time = rs.getString("time");
				System.out.println(pcNo + " | " + processName + " | " + time);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void selectAliveTable(String classroom) {
		String SQL = "SELECT * FROM ALIVETABLE WHERE CLASSROOM = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, classroom);
			ResultSet rs = pstmt.executeQuery();
			while (rs.next()) {
				int pcNumber = rs.getInt("pcNumber");
				String alive = rs.getString("alive");
				System.out.println(pcNumber + " | " + alive);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public String inputRecentTable(String classroom, int pcNumber) {
		String SQL2 = "INSERT INTO recentTable values(?,?,'1')";
		String SQL = "INSERT INTO recentTable values('" + classroom + "','" + pcNumber + "',1)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL2);
			pstmt.setString(1, classroom);
			pstmt.setInt(2, 3);

			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "yes"; // �뜲�씠�꽣踰좎씠�뒪 �삤瑜�
	}

	public ArrayList<MessageVO> getList(int pageNumber) { // detectTable�쓣 媛��졇�샂
		String SQL = "SELECT * FROM DETECTTABLE WHERE DETECTNUMBER < ? ORDER BY DETECTNUMBER DESC LIMIT 10";
		ArrayList<MessageVO> list = new ArrayList<MessageVO>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				MessageVO detectMessage = new MessageVO();
				detectMessage.setClassroom(rs.getString("classroom"));
				detectMessage.setPcNumber(rs.getInt("pcNumber"));
				detectMessage.setProcessName(rs.getString("processName"));
				detectMessage.setTime(rs.getString("time"));
				detectMessage.setDetectNumber(rs.getInt("detectNumber"));
				list.add(detectMessage);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	public int getNext() {
		String SQL = "SELECT DETECTNUMBER FROM DETECTTABLE ORDER BY DETECTNUMBER DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getInt(1) + 1;
			}
			return 1; // 泥ル쾲吏� 硫붿떆吏��씤寃쎌슦
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // �뜲�씠�꽣踰좎씠�뒪 �삤瑜�
	}

	public String getTime() {
		String SQL = "SELECT NOW()";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getString(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ""; // �뜲�씠�꽣踰좎씠�뒪 �삤瑜�.
	}

	public int detectTableWrite(String classroom, int pcNumber, String processName) {
		String SQL = "INSERT INTO detectTable VALUES (?, ?, ?, ?)"; // 媛뺤쓽�떎,
																	// PC踰덊샇,
																	// �봽濡쒖꽭�뒪, �떆媛�
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, classroom);
			pstmt.setInt(2, pcNumber);
			pstmt.setString(3, processName);
			pstmt.setString(4, getTime());
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // �뜲�씠�꽣踰좎씠�뒪 �삤瑜�
	}

	public int detectTableDelete(String classroom, int pcNumber, String processName) { // �봽濡쒖꽭�뒪
																						// 醫낅즺�떆
																						// �빐�떦
																						// �젅肄붾뱶
																						// �궘�젣
		String SQL = "DELETE FROM detectTable WHERE CLASSROOM = ? and PCNUMBER = ? and PROCESSNAME = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, classroom);
			pstmt.setInt(2, pcNumber);
			pstmt.setString(3, processName);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // �뜲�씠�꽣踰좎씠�뒪 �삤瑜�
	}

	public int recentTableWrite(String classroom, int pcNumber, String recentProcess, int processCount) {
		String SQL = "UPDATE recentTable SET recentProcess = ?, processCount = ?, time = ? WHERE classroom = ? and pcNumber = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, recentProcess);
			pstmt.setInt(2, processCount);
			pstmt.setString(3, getTime());
			pstmt.setString(4, classroom);
			pstmt.setInt(5, pcNumber);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // �뜲�씠�꽣踰좎씠�뒪 �삤瑜�
	}

	public int recentTableDelete(String classroom, int pcNumber, String recentProcess, int processCount) {
		if (processCount == 0 && selectRecentProcess(classroom, pcNumber).equals(recentProcess)) { // �떎�뻾以묒씤
																									// 誘명뿀�슜
																									// �봽濡쒖꽭�뒪
																									// 0媛쒓�
																									// �맂
																									// 寃쎌슦
			String SQL = "UPDATE recentTable SET recentProcess = ?, processCount = ?, time = ? WHERE classroom = ? and pcNumber = ?";
			try {
				PreparedStatement pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, "NULL");
				pstmt.setInt(2, processCount);
				pstmt.setString(3, getTime());
				pstmt.setString(4, classroom);
				pstmt.setInt(5, pcNumber);
				return pstmt.executeUpdate();
			} catch (Exception e) {
				e.printStackTrace();
			}
			return -1; // �뜲�씠�꽣踰좎씠�뒪 �삤瑜�
		} else if (processCount > 0 && selectRecentProcess(classroom, pcNumber).equals(recentProcess)) { // �떎�뻾以묒씤
																											// 誘명뿀�슜
																											// �봽濡쒖꽭�뒪媛�
																											// 1媛�
																											// �씠�긽�씠怨�
																											// 醫낅즺�맂
																											// �봽濡쒖꽭�뒪媛�
																											// recentProcess�씤
																											// 寃쎌슦
			String process = selectDetectProcess(classroom, pcNumber, recentProcess); // 媛깆떊�맆
																						// �봽濡쒖꽭�뒪
			String SQL = "UPDATE recentTable SET recentProcess = ?, processCount = ?, time = ? WHERE classroom = ? and pcNumber = ?";
			try {
				PreparedStatement pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, process);
				pstmt.setInt(2, processCount);
				pstmt.setString(3, getTime());
				pstmt.setString(4, classroom);
				pstmt.setInt(5, pcNumber);
				return pstmt.executeUpdate();
			} catch (Exception e) {
				e.printStackTrace();
			}
			return -1; // �뜲�씠�꽣踰좎씠�뒪 �삤瑜�
		} else { // �떎�뻾以묒씤 誘명뿀�슜 �봽濡쒖꽭�뒪媛� 1媛� �씠�긽�씠怨� 醫낅즺�맂 �봽濡쒖꽭�뒪媛� recentProcess媛� �븘�땶 寃쎌슦
			String SQL = "UPDATE recentTable SET processCount = ?, time = ? WHERE classroom = ? and pcNumber = ?";
			try {
				PreparedStatement pstmt = conn.prepareStatement(SQL);
				pstmt.setInt(1, processCount);
				pstmt.setString(2, getTime());
				pstmt.setString(3, classroom);
				pstmt.setInt(4, pcNumber);
				return pstmt.executeUpdate();
			} catch (Exception e) {
				e.printStackTrace();
			}
			return -1; // �뜲�씠�꽣踰좎씠�뒪 �삤瑜�
		}
	}

	public String selectRecentProcess(String classroom, int pcNumber) { // 理쒓렐
																		// �궗�슜�맂
																		// �봽濡쒖꽭�뒪
																		// 寃��깋
		String SQL = "SELECT RECENTPROCESS FROM RECENTTABLE WHERE CLASSROOM = ? AND PCNUMBER = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, classroom);
			pstmt.setInt(2, pcNumber);

			ResultSet rs = pstmt.executeQuery();
			rs.next();
			return rs.getString("recentProcess"); // recentprocess 諛섑솚
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ""; // 寃��깋寃곌낵 �뾾�뒗寃쎌슦
	}

	public String selectDetectProcess(String classroom, int pcNumber, String processName) { // �쁽�옱
																							// �궗�슜以묒씤
																							// �봽濡쒖꽭�뒪
																							// 寃��깋
		String SQL = "SELECT PROCESSNAME FROM DETECTTABLE WHERE CLASSROOM = ? AND PCNUMBER = ? AND PROCESSNAME <> ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, classroom);
			pstmt.setInt(2, pcNumber);
			pstmt.setString(3, processName);
			ResultSet rs = pstmt.executeQuery();

			rs.next();
			return rs.getString("processname"); // recentprocess 諛섑솚
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ""; // 寃��깋寃곌낵 �뾾�뒗寃쎌슦
	}

	public int aliveTableWrite(String value, String classroom, int pcNumber) {
		String SQL = "UPDATE aliveTable SET ALIVE = ? WHERE CLASSROOM = ? and PCNUMBER = ?"; // 媛뺤쓽�떎怨�
																								// pc踰덊샇瑜�
																								// 李얠븘
																								// value媛�
																								// 蹂�寃�
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, value);
			pstmt.setString(2, classroom);
			pstmt.setInt(3, pcNumber);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // �뜲�씠�꽣踰좎씠�뒪 �삤瑜�
	}

	public Vector<MessageVO> getClassTable(int a) {

		Vector<MessageVO> dbResultSet = null;
		return dbResultSet;

	}

	public Vector<MessageVO> getRecentTable(String classroom) { // �꽆�뼱�삩 classroom 踰덊샇濡�
		// 理쒓렐classroom �뀒�씠釉� 議고쉶�썑
		// �씠�겢由쎌뒪 肄섏넄李� 異쒕젰
		int i = 0;
		Vector<MessageVO> dbResultSet = new Vector<MessageVO>();
		MessageVO dbResult;

		System.out.println("selectRecentTable working");
		String SQL = "SELECT * FROM RECENTTABLE WHERE CLASSROOM = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, classroom);

			ResultSet rs = pstmt.executeQuery();
			while (rs.next()) {
				dbResult = new MessageVO();
				int pcNumber = rs.getInt("pcNumber");
				String recentProcess = rs.getString("recentProcess");
				String time = rs.getString("time");
				int processCount = rs.getInt("processCount");
				System.out.println(
						classroom + " | " + pcNumber + " | " + recentProcess + " | " + processCount + " | " + time);
				dbResult.setClassroom(classroom);
				dbResult.setPcNumber(pcNumber);
				dbResult.setProcessName(recentProcess);
				dbResult.setTime(time);
				// System.out.println("dbResult: "+dbResult.getPcNumber());
				dbResultSet.add(i, dbResult);
				System.out.println(i + " dbResultSet : " + dbResultSet.get(i).getPcNumber());
				i++;

			}

		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("getRecentTable error");
			System.out.println(e);
		}

		return dbResultSet;
	}

	public Vector<MessageVO> getDetectTable(String classroom) { // �꽆�뼱�삩 classroom 踰덊샇濡�
		// 理쒓렐classroom �뀒�씠釉� 議고쉶�썑
		// �씠�겢由쎌뒪 肄섏넄李� 異쒕젰
		int i = 0;
		Vector<MessageVO> dbResultSet = new Vector<MessageVO>();
		MessageVO dbResult;

		System.out.println("selectRecentTable working");
		String SQL = "SELECT * FROM RECENTTABLE WHERE CLASSROOM = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, classroom);

			ResultSet rs = pstmt.executeQuery();
			while (rs.next()) {
				dbResult = new MessageVO();
				int pcNumber = rs.getInt("pcNumber");
				String recentProcess = rs.getString("recentProcess");
				String time = rs.getString("time");
				int processCount = rs.getInt("processCount");
				System.out.println(
						classroom + " | " + pcNumber + " | " + recentProcess + " | " + processCount + " | " + time);
				dbResult.setClassroom(classroom);
				dbResult.setPcNumber(pcNumber);
				dbResult.setProcessName(recentProcess);
				dbResult.setTime(time);
				// System.out.println("dbResult: "+dbResult.getPcNumber());
				dbResultSet.add(i, dbResult);
				System.out.println(i + " dbResultSet : " + dbResultSet.get(i).getPcNumber());
				i++;

			}

		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("getRecentTable error");
			System.out.println(e);
		}

		return dbResultSet;
	}

	public Vector<MessageVO> getRecentTableIntoXML() { // 紐⑤몢 媛��졇�삤湲�
		// 理쒓렐classroom �뀒�씠釉� 議고쉶�썑
		// �씠�겢由쎌뒪 肄섏넄李� 異쒕젰
		int i = 0;
		Vector<MessageVO> dbResultSet = new Vector<MessageVO>();
		MessageVO dbResult;

		System.out.println("getDetectTableIntoXML fun is working");
		String SQL = "SELECT * FROM RECENTTABLE";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			ResultSet rs = pstmt.executeQuery();
			while (rs.next()) {
				dbResult = new MessageVO();

				String classroom = rs.getString("classroom");
				int pcNumber = rs.getInt("pcNumber");
				String recentProcess = rs.getString("recentProcess");
				String time = rs.getString("time");
				int processCount = rs.getInt("processCount");

				System.out.println(
						classroom + " | " + pcNumber + " | " + recentProcess + " | " + processCount + " | " + time);

				dbResult.setClassroom(classroom);
				dbResult.setPcNumber(pcNumber);
				dbResult.setProcessName(recentProcess);
				dbResult.setTime(time);
				dbResult.setProcessCount(processCount);

				dbResultSet.add(i, dbResult);
				System.out.println(i + " dbResultSet : " + dbResultSet.get(i).getPcNumber());
				i++;

			}

		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("getRecentTable error");
			System.out.println(e);
		}

		return dbResultSet;
	}

	public int logTableWrite(String classroom, int pcNumber, String processName, String request) {
		String SQL = "INSERT INTO logTable VALUES (?, ?, ?, ?,?)"; // 媛뺤쓽�떎,
																	// PC踰덊샇,
																	// �봽濡쒖꽭�뒪, �떆媛�, �슂泥�
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, classroom);
			pstmt.setInt(2, pcNumber);
			pstmt.setString(3, processName);
			pstmt.setString(4, getTime());
			pstmt.setString(5, request);

			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // �뜲�씠�꽣踰좎씠�뒪 �삤瑜�
	}

	/* 감지 ON/OFF DB테이블 */
	public ArrayList<DetectControlVO> getDetectControlList() {
		String SQL = "SELECT * FROM DETECTCONTROLTABLE ORDER BY CLASSROOM ASC, PCNUMBER ASC";
		ArrayList<DetectControlVO> list = new ArrayList<DetectControlVO>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				DetectControlVO detectControl = new DetectControlVO();
				detectControl.setClassroom(rs.getString(1));
				detectControl.setPcNumber(rs.getInt(2));
				detectControl.setControl(rs.getInt(3));
				list.add(detectControl);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	public ArrayList<AliveMessageVO> getAliveList() {
		String SQL = "SELECT * FROM ALIVETABLE ORDER BY CLASSROOM ASC, PCNUMBER ASC";
		ArrayList<AliveMessageVO> list = new ArrayList<AliveMessageVO>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			while (rs.next()) {	
				AliveMessageVO aliveMessageVO = new AliveMessageVO();
				aliveMessageVO.setClassroom(rs.getString(1));
				aliveMessageVO.setPcNumber(rs.getInt(2));
				aliveMessageVO.setAlive(rs.getString(3));
				list.add(aliveMessageVO);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	public int detectControlTableWrite(String classroom, int pcNumber, int controlNumber) {
		String SQL = "UPDATE DETECTCONTROLTABLE SET CONTROL = ? WHERE classroom = ? and pcNumber = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, controlNumber);
			pstmt.setString(2, classroom);
			pstmt.setInt(3, pcNumber);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}
}
