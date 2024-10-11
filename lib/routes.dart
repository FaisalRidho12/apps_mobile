import 'package:flutter/material.dart';
import 'package:flutter_kucingpeduli/screens/login/LoginScreen.dart';
import 'package:flutter_kucingpeduli/screens/register/registrasi.dart';

final Map<String, WidgetBuilder> routes = {
  LoginScreen.routename: (context) => LoginScreen(),
  registerScreen.routename: (context) => registerScreen(),
};