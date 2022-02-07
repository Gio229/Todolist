import 'dart:io';
import 'src/Todo.dart';
import 'src/Task.dart';

void main() {
  List<Todo> dataBase = [];

  print("\n[To do List]\n");
  printAllActivity(dataBase);
  printMenu();
  start(dataBase, choose());
}

void printMenu() {
  print(
      "\n----------****Menu****----------\n1- Ajouter une nouvelle activité\n2- Ajouter une nouvelle tâche à une activité\n3- Voir les activités ajoutées\n4- Voir les tâches d'une activité\n5- Modifier la durée passée sur une tâche\n6- Supprimer une tâche\n7- Supprimer une activité\n8- Ajouter/Retirer le tag d'importance d'une activité\n9- Ajouter/Retirer le tag d'importance d'une tâche\n10- Marqué une tâche comme terminé ou non\n11- Quitter\n----------************----------");
}

void start(List<Todo> dataBase, int choice) {
  switch (choice) {
    case 1:
      print("[Ajouter une activité]\n");
      if (createActivity(dataBase)) {
        print("Une nouvelle activité créé !");
        printLastActivity(dataBase);
      }
      printMenu();
      start(dataBase, choose());
      break;
    case 2:
      print("[Ajouter une tâche]");
      addingTask(dataBase);
      printMenu();
      start(dataBase, choose());
      break;
    case 3:
      printAllActivity(dataBase);
      printMenu();
      start(dataBase, choose());
      break;
    case 4:
      print("[Voir les tâches d'une activité]");
      printTasksActivity(dataBase);
      printMenu();
      start(dataBase, choose());
      break;
    case 5:
      print("[Modifié la durée d'une tâche]");
      modifyTaskTimeSpent(dataBase);
      printMenu();
      start(dataBase, choose());
      break;
    case 6:
      print("[Supprimer une tâche]");
      removeTaskActivity(dataBase);
      printMenu();
      start(dataBase, choose());
      break;
    case 7:
      print("[Supprimer une activité]");
      removeActivity(dataBase);
      printMenu();
      start(dataBase, choose());
      break;
    case 8:
      print("[Ajouter/Retirer le tag d'importance d'une activité]");
      TagOrUnTagActivity(dataBase);
      printMenu();
      start(dataBase, choose());
      break;
    case 9:
      print("[Ajouter/Retirer le tag d'importance d'une tâche]");
      TagOrUnTagTaskActivity(dataBase);
      printMenu();
      start(dataBase, choose());
      break;
    case 10:
      print("[Marqué une tâche comme terminé ou non]");
      markTaskTerminate(dataBase);
      printMenu();
      start(dataBase, choose());
      break;
    case 11:
      print("A la prochaine...");
      break;
    default:
      printMenu();
      start(dataBase, choose());
      break;
  }
}

int choose() {
  try {
    int choice;
    print("-->");
    choice = int.parse(stdin.readLineSync().toString());
    return choice;
  } catch (e) {
    print(
        "Une erreur est survenue. Vous avez surement due entrez des valeurs non conformes.");
  }
  return 0;
}

bool createActivity(List<Todo> dataBase) {
  String? name;
  print("Nom de l'activité : ");
  name = stdin.readLineSync().toString().toLowerCase();

  if (name.isEmpty) {
    createActivity(dataBase);
  } else {
    if (continuer("Etes vous sur de vouloir créer l'activité : <$name> ?")) {
      if(continuer("Marquer l'activité comme importante ?")){
        dataBase.add(new Todo(name.toUpperCase(), "important"));
      }else{
        dataBase.add(new Todo(name));
      }

      return true;
    }
  }

  return false;
}

bool continuer(String message) {
  String continue_;
  bool c = true;
  print("$message [y/n]\n-->");
  continue_ = stdin.readLineSync().toString().toUpperCase();
  if (continue_ != "Y" && continue_ != "N") {
    continuer(message);
  } else if (continue_ == "Y") {
    c = true;
  } else {
    c = false;
  }
  return c;
}

bool addingTask(List<Todo> dataBase) {
  if (dataBase.isEmpty) {
    print(
        "Aucune activité n'existe donc vous ne pouvez effectuer cette requête.");
  } else {
    print("\nActivités disponibles\n");
    printAllActivity(dataBase);
    print("Entrez le numéro de l'activité");
    int choice = choose();
    if (choice > 0 && choice <= dataBase.length) {
      Todo? activity = findActivity(dataBase, choice);
      if (activity != null) {
        print("Ajouter une tâche à : <" + activity.name + ">\n-->");
        print('Nom de la tâche : ');
        String taskName = stdin.readLineSync().toString();
        print('Durée de la tâche : ');
        String taskTime = stdin.readLineSync().toString();
        if (taskName.isEmpty || taskTime.isEmpty) {
          print("Renseigner des valeurs conformes");
          addingTask(dataBase);
        } else {
          if (continuer(
              "Etes vous sur de vouloir ajouter la tâche : <$taskName> à l'activité : <" +
                  activity.name +
                  "> ?")) {
            activity.addTask(new Task(taskName, taskTime));
            verifyActivityTerminate(dataBase);
            activity.printLastTask();
            return true;
          }
        }
      }
    }
  }
  return false;
}

void printLastActivity(List<Todo> dataBase) {
  if (dataBase.isNotEmpty) {
    print("\n" +
        dataBase.length.toString() +
        "- " +
        dataBase[dataBase.length - 1].name);
  }
}

void printAllActivity(List<Todo> dataBase) {
  int num;
  if (dataBase.isEmpty) {
    print("Aucune activité ajoutée\n");
  } else {
    print("N° | Nom de l'activité   ");
    print("***|*******************************");
    for (int i = 0; i < dataBase.length; i++) {
      num = i + 1;
      
      print('$num- |<${dataBase[i].name}> ---> ${(dataBase[i].terminate == true) ?"Terminé" : "Non terminé"}');
      print("***|*******************************|");
    }
  }
}

void printTasksActivity(List<Todo> dataBase) {
  if (dataBase.isEmpty) {
    print(
        "Aucune activité n'existe donc vous ne pouvez effectuer cette requête.");
  } else {
    print("\nActivités disponibles\n");
    printAllActivity(dataBase);
    print("Entrez le numéro de l'activité");
    int choice = choose();
    if (choice > 0 && choice <= dataBase.length) {
      Todo? activity = findActivity(dataBase, choice);
      if (activity != null) {
        activity.printAllTask();
      } else {
        print("Aucune activité ne porte ce numéro");
      }
    }
  }
}

Todo? findActivity(List<Todo> dataBase, int num) {
  for (int i = 0; i < dataBase.length; i++) {
    if (i == (num - 1)) {
      return dataBase[i];
    }
  }
  return null;
}

bool removeTaskActivity(List<Todo> dataBase) {
  if (dataBase.isEmpty) {
    print(
        "Aucune activité n'existe donc vous ne pouvez effectuer cette requête.");
  } else {
    print("\nActivités disponibles\n");
    printAllActivity(dataBase);
    print("Entrez le numéro de l'activité");
    int choice = choose();
    if (choice > 0 && choice <= dataBase.length) {
      Todo? activity = findActivity(dataBase, choice);
      if (activity != null) {
        print("Activité : <" + activity.name + '>');
        print("\nTâches disponibles\n");
        activity.printAllTask();

        if (continuer("Etes vous sur de vouloir continuer ?")) {
          print("Entrez le numéro de la tâche");
          int choice = choose();
          if (choice > 0 && choice <= activity.tasks.length) {
            Task? task = activity.findTask(choice);
            if (task != null) {
              // print("Êtes-vous sûre de vouloir supprimer la tâche : <" + task.printTask() + '>');
              if (continuer("Etes vous sur de vouloir supprimer la tâche : <" +
                  task.printTask() +
                  '>')) {
                activity.removeTask(task);
                print("Succès de la suppression !");
                return true;
              }
            } else {
              print("Il n'existe de tâche à ce numéro");
            }
          }
        }
      }
    }
  }
  return false;
}

bool modifyTaskTimeSpent(List<Todo> dataBase) {
  if (dataBase.isEmpty) {
    print(
        "Aucune activité n'existe donc vous ne pouvez effectuer cette requête.");
  } else {
    print("\nActivités disponibles\n");
    printAllActivity(dataBase);
    print("Entrez le numéro de l'activité");
    int choice = choose();
    if (choice > 0 && choice <= dataBase.length) {
      Todo? activity = findActivity(dataBase, choice);
      if (activity != null) {
        print("Activité : <" + activity.name + '>');
        print("\nTâches disponibles\n");
        activity.printAllTask();

        if (continuer("Etes vous sur de vouloir continuer ?")) {
          print("Entrez le numéro de la tâche");
          int choice = choose();
          if (choice > 0 && choice <= activity.tasks.length) {
            Task? task = activity.findTask(choice);
            if (task != null) {
              // print("Voulez-vous mettre à jour le temps passé sur cette tâche ?\n <" + task.printTask() + '>');
              if (continuer(
                  "Voulez-vous mettre à jour le temps passé sur cette tâche ?\n <" +
                      task.printTask() +
                      '>')) {
                print('Entrez le temps que vous avez passé sur cette tâche : ');
                task.modifyTimeSpent(stdin.readLineSync().toString());
                print("Temps passé modifié avec succès !");
                print(task.printTask());
                return true;
              }
            } else {
              print("Il n'existe de tâche à ce numéro");
            }
          }
        }
      }
    }
  }
  return false;
}

bool removeActivity(List<Todo> dataBase) {
  if (dataBase.isEmpty) {
    print(
        "Aucune activité n'existe donc vous ne pouvez effectuer cette requête.");
  } else {
    print("\nActivités disponibles\n");
    printAllActivity(dataBase);
    print("Entrez le numéro de l'activité");
    int choice = choose();
    if (choice > 0 && choice <= dataBase.length) {
      Todo? activity = findActivity(dataBase, choice);
      if (activity != null) {
        // print("Voulez-vous vraiment supprimer l'activité : <" + activity.name + '>');
        if (continuer("Voulez-vous vraiment supprimer l'activité : <" +
            activity.name +
            '>')) {
          dataBase.remove(activity);
          print("Succès de la suppression !");
          return true;
        }
      }
    }
  }
  return false;
}

void TagOrUnTagActivity(List<Todo> dataBase){

  if (dataBase.isEmpty) {
    print("Aucune activité n'existe donc vous ne pouvez effectuer cette requête.");
  } else {
    print("\nActivités disponibles\n");
    printAllActivity(dataBase);
    print("Entrez le numéro de l'activité");
    int choice = choose();
    if (choice > 0 && choice <= dataBase.length) {
      Todo? activity = findActivity(dataBase, choice);
      if (activity != null) {
        if(activity.tag == null){
          if(continuer("Voulez-vous marquer cette activité comme importante")){
            activity.tag = "important";
            activity.name = activity.name.toUpperCase();
            print("Activité marquer comme importante.");
          }
        }else{
          if(continuer("Voulez-vous retirer la marque importante de cette activité")){
            activity.tag = null;
            activity.name = activity.name.toLowerCase();
            print("Marque retiré.");
          }
        }
      } else {
        print("Aucune activité ne porte ce numéro");
      }
      
    }
  }

}

void markTaskTerminate(List<Todo> dataBase) {

  if (dataBase.isEmpty) {
    print(
        "Aucune activité n'existe donc vous ne pouvez effectuer cette requête.");
  } else {
    print("\nActivités disponibles\n");
    printAllActivity(dataBase);
    print("Entrez le numéro de l'activité");
    int choice = choose();
    if (choice > 0 && choice <= dataBase.length) {
      Todo? activity = findActivity(dataBase, choice);
      if (activity != null) {
        print("Activité : <" + activity.name + '>');
        print("\nTâches disponibles\n");
        activity.printAllTask();
        if (activity.tasks.isNotEmpty) {
          if (continuer("Etes vous sur de vouloir continuer ?")) {
            print("Entrez le numéro de la tâche");
            int choice = choose();
            if (choice > 0 && choice <= activity.tasks.length) {
              Task? task = activity.findTask(choice);
              if (task != null) {

                if(task.status != task.possibleStatus['end'].toString()){
                  if(continuer("Voulez-vous marquer cette tâche comme terminé")){
                    task.status = task.possibleStatus['end'].toString();
                    verifyActivityTerminate(dataBase);
                    print("Tâche marquer comme terminé.");
                  }
                }else{
                  if(continuer("Voulez-vous marquer cette tâche comme non terminé")){
                    task.status = task.possibleStatus['in'].toString();
                    verifyActivityTerminate(dataBase);
                    print("Tâche marqué \"en cours\".");
                  }
                }

              }
            }
          }
        }
      }
    }
  }

}

void verifyActivityTerminate(List<Todo> dataBase) {
  bool term = true;
  for (int i = 0; i < dataBase.length; i++) {
    if (dataBase[i].tasks.isNotEmpty) {
      for (int j = 0; j < dataBase[i].tasks.length; j++) {
        if (dataBase[i].tasks[j].status != dataBase[i].tasks[j].possibleStatus['end'].toString()) {
          term = false;
        }
      }
      if (term) {
        dataBase[i].terminate = true;
      } else {
        dataBase[i].terminate = false;
      }
    }
  }
}

void TagOrUnTagTaskActivity(List<Todo> dataBase){
  if (dataBase.isEmpty) {
    print(
        "Aucune activité n'existe donc vous ne pouvez effectuer cette requête.");
  } else {
    print("\nActivités disponibles\n");
    printAllActivity(dataBase);
    print("Entrez le numéro de l'activité");
    int choice = choose();
    if (choice > 0 && choice <= dataBase.length) {
      Todo? activity = findActivity(dataBase, choice);
      if (activity != null) {
        print("Activité : <" + activity.name + '>');
        print("\nTâches disponibles\n");
        activity.printAllTask();
        if (activity.tasks.isNotEmpty) {
          if (continuer("Etes vous sur de vouloir continuer ?")) {
            print("Entrez le numéro de la tâche");
            int choice = choose();
            if (choice > 0 && choice <= activity.tasks.length) {
              Task? task = activity.findTask(choice);
              if (task != null) {


                if(task.tag == null){
                  if(continuer("Voulez-vous marquer cette tâche comme importante")){
                    task.tag = "important";
                    task.name = task.name.toUpperCase();
                    print("Tâche marqué comme importante.");
                  }
                }else{
                  if(continuer("Voulez-vous retirer la marque importante de cette tâche")){
                    task.tag = null;
                    task.name = task.name.toLowerCase();
                    print("Marque retiré.");
                  }
                }

              }
            }
          }
        }
      }
    }
  }
}