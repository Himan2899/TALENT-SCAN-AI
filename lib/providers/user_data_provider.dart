import 'package:flutter/foundation.dart';

class UserDataProvider extends ChangeNotifier {
  String userName = 'Himanshu Bali';
  String userEmail = 'himan@talentscan.ai';
  String? userLevel = 'Elite Athlete';
  int testsDone = 47;
  int rank = 4;
  double score = 92.5;

  Map<String, double> performanceData = {
    'Vertical Jump': 68.5,
    'Sprint 40m': 85.2,
    'Sit-ups': 78.0,
    'Push-ups': 82.4,
  };

  List<Map<String, dynamic>> recentTests = [
    {'name': 'Vertical Jump', 'score': 68.5, 'date': 'Today', 'improvement': 5.2},
    {'name': 'Sprint Test', 'score': 85.2, 'date': '2 days ago', 'improvement': 2.1},
    {'name': 'Agility Test', 'score': 89.1, 'date': '3 days ago', 'improvement': -1.3},
  ];

  List<String> achievements = [
    'First Test',
    '10 Day Streak', 
    'High Score',
    'Improvement',
  ];

  void updateData() {
    notifyListeners();
  }
}
