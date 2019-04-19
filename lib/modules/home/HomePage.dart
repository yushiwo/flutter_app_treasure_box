import 'package:flutter/material.dart';
import 'package:flutter_app_treasure_box/modules/about/AboutPage.dart';
import 'package:flutter_app_treasure_box/modules/h5/H5Page.dart';
import 'package:flutter_app_treasure_box/modules/home/MainPage.dart';
import 'package:flutter_app_treasure_box/modules/myproject/MyProjectPage.dart';
import 'package:flutter_app_treasure_box/modules/routes.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Free Tools',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '百宝箱'),
      routes: routes,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      drawer: _buildDrawer(),  // 侧边栏

      body: new MainPage(),  // 主页
    );
  }

  // 抽屉布局
  Widget _buildDrawer() {
    return new Drawer(     //侧边栏按钮Drawer
      child: new ListView(
        children: <Widget>[
          new UserAccountsDrawerHeader(   //Material内置控件
            accountName: new Text('宇是我'), //用户名
            accountEmail: new Text('zhengrui504@163.com'),  //用户邮箱
            currentAccountPicture: new GestureDetector( //用户头像
              onTap: () => print('current user'),
              child: new CircleAvatar(    //圆形图标控件
                backgroundImage: new NetworkImage('https://avatars0.githubusercontent.com/u/6859852?s=460&v=4'),//图片调取自网络
              ),
            ),
            decoration: new BoxDecoration(    //用一个BoxDecoration装饰器提供背景图片
              image: new DecorationImage(
                fit: BoxFit.fill,
                image: new ExactAssetImage('images/lake.jpg'),
              ),
            ),
          ),
          new ListTile(
              title: new Text('我的简书主页'),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new H5Page(title: "个人简书主页",url: "https://www.jianshu.com/u/04d328e48fb5")));
              }
          ),
          new ListTile(
              title: new Text('我的掘金主页'),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();   //点击后收起侧边栏
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new H5Page(title: "个人掘金主页",url: "https://juejin.im/user/581bee048ac247004fe10cab/posts")));
              }
          ),
          new ListTile(
              title: new Text('我的Github主页'),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();   //点击后收起侧边栏
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new H5Page(title: "个人Github主页",url: "https://github.com/yushiwo")));
              }
          ),
          new ListTile(
              title: new Text('我的作品'),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();   //点击后收起侧边栏
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new MyProjectPage()));
              }
          ),
          new Divider(),    //分割线控件
          new ListTile(   //退出按钮
            title: new Text('关于作者'),
            trailing: new Icon(Icons.arrow_right),
            onTap: () {
              Navigator.of(context).pop();   //点击后收起侧边栏
              Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new AboutPage(id: "https://yushiwo.github.io/")));
            }

          ),
        ],
      ),
    );
  }

}
