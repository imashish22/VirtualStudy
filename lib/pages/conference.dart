import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studyat/models/usermodel.dart';
import 'package:studyat/pages/secret.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

class Conference extends StatefulWidget {
    final UserModel userModel;
    final User firebaseUser;
    final String conferenceId;

  const Conference({super.key, required this.userModel, required this.firebaseUser, required this.conferenceId});


  @override
  State<Conference> createState() => _ConferenceState();
}

class _ConferenceState extends State<Conference> {
  @override
    Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ZegoUIKitPrebuiltVideoConference(
          appID: Secret.appId, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
          appSign: Secret.appSign, // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
          userID: widget.userModel.uid!,
          userName: widget.userModel.fullname!,
          conferenceID: widget.conferenceId,
          config: ZegoUIKitPrebuiltVideoConferenceConfig(),
        ),
      ),
    );
  }
}