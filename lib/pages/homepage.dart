import 'package:firebase_auth/firebase_auth.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
// ignore: unused_import
import 'package:firebase_storage/firebase_storage.dart';

// ignore: unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studyat/models/usermodel.dart';
import 'package:studyat/pages/constants.dart';
import 'package:studyat/pages/joinconference.dart';
import 'package:studyat/pages/loginpage.dart';
import 'package:studyat/pages/pdffiles.dart';
import 'package:studyat/pages/uploadfiles.dart';
import 'package:studyat/pages/userchats.dart';

class HomePage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const HomePage(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to the login page after signing out
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            height: 300,
            padding: EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 10),
            decoration: BoxDecoration(
              color: kpink,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.dashboard, size: 30, color: Colors.white),
                    GestureDetector(
                      onTap: () {
                        _signOut();
                      },
                      child: Icon(Icons.exit_to_app,
                          size: 30, color: Colors.white),
                    )
                  ],
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome! \n ${widget.userModel.fullname}",
                                style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                "Today is a good day\nto learn something new!",
                                style: TextStyle(
                                  color: Colors.black54,
                                  wordSpacing: 2.5,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Column(
                            children: [
                              Container(
                                height: 120,
                                width: 120,
                                margin: EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  color: kpurple,
                                  borderRadius: BorderRadius.circular(60.0),
                                ),
                                child: CircleAvatar(
                                  radius: 140,
                                  backgroundImage: NetworkImage(
                                    widget.userModel.profilepic!,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Image.asset(
            "assets/images/ux.png",
            fit: BoxFit.cover,
          )
        ],
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 65), // Move the FAB 30 pixels above
        child: FloatingActionButton(
          onPressed: () {
            // Add onPressed functionality here
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return UploadFiles(
                userModel: widget.userModel,
                firebaseUser: widget.firebaseUser,
              );
            }));
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.blue, // Change the color as needed
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomNavyBar(
        showElevation: true,
        onItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return JoinConference(
                  userModel: widget.userModel,
                  firebaseUser: widget.firebaseUser);
            }));
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return UserChats(
                    userModel: widget.userModel,
                    firebaseUser: widget.firebaseUser);
              }),
            );
          } else if (index == 3) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return PdfFiles(
                userModel: widget.userModel,
                firebaseUser: widget.firebaseUser,
              );
            }));
          }
        },
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
            activeColor: kpink,
            inactiveColor: Colors.grey[300],
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.video_call_outlined),
            title: Text('Conference'),
            inactiveColor: Colors.grey[300],
            activeColor: kpink,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.message),
            title: Text('Chat'),
            inactiveColor: Colors.grey[300],
            activeColor: kpink,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.note_alt),
            title: Text('Profile'),
            inactiveColor: Colors.grey[300],
            activeColor: kpink,
          ),
        ],
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
