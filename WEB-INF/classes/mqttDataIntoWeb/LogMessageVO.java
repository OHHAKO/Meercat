package mqttDataIntoWeb;

public class LogMessageVO {
	private String classroom; // 강의실
	private int pcNumber; // PC번호
	private String processName; // 프로세스이름
	private String time; // 이름
	private String request;


	public String getClassroom() {
		return classroom;
	}

	public void setClassroom(String classroom) {
		this.classroom = classroom;
	}

	public int getPcNumber() {
		return pcNumber;
	}

	public void setPcNumber(int pcNumber) {
		this.pcNumber = pcNumber;
	}

	public String getProcessName() {
		return processName;
	}

	public void setProcessName(String processName) {
		this.processName = processName;
	}

	public String getTime() {
		return time;
	}

	public void setTime(String time) {
		this.time = time;
	}

	public String getRequest(){
		return request;
	}
	public void setRequest(String request){
		this.request = request;
	}

}
