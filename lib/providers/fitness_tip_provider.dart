import 'package:flutter/material.dart';

import '../services/api/fitness_tip_service.dart';

class FitnessTipProvider extends ChangeNotifier {

  String _tip = "Loading today's fitness tip...";
  bool _loading = false;

  String get tip => _tip;
  bool get loading => _loading;

  Future<void> loadTip() async {

    _loading = true;
    notifyListeners();

    _tip = await FitnessTipService.instance.getDailyTip();

    _loading = false;
    notifyListeners();
  }
}