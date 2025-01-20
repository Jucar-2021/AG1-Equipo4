import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Pdfleer extends StatelessWidget {
  final String leerPdf;

  const Pdfleer({super.key, required this.leerPdf});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Visualizar PDF")),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri.uri(Uri.parse(leerPdf)),
        ),
      ),
    );
  }
}
