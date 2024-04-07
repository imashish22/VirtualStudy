import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PdfViewScreen extends StatefulWidget {
  final String pdfUrl;

  const PdfViewScreen({super.key, required this.pdfUrl});

  @override
  State<PdfViewScreen> createState() => _PdfViewScreenState();
}

class _PdfViewScreenState extends State<PdfViewScreen> {
  PDFDocument? document;

  void initialisePdf() async {
    document = await PDFDocument.fromURL(widget.pdfUrl);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initialisePdf();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: document != null
          ? PDFViewer(
            
              document: document!,
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
