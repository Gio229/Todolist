# Todolist
##Projet collaboratif dart
##Avant TAF
Vous cloner le repo et créé une branch à votre nom

##Récapitulatif##
-Ajout de la fonctionnalité de changement d'état à terminé
    *je rappelle que on a ceci dans la classe Task:
-------------------------------------------
Map <String, String> possibleStatus = {
    'start':'non débuté', 
    'in':'en cours', 
    'end':'terminé'      <---ceci
    };
-------------------------------------------

   ...et que de base les tâches sont par défaut non débuté. Une fois que la durée passé sur la tâche est modifié le statut passe à en cours.

-Lors de la suppression d'une tâche on affiche l'activité avec l'ensemble des tâches

-Modifier la méthode continuer de telle sorte qu'elle prenne en  paramettre la phrase à afficher
    *je rappelle quand on faisait continuer() on affichait : voulez-vous continuer ? [0/1] de manière statique.
