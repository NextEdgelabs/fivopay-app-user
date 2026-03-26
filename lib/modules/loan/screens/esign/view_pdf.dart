import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class PdfViewScreen extends StatefulWidget {
  final String url;
  // final String courseName;
  // final String studentName;

  const PdfViewScreen({
    super.key,
    required this.url,
    // required this.courseName,
    // required this.studentName,
  });

  @override
  State<PdfViewScreen> createState() => _CertificateViewScreenState();
}

class _CertificateViewScreenState extends State<PdfViewScreen> {
  WebViewControllerPlus? webViewController;
  bool _isLoading = true;
  bool _hasError = false;
  double _progress = 0.0;
  bool _useAlternativeViewer = false;

  @override
  void initState() {
    super.initState();
    // Initialize WebView controller
    webViewController = WebViewControllerPlus()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _hasError = false;
            });
          },
          onProgress: (int progress) {
            setState(() {
              _progress = progress / 100;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false;
              _hasError = true;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(_getPdfViewerUrl()));
  }

  @override
  void dispose() {
    webViewController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:  Text(
          "Document",
          // widget.args.title ?? "INVOICE",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        // actions: [
        //   // IconButton(
        //   //   icon: const Icon(Icons.share, color: Colors.black),
        //   //   onPressed: _shareCertificate,
        //   //   tooltip: 'Share Certificate',
        //   // ),
        //   // IconButton(
        //   //   icon: const Icon(Icons.download, color: Colors.black),
        //   //   onPressed: _downloadCertificate,
        //   //   tooltip: 'Download Certificate',
        //   // ),
        //   PopupMenuButton<String>(
        //     onSelected: _handleMenuAction,
        //     itemBuilder: (context) => [
        //        PopupMenuItem(
        //         value: 'open_browser',
        //         child: Row(
        //           children: [
        //             Icon(Icons.open_in_browser, size: 20),
        //             SizedBox(width: 8),
        //             Text('Open in Browser'),
        //           ],
        //         ),
        //       ),
        //    PopupMenuItem(
        //         value: 'copy_link',
        //         child: Row(
        //           children: [
        //             Icon(Icons.copy, size: 20),
        //             SizedBox(width: 8),
        //             Text('Copy Link')
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        // ],
      ),
      body: Column(
        children: [
          // Course information header

          // Progress indicator
          if (_isLoading)
            LinearProgressIndicator(
              value: _progress,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            ),

          // PDF viewer
          Expanded(
            child: _hasError
                ? _buildErrorView()
                : Stack(
                    children: [
                      webViewController != null
                          ? WebViewWidget(controller: webViewController!)
                          : Center(child: CircularProgressIndicator()),
                      if (_isLoading && _progress < 1.0)
                        Container(
                          color: Colors.white.withOpacity(0.8),
                          child:Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(color: Colors.green),
                                SizedBox(height: 16),
                                Text(
                                  'Loading Document...',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
          ),

          // // Action buttons
          // Container(
          //   padding: const EdgeInsets.all(16),
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     border: Border(top: BorderSide(color: Colors.grey.shade200)),
          //     boxShadow: [
          //       BoxShadow(
          //         color: Colors.black.withOpacity(0.05),
          //         blurRadius: 10,
          //         offset: const Offset(0, -2),
          //       ),
          //     ],
          //   ),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: OutlinedButton.icon(
          //           onPressed: _shareCertificate,
          //           icon: const Icon(Icons.share),
          //           label: const Text('Share'),
          //           style: OutlinedButton.styleFrom(
          //             foregroundColor: Colors.green,
          //             side: const BorderSide(color: Colors.green),
          //             padding: const EdgeInsets.symmetric(vertical: 12),
          //           ),
          //         ),
          //       ),
          //       const SizedBox(width: 12),
          //       Expanded(
          //         child: ElevatedButton.icon(
          //           onPressed: _downloadCertificate,
          //           icon: const Icon(Icons.download),
          //           label: const Text('Download'),
          //           style: ElevatedButton.styleFrom(
          //             backgroundColor: Colors.green,
          //             foregroundColor: Colors.white,
          //             padding: const EdgeInsets.symmetric(vertical: 12),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
       
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.picture_as_pdf, size: 64, color: Colors.green.shade300),
            const SizedBox(height: 16),
            const Text(
              'Document View',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Your Document is ready to view. Choose an option below to access it.',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _openInBrowser,
                    icon: const Icon(Icons.open_in_browser),
                    label: const Text('Open in Browser'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _tryAlternativeViewer,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Alternative Viewer'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green,
                      side: const BorderSide(color: Colors.green),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                // const SizedBox(height: 12),
                // SizedBox(
                //   width: double.infinity,
                //   child: OutlinedButton.icon(
                //     onPressed: _downloadCertificate,
                //     icon: const Icon(Icons.download),
                //     label: const Text('Download PDF'),
                //     style: OutlinedButton.styleFrom(
                //       foregroundColor: Colors.blue,
                //       side: const BorderSide(color: Colors.blue),
                //       padding: const EdgeInsets.symmetric(vertical: 12),
                //     ),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getPdfViewerUrl() {
    // Use different viewers based on flag
    if (_useAlternativeViewer) {
      // Direct PDF link
      return widget.url;
    } else {
      // Use Google Docs viewer for better PDF compatibility
      final encodedUrl = Uri.encodeComponent(widget.url);
      return 'https://docs.google.com/viewer?url=$encodedUrl&embedded=true';
    }
  }

  void _tryAlternativeViewer() {
    setState(() {
      _useAlternativeViewer = !_useAlternativeViewer;
      _isLoading = true;
      _hasError = false;
    });
    webViewController?.loadRequest(Uri.parse(_getPdfViewerUrl()));
  }

  // void _handleMenuAction(String action) {
  //   switch (action) {
  //     case 'open_browser':
  //       _openInBrowser();
  //       break;
  //     case 'copy_link':
  //       _copyLink();
  //       break;
  //   }
  // }

  // Future<void> _shareCertificate() async {
  //   try {
  //     await SharePlus.instance.share(ShareParams(
  //       text:
  //           'Your SocietyWaley maintenance bill is here ✅\n Pay & track bills, receipts, and updates easily with our app.\n ${widget.args.certificateUrl} \n\n📲 Download SocietyWaley now: https://play.google.com/store/apps/details?id=com.sw_resident.app]',
  //       // text: 'Check out my invoice/document!\n\n${widget.args.certificateUrl}',
  //       subject: 'Invoice Document',
  //     ));
  //   } catch (e) {
  //     _showErrorSnackBar('Failed to share certificate: $e');
  //   }
  // }

  // Future<void> _downloadCertificate() async {
  //   try {
  //     await launchUrl(Uri.parse(widget.args.certificateUrl),
  //         mode: LaunchMode.externalApplication);
  //   } catch (e) {
  //     _showErrorSnackBar('Failed to download certificate: $e');
  //   }
  // }

  Future<void> _openInBrowser() async {
    try {
      await launchUrl(Uri.parse(widget.url),
          mode: LaunchMode.externalApplication);
    } catch (e) {
      _showErrorSnackBar('Failed to open in browser: $e');
    }
  }

  // Future<void> _copyLink() async {
  //   try {
  //     await Clipboard.setData(ClipboardData(text: widget.url));
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Certificate link copied to clipboard'),
  //         backgroundColor: Colors.green,
  //         duration: Duration(seconds: 2),
  //       ),
  //     );
  //   } catch (e) {
  //     _showErrorSnackBar('Failed to copy link: $e');
  //   }
  // }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
