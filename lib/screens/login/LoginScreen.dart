import 'package:flutter/material.dart';
import 'package:flutter_kucingpeduli/components/login/LoginComponent.dart';
import 'package:flutter_kucingpeduli/size_config.dart';

class LoginScreen extends StatelessWidget {
  static String routename = "sign_in";
  
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Logincomponent(),
    );
  }
}
