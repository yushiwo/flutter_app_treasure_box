import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class H5Page extends StatefulWidget {

  final String title;
  final String url;

  H5Page({Key key, this.title, this.url}):super(key: key);

  @override
  State<StatefulWidget> createState() => H5PageState(title: this.title, url: this.url);
}

class H5PageState extends State<H5Page> {

  String title;
  String url;
  bool loaded = false;
  final flutterWebViewPlugin = FlutterWebviewPlugin();


  H5PageState({Key key, this.title, this.url});

  @override
  void initState() {
    super.initState();
    // 监听WebView的加载事件
    flutterWebViewPlugin.onStateChanged.listen((state) {
      if (state.type == WebViewState.finishLoad) {
        // 加载完成
        setState(() {
          loaded = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> titleContent = [];
    titleContent.add(Text(this.title, style: TextStyle(color: Colors.white),));
    if (!loaded) {
      titleContent.add(CupertinoActivityIndicator());
    }
    titleContent.add(Container(width: 50.0));
    return WebviewScaffold(
      url: this.url,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: titleContent,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      withZoom: false,
      withLocalStorage: true,
      withJavascript: true,
    );
  }
}