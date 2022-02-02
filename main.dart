import 'dart:io';
import 'src/ToDo.dart';
import 'src/Task.dart';

void main(){

  List <ToDo> dataBase = [];

  print("\n[To do List]\n");
  printAllActivity(dataBase);
  printMenu();
  start(dataBase, choose());
}

void printMenu(){
  print("\n----------****Menu****----------\n1- Ajouter une nouvelle activité\n2- Ajouter une nouvelle tâche à une activité\n3- Voir les activités ajoutées\n4- Voir les tâches d'une activité\n5- Modifier la durée passé sur une tâche\n6- Supprimer une tâche\n7- Supprimer une activité\n8- Quitter\n----------************----------");
}

void start(List <ToDo> dataBase, int choice){

  switch(choice){
    case 1: print("[Ajouter une activité]\n");
      if(createActivity(dataBase)){
        print("Une nouvelle activité créé !");
        printLastActivity(dataBase);
      }
      printMenu();
      start(dataBase, choose());
    break;
    case 2: print("[Ajouter une tâche]");
      addingTask(dataBase);
      printMenu();
      start(dataBase, choose());
    break;
    case 3: print("ok");
      printAllActivity(dataBase);
      printMenu();
      start(dataBase, choose());
    break;
    case 4: print("[Voir les tâches d'une activité]");
      printTasksActivity(dataBase);
      printMenu();
      start(dataBase, choose());
    break;
    case 5: print("[Modifié la durée d'une tâche]");
      modifyTaskTimeSpent(dataBase);
      printMenu();
      start(dataBase, choose());
    break;
    case 6: print("[Supprimer une tâche]");
      removeTaskActivity(dataBase);
      printMenu();
      start(dataBase, choose());
    break;
    case 7: print("[Supprimer une activité]");
      removeActivity(dataBase);
      printMenu();
      start(dataBase, choose());
    break;
    case 8: print("A la prochaine...");
    break;
    default:
      printMenu();
      start(dataBase, choose());
    break;
  }

}

int choose(){
  try{
    int choice;
    print("-->");
    choice = int.parse(stdin.readLineSync().toString());
    return choice;
  }catch(e){
    print("Une erreur est survenue. Vous avez surement due entrez des valeurs non conformes.");
  }
  return 0;
}

bool createActivity(List <ToDo> dataBase){

  String? name;
  print("Nom de l'activité : ");
  name = stdin.readLineSync().toString();
  
  if(name.isEmpty){
    createActivity(dataBase);
  }else{
    if(continuer()){
      dataBase.add(new ToDo(name));
      return true;
    }
  }

  return false;

}

bool continuer(){
  String continue_;
  print("voulez-vous continuer ? [0/1]\n-->");
  continue_ = stdin.readLineSync().toString();
  if(continue_ != "0" && continue_ != "1"){
    continuer();
  }else if(continue_ == "1"){
    return true;
  }
  return false;
}

bool addingTask(List <ToDo> dataBase){

  if(dataBase.isEmpty){
    print("Aucune activité n'existe donc vous ne pouvez effectuer cette requête.");
  }else{
    print("Entrez le numéro de l'activité");
    int choice = choose();
    if(choice > 0 && choice <= dataBase.length ){
      ToDo? activity = findActivity(dataBase, choice);
      if(activity != null){
        print("Ajouter une tâche à : <" + activity.name + ">\n-->");
        print('Nom de la tâche : ');
        String taskName = stdin.readLineSync().toString();
        print('Durée de la tâche : ');
        String taskTime = stdin.readLineSync().toString();
        if(taskName.isEmpty || taskTime.isEmpty){
          print("Renseigner des valeurs conformes");
          addingTask(dataBase);
        }else{
          if(continuer()){
            activity.addTask(new Task(taskName, taskTime));
            activity.printLastTask();
            return true;
          }
        }
      }
    }
  }
  return false;
}

void printLastActivity(List <ToDo> dataBase){
  if(dataBase.isNotEmpty){
    print("\n" + dataBase.length.toString() + "- " + dataBase[dataBase.length - 1].name);
  }
}

void printAllActivity(List <ToDo> dataBase){
  int num;
  if(dataBase.isEmpty){
    print("Aucune activité(s) ajouté(es)\n");
  }else{
    for(int i = 0; i < dataBase.length; i++){
      num = i + 1;
      print('$num- <${dataBase[i].name}>\n');
    }
  }
}

void printTasksActivity(List <ToDo> dataBase){

  if(dataBase.isEmpty){
    print("Aucune activité n'existe donc vous ne pouvez effectuer cette requête.");
  }else{
    print("Entrez le numéro de l'activité");
    int choice = choose();
    if(choice > 0 && choice <= dataBase.length ){
      ToDo? activity = findActivity(dataBase, choice);
      if(activity != null){
        activity.printAllTask();
      }else{
        print("Aucune activité ne porte ce numéro");
      }
    }
  }

}

ToDo? findActivity(List <ToDo> dataBase, int num){
  for(int i = 0; i < dataBase.length; i++){
    if(i == (num - 1)){
      return dataBase[i];
    }
  }
  return null;
}

bool removeTaskActivity(List <ToDo> dataBase){
  if(dataBase.isEmpty){
    print("Aucune activité n'existe donc vous ne pouvez effectuer cette requête.");
  }else{
    print("Entrez le numéro de l'activité");
    int choice = choose();
    if(choice > 0 && choice <= dataBase.length ){
      ToDo? activity = findActivity(dataBase, choice);
      if(activity != null){
        print("Activité : <" + activity.name + '>');
        activity.printAllTask();

        if(continuer()){
          print("Entrez le numéro de la tâche");
          int choice = choose();
          if(choice > 0 && choice <= activity.tasks.length ){
            Task? task = activity.findTask(choice);
            if(task != null){
              print("Êtes-vous sûre de vouloir supprimer la tâche : <" + task.printTask() + '>');
              if(continuer()){
                activity.removeTask(task);
                print("Succès de la suppression !");
                return true;
              }
            }else{
              print("Il n'existe de tâche à ce numéro");
            }
          }
        }
        
      }
    }
  }
  return false;
}

bool modifyTaskTimeSpent(List <ToDo> dataBase){

    if(dataBase.isEmpty){
    print("Aucune activité n'existe donc vous ne pouvez effectuer cette requête.");
  }else{
    print("Entrez le numéro de l'activité");
    int choice = choose();
    if(choice > 0 && choice <= dataBase.length ){
      ToDo? activity = findActivity(dataBase, choice);
      if(activity != null){
        print("Activité : <" + activity.name + '>');
        activity.printAllTask();

        if(continuer()){
          print("Entrez le numéro de la tâche");
          int choice = choose();
          if(choice > 0 && choice <= activity.tasks.length ){
            Task? task = activity.findTask(choice);
            if(task != null){
              print("Voulez-vous mettre à jour le temps passé sur cette tâche ?\n <" + task.printTask() + '>');
              if(continuer()){
                print('Entrez le temps que vous avez passez sur cette tâche : ');
                task.modifyTimeSpent(stdin.readLineSync().toString());
                print("Temps passé modifié avec succès !");
                print(task.printTask());
                return true;
              }
            }else{
              print("Il n'existe de tâche à ce numéro");
            }
          }
        }
        
      }
    }
  }
  return false;
}

bool removeActivity(List <ToDo> dataBase){
  if(dataBase.isEmpty){
    print("Aucune activité n'existe donc vous ne pouvez effectuer cette requête.");
  }else{
    print("Entrez le numéro de l'activité");
    int choice = choose();
    if(choice > 0 && choice <= dataBase.length ){
      ToDo? activity = findActivity(dataBase, choice);
      if(activity != null){
        print("Voulez-vous vraiment supprimer l'activité : <" + activity.name + '>');
        if(continuer()){
            dataBase.remove(activity);
            print("Succès de la suppression !");
            return true;
          }
      }
    }
  }
  return false;
}
