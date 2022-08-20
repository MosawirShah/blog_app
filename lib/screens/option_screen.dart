import 'package:blog_app/components/rounded_button.dart';
import 'package:blog_app/screens/login_screen.dart';
import 'package:blog_app/screens/registration_screen.dart';
import 'package:flutter/material.dart';
class OptionScreen extends StatefulWidget {
  const OptionScreen({Key? key}) : super(key: key);

  @override
  State<OptionScreen> createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(image: AssetImage('images/logo1.png')),
              SizedBox(height: 40,),
              RoundedButton(title: 'Login', onPress: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const LogIn()));

              }),
              SizedBox(height: 20,),
              RoundedButton(title: 'Register', onPress: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Register()));
              }),
            ],
          ),
        ),
      ),
    );
  }
}
