public with sharing class CreateTask {
    public String Subject{get; set;}
    public String Description{get; set;}
    public String Status{get; set;}
    public Id OwnerId{get; set;}

    public void addDescription(String str){
        this.Description += str;
    }
    public void addLnDescription(String str){
        this.Description += str + '\n';
    }

    public void createTask(){
        Task task = new Task(
            OwnerId = this.OwnerId,
            Description = this.Description
            );
        insert task;
    }
}