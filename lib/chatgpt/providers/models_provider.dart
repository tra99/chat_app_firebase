
import 'package:flutter/material.dart';

import '../models/model.dart';
import '../services/api_services.dart';

class ModelsProvider with ChangeNotifier{
  List<Models>modelsLit=[];
  String currentModel='chatcmpl-123';
  List<Models>get getModels{
    return modelsLit;
  }
  String get getCurrentModel{
    return currentModel;
  }
  void setCurrentModel(String newModel){
    currentModel=newModel;
    notifyListeners();
  }

  Future<List<Models>>getAllModels()async{
    modelsLit=await ApiService.getModels();
    return modelsLit;
  }
}