import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studyat/models/usermodel.dart';
import 'package:studyat/pages/conference.dart';
import 'package:studyat/pages/constants.dart';

class JoinConference extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const JoinConference(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  State<JoinConference> createState() => _JoinConferenceState();
}

class _JoinConferenceState extends State<JoinConference> {
  TextEditingController idController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conference"),
        backgroundColor: kpink,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/programming.png",
              height: 300,
              width: 300,
            ),
            TextFormField(
              controller: idController,
              decoration: InputDecoration(
                labelText: 'Conference ID',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Conference(
                      conferenceId: idController.text.trim(),
                      userModel: widget.userModel,
                      firebaseUser: widget.firebaseUser,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                backgroundColor: Colors.blue,
              ),
              child: Text(
                "JOIN",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
