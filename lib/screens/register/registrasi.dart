import 'package:flutter/material.dart';
import 'package:flutter_kucingpeduli/size_config.dart';


class registerScreen extends StatelessWidget {
  static String routename = "sign_up";
  
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      //  body: registerScreen(),
    );
  }
}
