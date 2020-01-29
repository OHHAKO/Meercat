package mqttSubscriber;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

import helper.MqttConnectionHelper;
import helper.MqttConnectionHelper.OnConnectionListener;

@WebListener
public class ServerListener implements ServletContextListener {

	public ServerListener() {
		System.out.println("서버 생성 시작");
	}

	@Override
	public void contextInitialized(ServletContextEvent sce) { // 웹어플리케이션 실행시 호출
		System.out.println("서버가 시작되었습니다.");
		MqttConnectionHelper helper = new MqttConnectionHelper();
		helper.setOnConnectionListener(new OnConnectionListener() {
			
			@Override
			public void deliveryComplete() {
				// TODO Auto-generated method stub
				System.out.println("delivery Complete");
			}
			
			@Override
			public void connectionLost(String message) {
				// TODO Auto-generated method stub
				System.out.println("CONNECTION LOST : " + message);
			}
		});

	}

	@Override
	public void contextDestroyed(ServletContextEvent sce) {
		System.out.println("서버가 종료되었습니다.");
	}

}
