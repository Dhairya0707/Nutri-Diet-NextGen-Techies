import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Webwid extends StatefulWidget {
  const Webwid({super.key});

  @override
  State<Webwid> createState() => _WebwidState();
}

class _WebwidState extends State<Webwid> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: InAppWebView(
          initialUrlRequest: URLRequest(
              url: WebUri(
                  "https://app.powerbi.com/view?r=eyJrIjoiNjYzYTg0ZTQtNGIwMi00NWNhLWJmZGUtMGQzOGEyMDg2YzZiIiwidCI6ImRmODY3OWNkLWE4MGUtNDVkOC05OWFjLWM4M2VkN2ZmOTVhMCJ9 ")),
        ));
  }
}
