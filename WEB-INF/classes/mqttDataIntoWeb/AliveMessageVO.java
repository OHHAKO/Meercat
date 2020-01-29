package mqttDataIntoWeb;

public class AliveMessageVO {
	   private String classroom;   //강의실
	   private int pcNumber;		//PC번호
	   private String alive;
	   

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
	public String getAlive() {
		return alive;
	}
	public void setAlive(String alive) {
		this.alive = alive;
	}
	   
	
}
