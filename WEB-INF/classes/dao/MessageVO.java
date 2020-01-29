package dao;

public class MessageVO {

   private String classroom;   //강의실
   private int detectNumber;   //
   private int pcNumber;		//PC번호
   private String processName;	//프로세스이름
   private String time;			//이름
   private int processCount; 
   private String command;
   
   
   public String getClassroom() {
      return classroom;
   }
   
   public void setClassroom(String classroom) {
      this.classroom = classroom;
   }

   public int getDetectNumber() {
      return detectNumber;
   }

   public void setDetectNumber(int detectNumber) {
      this.detectNumber = detectNumber;
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
   
   public int getProcessCount(){
	   return processCount;
   }
   
   public void setProcessCount(int processCount){
	   this.processCount = processCount;
   }
   
   public String getCommand(){
	   return command;
   }
   
   public void setCommand(String command){
	   this.command = command;
   }
   
   
   
}