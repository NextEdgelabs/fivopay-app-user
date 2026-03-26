import 'package:flutter/material.dart';
import 'package:janseva/utils/constants.dart';
import 'package:janseva/utils/theme_extension.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentViewerScreen extends StatefulWidget {
  final String url;
  final String documentName;
  final bool isPdf;

  const DocumentViewerScreen({
    super.key,
    required this.url,
    required this.documentName,
    this.isPdf = true,
  });

  @override
  State<DocumentViewerScreen> createState() => _DocumentViewerScreenState();
}

class _DocumentViewerScreenState extends State<DocumentViewerScreen> {
  WebViewControllerPlus? webViewController;
  bool _isLoading = true;
  bool _hasError = false;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.isPdf) {
      _initializePdfViewer();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _initializePdfViewer() {
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

  String _getPdfViewerUrl() {
    // Using Mozilla's PDF.js viewer
    return 'https://mozilla.github.io/pdf.js/web/viewer.html?file=${Uri.encodeComponent(widget.url)}';
  }

  @override
  void dispose() {
    webViewController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isPdf ? Colors.white : context.colors.bgColors,
      appBar: AppBar(
        title: Text(
          widget.documentName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: context.colors.brandColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            onPressed: _openInBrowser,
            tooltip: 'Open in browser',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareDocument,
            tooltip: 'Share',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_hasError) {
      return _buildErrorView();
    }

    if (widget.isPdf) {
      return _buildPdfView();
    } else {
      return _buildImageView();
    }
  }

  Widget _buildPdfView() {
    return Stack(
      children: [
        if (webViewController != null)
          WebViewWidget(controller: webViewController!),
        if (_isLoading)
          Container(
            color: Colors.white,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    value: _progress > 0 ? _progress : null,
                    color: context.colors.brandColor,
                  ),
                  const SizedBox(height: AppSizes.paddingL),
                  Text(
                    'Loading PDF...',
                    style: AppTextStyles.body1.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                  if (_progress > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSizes.paddingS),
                      child: Text(
                        '${(_progress * 100).toInt()}%',
                        style: AppTextStyles.caption.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildImageView() {
    return Center(
      child: InteractiveViewer(
        minScale: 0.5,
        maxScale: 4.0,
        child: Image.network(
          widget.url,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                        : null,
                    color: context.colors.brandColor,
                  ),
                  const SizedBox(height: AppSizes.paddingL),
                  Text(
                    'Loading image...',
                    style: AppTextStyles.body1.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorView();
          },
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.open_in_browser,
              size: 64,
              color: context.colors.textSecondary,
            ),
            const SizedBox(height: AppSizes.paddingL),
            // Text(
            //   'Failed to load document',
            //   style: AppTextStyles.heading3,
            //   textAlign: TextAlign.center,
            // ),
            const SizedBox(height: AppSizes.paddingM),
            Text(
              'Please try opening it in your browser.',
              style: AppTextStyles.body2.copyWith(
                color: context.colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.paddingXL),
            ElevatedButton.icon(
              onPressed: _openInBrowser,
              icon: const Icon(Icons.open_in_browser),
              label: const Text('Open in Browser'),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.brandColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingXL,
                  vertical: AppSizes.paddingM,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusL),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openInBrowser() async {
    final Uri uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open document'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _shareDocument() async {
    // You can implement share functionality here using share_plus package
    // For now, we'll just copy the URL behavior
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Document URL copied to clipboard'),
        backgroundColor: context.colors.brandColor,
        action: SnackBarAction(
          label: 'Open',
          textColor: Colors.white,
          onPressed: _openInBrowser,
        ),
      ),
    );
  }
}
