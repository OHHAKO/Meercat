package helper;

import org.eclipse.paho.client.mqttv3.IMqttDeliveryToken;
import org.eclipse.paho.client.mqttv3.MqttCallback;
import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttConnectOptions;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.eclipse.paho.client.mqttv3.MqttMessage;
import org.eclipse.paho.client.mqttv3.persist.MemoryPersistence;

import dao.MessageDAO;

public class MqttConnectionHelper implements MqttCallback {
	public interface OnConnectionListener {
		void connectionLost(String message);

		void deliveryComplete();
	}

	private OnConnectionListener listener;

	public MqttConnectionHelper() {
		runClient();
	}

	public void setOnConnectionListener(OnConnectionListener listener) {
		this.listener = listener;
	}

	MqttClient myClient;
	MqttConnectOptions connOpt;
	public static MessageDAO messageDAO; // db연결

	String topic;

	static final String BROKER_URL = "tcp://113.198.84.66:1883"; //접근하려는  broker의 ip:port
	static final String M2MIO_DOMAIN = "hansung";
	static final String M2MIO_STUFF = "1floor";
	static final String M2MIO_THING = "102/11";
	static final String M2MIO_USERNAME = "hansol";
	static final String M2MIO_PASSWORD_MD5 = "1234";
	private static String myTopic;
	private static String[] topicArray;
	private static String[] messageArray;

	static final Boolean subscriber = true;

	public MqttConnectionHelper getInstance() {
		return this;
	}

	public void init() {
		System.out.println("접속정보 초기화");
		messageDAO = new MessageDAO();
		connOpt = new MqttConnectOptions();
	}

	public void connectionSetup() {
		System.out.println("연결정보 설정");
		connOpt.setCleanSession(true); // 무슨 메소드인지 확인
		connOpt.setKeepAliveInterval(120); // 무슨 메소드인지 확인
		connOpt.setUserName(M2MIO_USERNAME); // hansol
		connOpt.setPassword(M2MIO_PASSWORD_MD5.toCharArray()); // 1234
	}

	public void subscribe() throws MqttException {
		System.out.println("구독설정");
		myTopic = M2MIO_DOMAIN + "/" + "#";
		// MqttTopic topic = myClient.getTopic(myTopic);

		// subscribe to topic if subscriber
		if (subscriber) {
			int subQoS = 2;
			myClient.subscribe(myTopic, subQoS);
			System.out.println("subscribe Start!");

		}
	}

	public void runClient() {
		// setup MQTT Client
		init();
		connectionSetup();

		System.out.println("setup Mqtt Client Success");
		// Connect to Broker
		try {
			mqttClientConnection();
			subscribe();
		} catch (MqttException e) {
			System.out.println("ERROR");
			e.printStackTrace();
			System.exit(-1);
		}

		
		// 이렇게 해서 init, connection, subscribe별로 에러처리 따로하기
		// 단위를 최대로 쪼개기
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
		// try {
		// wait to ensure subscribed messages are delivered
		// if (subscriber) {
		// Thread.sleep(5000);
		// }
		// myClient.disconnect();
		// } catch (Exception e) {
		// e.printStackTrace();
		// }
	}

	public void mqttClientConnection() throws MqttException {
		System.out.println("CONNECTION");
		myClient = new MqttClient(BROKER_URL, M2MIO_THING, new MemoryPersistence());
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

				System.out.println("-------------------------------------------------");
				System.out.println("| Topic:" + topic);
				System.out.println("| Message: " + new String(message.getPayload()));
				System.out.println("-------------------------------------------------");
			}

			public void deliveryComplete(IMqttDeliveryToken token) {
				// TODO Auto-generated method stub
			}
		});
	}

	public void setTopic(String topic) {
		this.topic = topic;
	}


	public String getTopic() {
		return this.topic;
	}

	

	@Override
	public void connectionLost(Throwable arg0) {
		// TODO Auto-generated method stub
		listener.connectionLost(arg0.getMessage());
	}

	@Override
	public void deliveryComplete(IMqttDeliveryToken arg0) {
		// TODO Auto-generated method stub
		listener.deliveryComplete();
	}

	@Override
	public void messageArrived(String arg0, MqttMessage arg1) throws Exception {
		// TODO Auto-generated method stub

	}

}
