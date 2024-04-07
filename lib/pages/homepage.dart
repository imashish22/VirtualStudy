import 'package:firebase_auth/firebase_auth.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studyat/models/usermodel.dart';
import 'package:studyat/pages/constants.dart';
import 'package:studyat/pages/loginpage.dart';
import 'package:studyat/pages/pdffiles.dart';
import 'package:studyat/pages/pdfviewscreen.dart';
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
  List<Map<String, dynamic>> _pdfFiles = [];

  @override
  void initState() {
    super.initState();
    _fetchPdfFiles();
  }

  Future<void> _fetchPdfFiles() async {
    try {
      final ListResult result = await FirebaseStorage.instance
          .ref()
          .child('pdfs')
          .child("users")
          .listAll();

      _pdfFiles = await Future.wait(
        result.items.map((item) async {
          final fileName = item.name.split('/').last;
          final downloadURL = await item.getDownloadURL();
          return {'name': fileName, 'url': downloadURL};
        }).toList(),
      );

      setState(() {});
    } catch (e) {
      print('Error fetching PDF files: $e');
    }
  }

  Future<void> _showPdfDialog(String pdfUrl) async {
    try {
      // Navigate to PdfViewScreen passing the pdfUrl
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfViewScreen(pdfUrl: pdfUrl),
        ),
      );
    } catch (e) {
      print('Error loading PDF: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to load PDF. Please try again later.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            height: 255,
            padding: EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 10),
            decoration: BoxDecoration(
                color: kpink,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                )),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.dashboard, size: 30, color: Colors.white)
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
                              SizedBox(
                                height: 10.0,
                              ),
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
                                // Assuming profilePic is the URL of the profile picture
                                child: CircleAvatar(
                                  radius: 140,
                                  backgroundImage: NetworkImage(
                                      widget.userModel.profilepic!),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            height: MediaQuery.of(context).size.height *
                0.6, // Set a fixed height or adjust as needed
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _pdfFiles.length,
              itemBuilder: (context, index) {
                final pdfName = _pdfFiles[index]['name'];
                final pdfUrl = _pdfFiles[index]['url'];
                final userName = widget.userModel.fullname ?? 'Unknown User';
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      _showPdfDialog(pdfUrl!);
                    },
                    child: SizedBox(
                      height: 200,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 233, 89, 249)
                                  .withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.network(
                              'https://pacific7.co.nz/wp-content/uploads/2018/08/PDF-download-image-768x768.png',
                              height: 130,
                            ),
                            Text(
                              pdfName!,
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              userName,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // Your content goes here...

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
          if (index == 2) {
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
            icon: Icon(Icons.favorite_rounded),
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
