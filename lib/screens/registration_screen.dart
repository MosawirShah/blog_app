import 'package:blog_app/components/rounded_button.dart';
import 'package:blog_app/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter/foundation.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final _globalKey = GlobalKey<FormState>();

  final _emailEditingController = TextEditingController();
  final _passwordEditingController = TextEditingController();
  String? email;
  String? password;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber[700],
          title: Text(
            "User Registeration",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Resgistration",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 28.0, horizontal: 30),
              child: Form(
                  key: _globalKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailEditingController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.email,
                          ),
                          hintText: "Email",
                          labelText: 'Email',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.amber,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          email = value;
                        },
                        validator: (value) {
                          return value!.isEmpty ? "Enter your email" : null;
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: _passwordEditingController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                          ),
                          hintText: "Password",
                          labelText: 'Password',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: Colors.amber,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          email = value;
                        },
                        validator: (value) {
                          return value!.isEmpty ? "Enter your passward" : null;
                        },
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      RoundedButton(
                          title: 'Register',
                          onPress: () async{
                            if (_globalKey.currentState!.validate()) {
                              setState(() {
                                showSpinner = true;
                              });
                              try {
                                UserCredential user =
                                    await _auth.createUserWithEmailAndPassword(
                                        email: _emailEditingController.text.trim(),
                                        password: _passwordEditingController.text);

                                if (user != null) {
                                  print("Successful");
                                  toastMessage("User is successfully created");
                                  setState(() {
                                    showSpinner = false;
                                  });
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                         HomeScreen()));
                                }
                              } catch (e) {
                                print(e.toString());
                                toastMessage(e.toString());
                                setState(() {
                                  showSpinner = false;
                                });
                              }
                            }
                          }),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  void toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.amber[700],
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
