import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studyat/models/usermodel.dart';
import 'package:studyat/pages/conference.dart';

class JoinConference extends StatefulWidget {
    final UserModel userModel;
  final User firebaseUser;

  const JoinConference({super.key, required this.userModel, required this.firebaseUser});

  @override
  State<JoinConference> createState() => _JoinConferenceState();
}

class _JoinConferenceState extends State<JoinConference> {
  TextEditingController idController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            controller: idController,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Conference(
                            conferenceId: idController.text.trim(),
                            userModel: widget.userModel,
                            firebaseUser: widget.firebaseUser,
                          )));
            },
            child: Container(
              height: 70,
              width: 120,
              color: Colors.blue,
              child: Center(
                child: Text(
                  "JOIN",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}