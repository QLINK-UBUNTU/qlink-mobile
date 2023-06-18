import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LineNotifier extends ChangeNotifier{
  // Initiator
  double _lineAnimationValue = 0;
  List<bool> _isEnergyActive = [true, true, true, true, true, true, true, true, true, true];


  // Getter
  double get lineAnimationValue => _lineAnimationValue;
  List<bool> get isEnergyActive => _isEnergyActive;

  // Setter
  set lineAnimationValue(double newValue){
    _lineAnimationValue = newValue;
    notifyListeners();
  }
  set isEnergyActive(List<bool> newValue){
    _isEnergyActive = newValue;
    notifyListeners();
  }

  void changeSingleActiveStatus(bool status, int id){
    _isEnergyActive[id] = status;
    notifyListeners();
  }
}