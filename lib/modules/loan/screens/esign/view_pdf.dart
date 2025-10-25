import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ViewPdfScreen extends StatefulWidget {
  final String pdfUrl;

  const ViewPdfScreen({super.key, required this.pdfUrl});

  @override
  State<ViewPdfScreen> createState() => _ViewPdfScreenState();
}

class _ViewPdfScreenState extends State<ViewPdfScreen> {
  late final WebViewController _controller;
  Map language = {};
  double dW = 0.0;
  double dH = 0.0;
  double tS = 0.0;
  ThemeData get theme => Theme.of(context);

  @override
  void initState() {
    super.initState();

    final url =
        'https://docs.google.com/gview?embedded=true&url=${widget.pdfUrl}';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // You can add loading logic here.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {
            // Handle HTTP error
          },
          onWebResourceError: (WebResourceError error) {
            // Handle general web resource error
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    dH = MediaQuery.of(context).size.height;
    tS = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      appBar: AppBar(title: Text('View PDF')),
      body: WebViewWidget(controller: _controller),
    );
  }
}
