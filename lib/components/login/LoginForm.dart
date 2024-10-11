import 'package:flutter/material.dart';
import 'package:flutter_kucingpeduli/components/custom_surfix_icon.dart';
import 'package:flutter_kucingpeduli/components/default_button_custome_color.dart';
import 'package:flutter_kucingpeduli/screens/register/registrasi.dart';
import 'package:flutter_kucingpeduli/size_config.dart';
import 'package:flutter_kucingpeduli/utils/constants.dart';

class signinform extends StatefulWidget {
  @override
  _signinform createState() => _signinform();
}

class _signinform extends State<signinform> {
  final _formkey = GlobalKey<FormState>();
  String? username;
  String? password;
  bool? remember = false;

  TextEditingController txtUserName = TextEditingController(),
      txtpassword =TextEditingController();

  FocusNode focusNode = new FocusNode();

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(
            children: [
              buildusername(),
              SizedBox(height: getProportionateScreenHeight(30)),
              buildpassword(),
              SizedBox(height: getProportionateScreenHeight(30)),
              Row(
                children: [
                    Checkbox(
                      value: remember,
                      onChanged: (Value){
                        setState(() {
                          remember = Value;
                        });
                      }),
                    Text("tetap masuk"),
                    Spacer(),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        "lupa password",
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    )
                  ],
              ),
              DefaultButtonCustomeColor(
                color: const Color.fromARGB(255, 9, 70, 74),
                text: "login",
                press: () {},
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, registerScreen.routename);
                      },
                      child: Text(
                        "belum punya akun?,silahkan bikin disini",
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    )
            ],
          ),
      );
  }

  TextFormField buildusername(){
    return TextFormField(
      controller: txtpassword,
      keyboardType: TextInputType.text,
      style: mTitleStyle,
      decoration: InputDecoration(
          labelText: 'username',
          hintText: 'masukan username anda',
          labelStyle: TextStyle(
              color: focusNode.hasFocus ? mSubtitleColor : const Color.fromARGB(255, 9, 70, 74)),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: CustomSurffixIcon(
            svgIcon: "assets/icons/user.svg",
          )
          ),
    );
  }

TextFormField buildpassword(){
    return TextFormField(
      obscureText: true,
      style: mTitleStyle,
      decoration: InputDecoration(
          labelText: 'password',
          hintText: 'masukan password anda',
          labelStyle: TextStyle(
              color: focusNode.hasFocus ? mSubtitleColor : const Color.fromARGB(255, 9, 70, 74)),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: CustomSurffixIcon(
            svgIcon: "assets/icons/user.svg",
          )
          ),
    );
  }

}