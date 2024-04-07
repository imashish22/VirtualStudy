import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:studyat/models/usermodel.dart';
import 'package:studyat/pages/constants.dart';
import 'package:studyat/pages/pdffiles.dart'; // Import the PdfFiles screen

class UploadFiles extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const UploadFiles({
    Key? key,
    required this.userModel,
    required this.firebaseUser,
  }) : super(key: key);

  @override
  _UploadFilesState createState() => _UploadFilesState();
}

class _UploadFilesState extends State<UploadFiles> {
  String? _filePath;
  bool _uploading = false;

  Future<void> _openFileExplorer() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null) {
        setState(() {
          _filePath = result.files.single.path!;
        });
      }
    } catch (e) {
      print('Error picking PDF file: $e');
    }
  }

  Future<void> _uploadPdf(String? filePath) async {
    if (filePath == null) return;

    try {
      setState(() {
        _uploading = true;
      });

      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('pdfs')
          .child(
              'shared') // Store in a shared directory accessible to all users
          .child('pdf_${DateTime.now().millisecondsSinceEpoch}.pdf');
      final UploadTask uploadTask = storageRef.putFile(File(filePath));
      await uploadTask.whenComplete(() {});

      setState(() {
        _uploading = false;
      });

      // Navigate back to PdfFiles screen after successful upload
      Navigator.pop(context); // This will go back to the previous screen
    } catch (e) {
      setState(() {
        _uploading = false;
      });
      print('Error uploading PDF: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload PDF'),
        backgroundColor: kpink,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _uploading ? null : _openFileExplorer,
              child: Text(_uploading ? 'Uploading...' : 'Select PDF'),
            ),
            SizedBox(height: 20),
            _filePath != null ? Text('Selected PDF: $_filePath') : Container(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploading ? null : () => _uploadPdf(_filePath),
              child: Text('Upload PDF'),
            ),
          ],
        ),
      ),
    );
  }
}
