import 'dart:io';
import 'src/Todo.dart';
import 'src/Task.dart';

void main() {
  //Declaration d'une list
  List<Todo> dataBase = [];

  print("\n[To do List]\n");
  //affichage du contenu de la liste
  printAllActivity(dataBase);
  //Appel du menu
  printMenu();
  //Appel de la methode start qui prend en parametre la list et le choix.
  start(dataBase, choose());
}

//Methode permettant d'afficher le menu
void printMenu() {
  print(
      "\n----------****Menu****----------\n1- Ajouter une nouvelle activité\n2- Ajouter une nouvelle tâche à une activité\n3- Voir les activités ajoutées\n4- Voir les tâches d'une activité\n5- Modifier la durée passée sur une tâche\n6- Supprimer une tâche\n7- Supprimer une activité\n8- Ajouter/Retirer le tag d'importance d'une activité\n9- Ajouter/Retirer le tag d'importance d'une tâche\n10- Marqué une tâche comme terminé ou non\n11- Quitter\n----------************----------");
}

//Methode start qui permet d'excuter une methode en fonction du choix de l'utilisateur
void start(List<Todo> dataBase, int choice) {
  switch (choice) {                             //Cas ou choix est :
    case 1:                                     // 1 - Ajouter une activité
      print("[Ajouter une activité]\n");
      if (createActivity(dataBase)) {           //Creation de l'activité
        print("Une nouvelle activité créé !");
        printLastActivity(dataBase);
      }
      printMenu();
      start(dataBase, choose());
      break;
    case 2:                                   // 2 - Ajouter une tâche
      print("[Ajouter une tâche]");
      addingTask(dataBase);
      printMenu();
      start(dataBase, choose());
      break;
    case 3:                                  // 3 - Voir les activités ajoutées
      printAllActivity(dataBase);
      printMenu();
      start(dataBase, choose());
      break;
    case 4:                                 // 4 - Voir les taches d'une activité 
      print("[Voir les tâches d'une activité]");
      printTasksActivity(dataBase);
      printMenu();
      start(dataBase, choose());
      break;
    case 5:                                 // 5 - Modifieé la durée d'une tâche 
      print("[Modifié la durée d'une tâche]");
      modifyTaskTimeSpent(dataBase);
      printMenu();
      start(dataBase, choose());
      break;
    case 6:                                 // 6 - Supprimer une tâche
      print("[Supprimer une tâche]");
      removeTaskActivity(dataBase);
      printMenu();
      start(dataBase, choose());
      break;
    case 7:                                  // 7 - Supprimer une activité
      print("[Supprimer une activité]");
      removeActivity(dataBase);
      printMenu();
      start(dataBase, choose());
      break;
    case 8:                                   // 8 - Ajouter ou retirer le tag d'une activité
      print("[Ajouter/Retirer le tag d'importance d'une activité]");
      TagOrUnTagActivity(dataBase);
      printMenu();
      start(dataBase, choose());
      break;
    case 9:                                     // 9 - Ajouter ou retirer le tag d'une tâche
      print("[Ajouter/Retirer le tag d'importance d'une tâche]");
      TagOrUnTagTaskActivity(dataBase);
      printMenu();
      start(dataBase, choose());
      break;
    case 10:                                  // 10 - Marqué une tâche comme terminé ou non
      print("[Marqué une tâche comme terminé ou non]");
      markTaskTerminate(dataBase);
      printMenu();
      start(dataBase, choose());
      break;
    case 11:                                // 11 - Fin du programme
      print("A la prochaine...");
      break;
    default:                                //Pas defaut on affiche le menu
      printMenu();
      start(dataBase, choose());
      break;
  }
}

//Methode permettant de saisir le choix de l'utilisateur et de retourner le numéro du choix
int choose() {
  try { //Geston de l'exception au cas ou un utilisateur entre une lettre à la place d'un numéro
    int choice;
    print("-->");
    //Récupération du choix
    choice = int.parse(stdin.readLineSync().toString());
    return choice;
  } catch (e) {
    print(
        "Une erreur est survenue. Vous avez surement due entrez des valeurs non conformes.");
  }
  return 0;
}


// Création de l'activité qui retourne un booléan si tout se passe bien ou non
bool createActivity(List<Todo> dataBase) {
  String? name;
  print("Nom de l'activité : ");
  //Récupération du nom de l'activité
  name = stdin.readLineSync().toString().toLowerCase();

  if (name.isEmpty) { //Si le nom de l'activité est vide, 
    createActivity(dataBase);   // On rappelle la methode de création d'une tâche
  } else { //Si non, on demande la confirmation d'ajout
    if (continuer("Etes vous sur de vouloir créer l'activité : <$name> ?")) { //On appel la methode continuée pour avoir la confirmation ajouter
      if(continuer("Marquer l'activité comme importante ?")){ //On appel la fonction pour savoir si la tâche est importante
        dataBase.add(new Todo(name.toUpperCase(), "important"));
      }else{
        dataBase.add(new Todo(name));
      }

      return true;
    }
  }

  return false;
}


//Methode continuer qui retourne un booléan.
  //Prend en parametre un message
bool continuer(String message) {
  String continue_;
  bool c = true;
  //Affichage du message passé en parametre
  print("$message [y/n]\n-->");
  continue_ = stdin.readLineSync().toString().toUpperCase();
  if (continue_ != "Y" && continue_ != "N") {
    continuer(message); //Si le O/N n'est pas choisir, on rappelle la methode continuer
  } else if (continue_ == "Y") {
    c = true; //Si la réponse est oui on retourne vrai
  } else {
    c = false; //Si non on retourne faux
  }
  return c;
}


//Ajouter une tâche à une activité
bool addingTask(List<Todo> dataBase) {
  if (dataBase.isEmpty) { //Si la liste est vide alors on ne peut pas ajouter une tâches à une activité
    print(
        "Aucune activité n'existe donc vous ne pouvez effectuer cette requête.");
  } else { //Si non
    print("\nActivités disponibles\n");
    printAllActivity(dataBase);
    print("Entrez le numéro de l'activité");
    int choice = choose(); //On demande le numéro de l'activité
    if (choice > 0 && choice <= dataBase.length) { //Si le numéro entré est supérieur à 0 et <= à la taille de la liste,
      Todo? activity = findActivity(dataBase, choice); // On recherche l'activité dans la liste
      if (activity != null) { //Si l'activité est retrouver, 
        print("Ajouter une tâche à : <" + activity.name + ">\n-->");
        print('Nom de la tâche : '); //On demande le nom de la tâche
        String taskName = stdin.readLineSync().toString();
        print('Durée de la tâche : '); //la durée de la tâche
        String taskTime = stdin.readLineSync().toString();
        if (taskName.isEmpty || taskTime.isEmpty) { // Si le nom de la tâche ou la durée est vide
          print("Renseigner des valeurs conformes");
          addingTask(dataBase); //On rappel la methode d'ajout d'une tâche
        } else { //Si non demande de  confirmation
          if (continuer( //Si c'est Y, on ajouter
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


//Afficher la dernière activité de la liste
void printLastActivity(List<Todo> dataBase) {
  if (dataBase.isNotEmpty) {
    print("\n" +
        dataBase.length.toString() +
        "- " +
        dataBase[dataBase.length - 1].name);
  }
}

//Afficher toutes les activites de la liste
void printAllActivity(List<Todo> dataBase) {
  int num;
  if (dataBase.isEmpty) { //Si la liste est vide, par d'activité
    print("Aucune activité ajoutée\n");
  } else { //Si non on partout lza liste ave  un for
    print("N° | Nom de l'activité   ");
    print("***|*******************************");
    for (int i = 0; i < dataBase.length; i++) {
      num = i + 1;
      
      print('$num- |<${dataBase[i].name}> ---> ${(dataBase[i].terminate == true) ?"Terminé" : "Non terminé"}');
      print("***|*******************************|");
    }
  }
}

//Affichage des tâches d'une activité 
void printTasksActivity(List<Todo> dataBase) {
  if (dataBase.isEmpty) { //Si la liste est vide, par d'activité et donc pas de tâches
    print(
        "Aucune activité n'existe donc vous ne pouvez effectuer cette requête.");
  } else { //Si non on demande le numéro de l'activité
    print("\nActivités disponibles\n");
    printAllActivity(dataBase);
    print("Entrez le numéro de l'activité");
    int choice = choose();
    if (choice > 0 && choice <= dataBase.length) {
      Todo? activity = findActivity(dataBase, choice); // On recherche l'activité 
      if (activity != null) { // Si on trouve l'activité, on affiche ses tâches
        activity.printAllTask();
      } else { //Si non pas d'activité
        print("Aucune activité ne porte ce numéro");
      }
    }
  }
}

//Rechercher une activité 
//Prend en parametre la liste et un numéro
Todo? findActivity(List<Todo> dataBase, int num) {
  //On parcour la liste et on retourne la tâche une fois trouvé
  for (int i = 0; i < dataBase.length; i++) {
    if (i == (num - 1)) {
      return dataBase[i];
    }
  } //Si non on retourne null
  return null;
}


//Supprimer la tâches d'une activité
bool removeTaskActivity(List<Todo> dataBase) {
  if (dataBase.isEmpty) { // Si liste vide opération imposible
    print(
        "Aucune activité n'existe donc vous ne pouvez effectuer cette requête.");
  } else { //Si non 
    print("\nActivités disponibles\n");
    printAllActivity(dataBase); // affichage des activités
    print("Entrez le numéro de l'activité"); // Demande du numéro de l'activité
    int choice = choose();
    if (choice > 0 && choice <= dataBase.length) {
      Todo? activity = findActivity(dataBase, choice); //Rechercher l'activité
      if (activity != null) { //Si différent de null 
        print("Activité : <" + activity.name + '>'); //afficher nom de l'activité
        print("\nTâches disponibles\n");
        activity.printAllTask(); //affichage des taches de l'activité

        if (continuer("Etes vous sur de vouloir continuer ?")) { //Si demande de confirmation de continuer la suppression est y, on continue
          print("Entrez le numéro de la tâche"); 
          int choice = choose(); // Demande du numéro de la tâche à supprimer
          if (choice > 0 && choice <= activity.tasks.length) {
            Task? task = activity.findTask(choice); // Rechercher tâche
            if (task != null) { //Si différent de null
              // print("Êtes-vous sûre de vouloir supprimer la tâche : <" + task.printTask() + '>');
              if (continuer("Etes vous sur de vouloir supprimer la tâche : <" +
                  task.printTask() +
                  '>')) { //Si confirmation de suppression est Y, 
                activity.removeTask(task); //On supprime la tâche
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

//Modification de la durée d'une tâche
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

// Supprimer une activité
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

//Marquer une activité comme importante
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

//Marquer une tâche comme terminée
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

//Verifier si une activité est terminé
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


//Marquer une tâches importante
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