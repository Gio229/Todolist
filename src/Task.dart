class Task {
  String name;
  String? tag;
  String timeInit;
  String timeSpent = '00min';
  Map<String, String> possibleStatus = {
    'start': 'non débuté',
    'in': 'en cours',
    'end': 'terminé'
  };
  String status = '';

//Constructeur
  Task(this.name, this.timeInit) {
    this.status = possibleStatus['start'].toString();
  }

//Methode afficharge de la tâche
  String printTask() {
    return this.name +
        " |Durée : " +
        this.timeInit +
        " |Temps passé : " +
        this.timeSpent +
        " |Statut : " +
        this.status;
  }

//Modifier la durée d'une tâche
  bool modifyTimeSpent(String newTime) {
    if (newTime != "") {
      this.timeSpent = newTime;
      this.status = this.possibleStatus['in'].toString();
      // print(newTime);
      return true;
    }

    return false;
  }
}
