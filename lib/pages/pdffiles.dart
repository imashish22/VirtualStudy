import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:studyat/models/usermodel.dart';
import 'package:studyat/pages/constants.dart';
import 'package:studyat/pages/pdfviewscreen.dart';

class PdfFiles extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const PdfFiles({
    Key? key,
    required this.userModel,
    required this.firebaseUser,
  }) : super(key: key);

  @override
  _PdfFilesState createState() => _PdfFilesState();
}

class _PdfFilesState extends State<PdfFiles> {
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
          .child("shared")
          .listAll();

      _pdfFiles = await Future.wait(
        result.items.map((item) async {
          final fileName = item.name.split('/').last;
          final downloadURL = await item.getDownloadURL();
          final metadata = await item.getMetadata();
          final uploadedBy = metadata.customMetadata!['uploadedBy'];
          return {
            'name': fileName,
            'url': downloadURL,
            'uploadedBy': uploadedBy
          };
        }).toList(),
      );

      setState(() {});
    } catch (e) {
      print('Error fetching PDF files: $e');
    }
  }

  void _showPdfDialog(String pdfUrl) {
    try {
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
      appBar: AppBar(
        title: Text('PDF Files'),
        backgroundColor: kpink,
      ),
      body: _pdfFiles.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _pdfFiles.length,
              itemBuilder: (context, index) {
                final pdfName = _pdfFiles[index]['name'];
                final pdfUrl = _pdfFiles[index]['url'];

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
                          color: kblue, // Set background color to purple
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.transparent,
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
                              height: 100,
                            ),
                            Text(
                              pdfName!,
                              style: TextStyle(
                                fontSize: 18,
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
    );
  }
}