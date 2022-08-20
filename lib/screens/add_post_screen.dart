// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:io';

import 'package:blog_app/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_database/firebase_database.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddPost extends StatefulWidget {
  AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  bool showSpinner = false;
  final postRef = FirebaseDatabase.instance.reference().child('posts');
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  final _auth = FirebaseAuth.instance;

  File? _image;

  final titleEditingController = TextEditingController();

  final descriptionEditingController = TextEditingController();

  final imagePicker = ImagePicker();

  //Method for Dialog
  void dialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Container(
              height: 120,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      getImageByCamera();
                      Navigator.of(context).pop();
                    },
                    child: ListTile(
                      leading: Icon(Icons.camera_alt),
                      title: Text("Camera"),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      getImageFromGallery();
                      Navigator.of(context).pop();
                    },
                    child: ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text("Gallery"),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future getImageFromGallery() async {
    final pickFile = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickFile != null) {
        _image = File(pickFile.path);
      } else {
        print("No file is selected");
      }
    });
  }

  Future getImageByCamera() async {
    final pickFile = await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickFile != null) {
        _image = File(pickFile.path);
      } else {
        print("No file is selected");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber[700],
          title: Text("Upload blog", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: (){
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 10),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    dialog(context);
                  },
                  child: Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width * 1,
                      child: _image != null
                          ? ClipRect(
                              child: Image.file(
                                _image!.absolute,
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: 100,
                              width: double.infinity,
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.amber[700],
                                size: 40,
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: titleEditingController,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          hintText: 'Enter post title',
                          border: OutlineInputBorder(),
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal),
                          labelStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        controller: descriptionEditingController,
                        minLines: 1,
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          hintText: 'Enter post description',
                          border: OutlineInputBorder(),
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal),
                          labelStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      RoundedButton(
                          title: "Upload",
                          onPress: () async {
                            setState(() {
                              showSpinner = true;
                            });
                            try {
                              int date = DateTime.now().microsecondsSinceEpoch;
                              firebase_storage.Reference ref =
                                  storage.ref('/blogapp$date');
                              UploadTask uploadTask =
                                  ref.putFile(_image!.absolute);
                              await Future.value(uploadTask);
                              var newUrl = await ref.getDownloadURL();

                              User? user = _auth.currentUser;
                              postRef
                                  .child('Post List')
                                  .child(date.toString())
                                  .set({
                                'pId': date.toString(),
                                'pImage': newUrl.toString(),
                                'pTime': date.toString(),
                                'pTitle': titleEditingController.text.toString(),
                                //Dumy text for description,
                                'pDescription' : 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Duis ut diam quam nulla porttitor. Morbi blandit cursus risus at ultrices mi. Morbi leo urna molestie at. Dictum sit amet justo donec enim diam vulputate ut pharetra. Lectus arcu bibendum at varius vel. Quis imperdiet massa tincidunt nunc pulvinar sapien et ligula. Elementum nisi quis eleifend quam adipiscing.',
                                // 'pDescription': descriptionEditingController.text.toString(),
                                'uEmail': user!.email.toString(),
                                'uId': user.uid.toString(),
                              }).then((value) {
                                toastMessage('Post published');
                                setState(() {
                                  showSpinner = false;
                                });
                              }).onError((error, stackTrace) {
                                toastMessage(error.toString());
                                print(error.toString());
                                setState(() {
                                  showSpinner = false;
                                });
                              });
                            } catch (e) {
                              setState(() {
                                showSpinner = false;
                              });
                              toastMessage(e.toString());
                            }
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
        textColor: Colors.black45,
        fontSize: 16.0);
  }
}
