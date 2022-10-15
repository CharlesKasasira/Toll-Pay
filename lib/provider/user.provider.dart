import 'package:flutter/material.dart';

class WrongUser extends ChangeNotifier {
  String _name = "Charles";

  String get getUser {
    return _name;
  }
}
