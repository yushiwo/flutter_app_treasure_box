import 'package:flutter/material.dart';
import 'package:flutter_app_treasure_box/modules/h5/H5Page.dart';

// ignore: must_be_immutable
class MyProjectPage extends StatelessWidget {

  BuildContext mContext;

  @override
  Widget build(BuildContext context) {
    mContext = context;

    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("我的作品"),
      ),
      
      body: new Padding(
        padding: new EdgeInsets.all(16.0),
        child: new Column(
          children: <Widget>[
            // 第一排
            new Padding(
              padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
              child: new Row(
                children: <Widget>[
                  // 财报说
                  getProjectView("images/ic_logo_cbs.png", "财报说", "https://caibaoshuo.com/"),

                  // OTC场外
                  getProjectView("images/ic_logo_otc.png", "场外交易", "https://otcbtc.io/")
                ],
              ),
            ),


            // 第二排
            new Padding(
              padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
              child: new Row(
                children: <Widget>[
                  // exchange
                  getProjectView("images/ic_logo_exchange.png", "币币交易", "https://bb.otcbtc.io/exchange/markets/btceth"),

                  // kada
                  getProjectView("images/ic_logo_kada.png", "网易咔搭编程", "https://kada.163.com/")
                ],
              ),
            ),

            // 第三排
            new Padding(
              padding: new EdgeInsets.all(0.0),
              child: new Row(
                children: <Widget>[
                  // 网易100分
                  getProjectView("images/ic_logo_100.png", "网易100分", "https://100.163.com/"),
                  getProjectView("images/ic_logo_qlive.png", "网易青果", "https://qlive.163.com/cloudhkweb/index.html")
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget getProjectView(String imagePath, String projectName, String jumpUrl) {
    return new Expanded(
      flex: 1,
      child: new InkWell(
        child: new Card(
            child: new Padding(
              padding: new EdgeInsets.all(16.0),
              child: new Column(
                children: <Widget>[

                  new Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(imagePath),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),

                  new Padding(
                    padding: new EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 0.0),
                    child: new Text(
                      projectName,
                      style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                    ),
                  )

                ],
              ),
            )
        ),
        onTap: () {
          Navigator.of(mContext).push(new MaterialPageRoute(builder: (BuildContext context) => new H5Page(title: projectName,url: jumpUrl)));
        },
      )


    );
  }

}