// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:blog_app/screens/add_post_screen.dart';
import 'package:blog_app/screens/login_screen.dart';
import 'package:blog_app/screens/option_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showSpanner = false;

  final dbRef = FirebaseDatabase.instance.reference().child('posts');

  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController searchController = TextEditingController();

  String search = "";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.amber[700],
          title: Text(
            "Add New Blog",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddPost()));
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 30,
                    shadows: [
                      BoxShadow(
                        color: Colors.black45,
                        offset: Offset(3, 3),
                      ),
                      BoxShadow(
                        color: Colors.black45,
                      //  offset: Offset(-2, -1),
                      ),
                    ],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: InkWell(
                  onTap: () {
                    auth.signOut().then((value) => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => OptionScreen())));
                  },
                  child: Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 25,
                    shadows: [
                      BoxShadow(
                        color: Colors.black45,
                        offset: Offset(3, 3),
                      ),
                      BoxShadow(
                        color: Colors.black45,
                        //  offset: Offset(-2, -1),
                      ),
                    ],
                  )),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: searchController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search_rounded,
                  ),
                  hintText: "Search blogs based on title",
                  labelText: 'Search',
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

                    setState(() {
                    });

                },
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: FirebaseAnimatedList(
                  query: dbRef.child('Post List'),
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    String tempTitle = snapshot.value['pTitle'];
                    if(searchController.text.isEmpty){
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: FadeInImage.assetNetwork(
                                  fit: BoxFit.cover,
                                  height: MediaQuery.of(context).size.height * 0.25,
                                  width: MediaQuery.of(context).size.width * 1,
                                  placeholder: 'images/blog_logo.png',
                                  image: snapshot.value['pImage'],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                snapshot.value['pTitle'],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                snapshot.value['pDescription'],
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                              ),
                              Divider(thickness: 2,),
                            ],
                          ),
                        ),
                      );
                    }else if(tempTitle.toLowerCase().contains(searchController.text.toString())){
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: FadeInImage.assetNetwork(
                                fit: BoxFit.cover,
                                height: MediaQuery.of(context).size.height * 0.25,
                                width: MediaQuery.of(context).size.width * 1,
                                placeholder: 'images/blog_logo.png',
                                image: snapshot.value['pImage'],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              snapshot.value['pTitle'],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              snapshot.value['pDescription'],
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal),
                            ),
                            Divider(thickness: 2,),
                          ],
                        ),
                      ),
                    );
                    }else {
                      return Container();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
