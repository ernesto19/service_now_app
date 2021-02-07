import 'package:flutter/material.dart';
import 'package:service_now/features/professional/presentation/widgets/animation_fab.dart';
import 'package:service_now/widgets/success_page.dart';
import 'home_page.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  static final routeName = 'change_password_page';

  final String url;

  const WebViewPage({ @required this.url });

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Realiza tu pago'),
      ),
      body: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        javascriptChannels: <JavascriptChannel>[
          JavascriptChannel(
            name: 'MessageInvoker',
            onMessageReceived: (s) {
              Navigator.of(context).push(FadeRouteBuilder(page: SuccessPage(message: 'Su pago ha sido realizado exitosamente. El profesional lo atenderá según lo acordado.', assetImage: 'assets/images/check.png', page: Container(), levelsNumber: 1, pageName: HomePage.routeName)));
            }
          ),
        ].toSet(),
      )
    );
  }
}