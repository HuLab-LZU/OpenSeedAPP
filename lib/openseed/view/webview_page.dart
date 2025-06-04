import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:open_seed/l10n/g/app_localizations.dart';
import 'package:open_seed/openseed/view/not_found_page.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({required this.title, this.url, super.key});

  final Uri? url;
  final String title;

  static Route<void> route({required String title, Uri? url}) {
    return MaterialPageRoute<void>(builder: (_) => WebViewPage(url: url, title: title));
  }

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  InAppWebViewController? webViewController;
  String currentUrl = '';
  String pageTitle = '';
  bool isLoading = true;
  double progress = 0;
  bool canGoBack = false;
  bool canGoForward = false;

  @override
  void initState() {
    super.initState();
    currentUrl = widget.url?.toString() ?? '';
    pageTitle = widget.title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Symbols.close)),
        title: Text(pageTitle, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            onPressed: canGoBack ? () => webViewController?.goBack() : null,
            icon: const Icon(Symbols.arrow_back),
            tooltip: 'Back',
          ),
          IconButton(
            onPressed: canGoForward ? () => webViewController?.goForward() : null,
            icon: const Icon(Symbols.arrow_forward),
            tooltip: 'Forward',
          ),
          IconButton(
            onPressed: () {
              webViewController?.reload();
            },
            icon: const Icon(Symbols.refresh),
            tooltip: TR.of(context).refersh,
          ),
          PopupMenuButton<String>(
            onSelected: (value) async {
              switch (value) {
                case 'copy_url':
                  await Clipboard.setData(ClipboardData(text: currentUrl));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(TR.of(context).copiedUrlToClipboard),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                case 'open_browser':
                  if (currentUrl.isNotEmpty) {
                    await launchUrl(Uri.parse(currentUrl), mode: LaunchMode.externalApplication);
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Empty URL"), duration: Duration(seconds: 3)),
                      );
                    }
                  }
              }
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: 'copy_url',
                    child: Row(
                      children: [
                        const Icon(Symbols.content_copy),
                        const SizedBox(width: 8),
                        Text(TR.of(context).copyUrl),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'open_browser',
                    child: Row(
                      children: [
                        const Icon(Symbols.open_in_browser),
                        const SizedBox(width: 8),
                        Text(TR.of(context).openInBrowser),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: Column(
        children: [
          if (isLoading) LinearProgressIndicator(value: progress, backgroundColor: Colors.grey[300]),
          if (currentUrl.isEmpty)
            Expanded(
              child: NotFoundPage(
                title: widget.title,
                onRetry: () {
                  if (widget.url != null) {
                    setState(() {
                      currentUrl = widget.url!.toString();
                    });
                  }
                },
              ),
            ),
          if (currentUrl.isNotEmpty) _buildWebView(),
        ],
      ),
    );
  }

  Widget _buildWebView() {
    return Expanded(
      child: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(currentUrl)),
        initialSettings: InAppWebViewSettings(
          useShouldOverrideUrlLoading: true,
          mediaPlaybackRequiresUserGesture: false,
          allowsInlineMediaPlayback: true,
          iframeAllow: "camera; microphone",
          iframeAllowFullscreen: true,
        ),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        onLoadStart: (controller, url) {
          setState(() {
            currentUrl = url.toString();
            isLoading = true;
          });
        },
        onLoadStop: (controller, url) async {
          setState(() {
            currentUrl = url.toString();
            isLoading = false;
          });

          // get page title
          final title = await controller.getTitle();
          if (title != null && title.isNotEmpty) {
            setState(() {
              pageTitle = title;
            });
          }

          // update navigation state
          await _updateNavigationState();
        },
        onProgressChanged: (controller, progress) {
          setState(() {
            this.progress = progress / 100;
          });
        },
        onReceivedError: (controller, request, error) {
          setState(() {
            isLoading = false;
          });
        },
        shouldOverrideUrlLoading: (controller, navigationAction) async {
          final uri = navigationAction.request.url!;

          // allow links with http or https schemes
          if (uri.scheme == 'http' || uri.scheme == 'https') {
            return NavigationActionPolicy.ALLOW;
          }

          return NavigationActionPolicy.CANCEL;
        },
      ),
    );
  }

  Future<void> _updateNavigationState() async {
    if (webViewController != null) {
      final canGoBack = await webViewController!.canGoBack();
      final canGoForward = await webViewController!.canGoForward();
      setState(() {
        this.canGoBack = canGoBack;
        this.canGoForward = canGoForward;
      });
    }
  }
}
