import 'Task.dart';

class Todo{

  String name;
  String? tag;
  String status = "";
  List <Task> tasks = [];


    Todo(this.name, [String? tag]){
      this.tag = tag;
    }

    void addTask(Task task){
        tasks.add(task);
      }


    void printAllTask(){
      int num;
      if(this.tasks.isEmpty){
        print("Aucune tâche(s) ajouté(es)\n");
      }else{
        for(int i = 0; i < this.tasks.length; i++){
          num = i + 1;
          print('$num- <${this.tasks[i].printTask()}>\n');
        }
      }
    }

    void printLastTask(){
      if(this.tasks.isNotEmpty){
        print( tasks.length.toString() + "- " + tasks[tasks.length - 1].printTask());
      }
    }
    
    void removeTask(Task t){
      this.tasks.remove(t);
    }

    Task? findTask(int num){
      for(int i = 0; i < tasks.length; i++){
        if(i == (num - 1)){
          return tasks[i];
        }
      }
      return null;
    }

     
}