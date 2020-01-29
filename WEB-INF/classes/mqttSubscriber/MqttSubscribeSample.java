package mqttSubscriber;

import java.sql.Connection;
import java.sql.ResultSet;

import org.eclipse.paho.client.mqttv3.IMqttDeliveryToken;
import org.eclipse.paho.client.mqttv3.MqttCallback;
import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttConnectOptions;
import org.eclipse.paho.client.mqttv3.MqttDeliveryToken;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.eclipse.paho.client.mqttv3.MqttMessage;
import org.eclipse.paho.client.mqttv3.persist.MemoryPersistence;

import dao.MessageDAO;

public class MqttSubscribeSample implements MqttCallback {

	MqttClient myClient;
	MqttConnectOptions connOpt;
	public static MessageDAO messageDAO = new MessageDAO(); // db연결
	
	
	private Connection conn = null;
	private ResultSet rs = null;

	private static MqttSubscribeSample mqttObj = new MqttSubscribeSample();
	String topic, btId;

	static final String BROKER_URL = "tcp://113.198.84.66:1883"; //borker의 ip번호
	static final String M2MIO_DOMAIN = "hansung";
	static final String M2MIO_STUFF = "1floor";
	static final String M2MIO_THING = "102/11";
	static final String M2MIO_USERNAME = "hansol";
	static final String M2MIO_PASSWORD_MD5 = "1234";
	private String myTopic;
	private String[] topicArray;
	private String[] messageArray;

	public void MqttSubscribeSample() {

		System.out.println(" MqttSubscribeSample 객체가 생성되었습니다.");
	}

	public static MqttSubscribeSample getInstance() {
		return mqttObj;
	}

	public void setTopic(String topic) {
		this.topic = topic;
	}

	public void setBtId(String btId) {
		this.btId = btId;
	}

	public String getTopic() {
		return this.topic;
	}

	public String getBtid() {
		return this.btId;
	}

	// the following two flags control whether this example is a publisher, a
	// subscriber or both
	static final Boolean subscriber = true;
	// static final Boolean publisher = true;

	public void connectionLost(Throwable t) {
		System.out.println("Connection lost!");
		// code to reconnect to the broker would go here if desired
	}

	/**
	 * 
	 * deliveryComplete This callback is invoked when a message published by
	 * this client is successfully received by the broker.
	 * 
	 */

	public void deliveryComplete(MqttDeliveryToken token) {
		try {
			System.out.println("Pub complete" + new String(token.getMessage().getPayload()));
		} catch (MqttException e) {

			e.printStackTrace();
		}
	}

	/**
	 * 
	 * messageArrived This callback is invoked when a message is received on a
	 * subscribed topic.
	 * 
	 */

	/**
	 * 
	 * runClient The main functionality of this simple example. Create a MQTT
	 * client, connect to broker, pub/sub, disconnect.
	 * 
	 */
	public void runClient() {

		// setup MQTT Client
		String clientID = M2MIO_THING; // 102/11
		connOpt = new MqttConnectOptions();

		connOpt.setCleanSession(true); // 무슨 메소드인지 확인
		connOpt.setKeepAliveInterval(120); // 무슨 메소드인지 확인
		connOpt.setUserName(M2MIO_USERNAME); // hansol
		connOpt.setPassword(M2MIO_PASSWORD_MD5.toCharArray()); // 1234
		System.out.println("setup Mqtt Client Success");
		// Connect to Broker
		try {
			myClient = new MqttClient(BROKER_URL, clientID, new MemoryPersistence());
			System.out.println("CONNECTION");
			myClient.connect(connOpt);

			myClient.setCallback(new MqttCallback() {

				public void connectionLost(Throwable cause) {
					// TODO Auto-generated method stub
				}

				public void messageArrived(String topic, MqttMessage message) throws Exception {
					topicArray = topic.split("/"); // '/'으로 분리

					String command = topicArray[1];

					String classroom = topicArray[3]; // classroom 저장
					int pcNumber = Integer.parseInt(topicArray[4]); // pcNumber
																	// 저장

					if (command.equals("creationDetect")) { // 프로세스 생성 시 메시지

						String messageString = message.toString(); // Mqtt ->
																	// String으로
																	// 전환
						messageArray = messageString.split(";"); //

						int processCount = Integer.parseInt(messageArray[0]); // 미허용
																				// 프로세스
																				// 실행된
																				// 갯수
																				// 저장
						String recentProcess = messageArray[1]; // 최근 프로세스 저장

						for (int i = 1; i < messageArray.length; i++) {
							messageDAO.detectTableWrite(classroom, pcNumber, messageArray[i]);
							messageDAO.logTableWrite(classroom, pcNumber,messageArray[i],"creation");
							System.out.println("ww");
						}
						messageDAO.recentTableWrite(classroom, pcNumber, recentProcess, processCount);
						
					}

					else if (command.equals("alive")) { // 프로그램 사용여부 확인
						String aliveValue = message.toString(); // Mqtt ->
																// String으로 전환 y
																// or n값
						messageArray = aliveValue.split(";");
						messageDAO.aliveTableWrite(messageArray[0], classroom, pcNumber);
					}

					else if (command.equals("deletionDetect")) { // 프로세스 종료 시
																	// 메시지
						String messageString = message.toString(); // Mqtt ->
																	// String으로
																	// 전환
						messageArray = messageString.split(";"); // 세미콜론으로 분리

						int processCount = Integer.parseInt(messageArray[0]); // 미허용
																				// 프로세스
																				// 실행된
																				// 갯수
																				// 저장

						for (int i = 1; i < messageArray.length; i++) {
							messageDAO.detectTableDelete(classroom, pcNumber, messageArray[i]);
							messageDAO.recentTableDelete(classroom, pcNumber, messageArray[i], processCount);
							messageDAO.logTableWrite(classroom, pcNumber,messageArray[i],"deletion");
						}
					}

					System.out.println("---------------------------------------");
					System.out.println("| Topic:" + topic);
					System.out.println("| Message: " + new String(message.getPayload()));
					System.out.println("-------------------------------------------------");
				}

				public void deliveryComplete(IMqttDeliveryToken token) {
					// TODO Auto-generated method stub
				}
			});
		} catch (MqttException e) {
			System.out.println("ERROR");
			e.printStackTrace();
			System.exit(-1);
		}

		System.out.println("Connected to " + BROKER_URL);

		// setup topic
		// topics on m2m.io are in the form <domain>/<stuff>/<thing>
		myTopic = M2MIO_DOMAIN + "/" + "#";
		// MqttTopic topic = myClient.getTopic(myTopic);

		// subscribe to topic if subscriber
		if (subscriber) {
			try {
				int subQoS = 2;
				myClient.subscribe(myTopic, subQoS);
				System.out.println("subscribe Start!");
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		// publish messages if publisher
		/*
		 * if (publisher) { for (int i=1; i<=10; i++) { String pubMsg =
		 * "{\"pubmsg\":" + i + "}"; int pubQoS = 0; MqttMessage message = new
		 * MqttMessage(pubMsg.getBytes()); message.setQos(pubQoS);
		 * message.setRetained(false);
		 * 
		 * // Publish the message System.out.println("Publishing to topic \"" +
		 * topic + "\" qos " + pubQoS); MqttDeliveryToken token = null; try { //
		 * publish message to broker token = topic.publish(message); // Wait
		 * until the message has been delivered to the broker
		 * token.waitForCompletion(); Thread.sleep(100); } catch (Exception e) {
		 * e.printStackTrace(); } } }
		 */

		// disconnect
		try {
			// wait to ensure subscribed messages are delivered
			if (subscriber) {
				// Thread.sleep(5000);
			}
			// myClient.disconnect();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void deliveryComplete(IMqttDeliveryToken token) {
		// TODO Auto-generated method stub

	}

	public void messageArrived(String topic, MqttMessage message) throws Exception {
		// TODO Auto-generated method stub

	}
	
	
//	
//	public void dbConnect() { // 생성자에서 db연결
//		try {
//			String dbURL = "jdbc:mysql://localhost:3306/mqttdb?serverTimezone=UTC";
//			String dbID = "root";
//			String dbPassword = "0000";
//			Class.forName("com.mysql.cj.jdbc.Driver");
//			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
//			
//			System.out.println("dbConnect 연결 성공");
//		} catch (Exception e) {
//			e.printStackTrace();
//			System.out.println("db연결 실패");
//			System.out.println(e);
//
//		}
//	}  
	
	/*
	public String inputAliveTable(String classroom, int pcNumber) {
		String SQL2 = "INSERT INTO alivetable values(?,?,'1')";
		String SQL = "INSERT INTO aliveTable values('"+classroom+"','"+pcNumber+"',1)";
		String sql3 = "INSERT INTO aliveTable values('104',2,'1')";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sql3);
			//pstmt.setString(1,classroom);
			//pstmt.setInt(2,3);
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println(" inputRecentTable db fail");
			System.out.println(e);
		}
		return "fidn"; // 데이터베이스 오류
	}*/

	
}