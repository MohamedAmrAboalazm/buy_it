import 'package:flutter/cupertino.dart';

class Modelhud extends ChangeNotifier
{
  bool isLoding=false;

  changeisLoding(bool value)
  {
    isLoding=value;
    notifyListeners();
  }
}