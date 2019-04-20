// 新闻列表页

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app_treasure_box/modules/global/model/topnews_model.dart';
import 'package:flutter_app_treasure_box/modules/global/util/Util.dart';
import 'package:flutter_app_treasure_box/modules/h5/H5Page.dart';

class NewsListPage extends StatefulWidget {
  
  final String typeKey;
  
  @override
  State<StatefulWidget> createState() {
    return new NewsState();
  }

  NewsListPage(this.typeKey);

}


class NewsState extends State<NewsListPage> {

  var tabMap;

  final String _url = 'http://v.juhe.cn/toutiao/index?';

  @override
  void initState() {
    super.initState();

    tabMap = {
      "头条": "top",
      "社会": "shehui",
      "国内": "guonei",
      "国际": "guoji",
      "娱乐": "yule",
      "体育": "tiyu",
      "军事": "junshi",
      "科技": "keji",
      "财经": "caijing",
      "时尚": "shishang",
    };
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new RefreshIndicator(
        child: new FutureBuilder(   //用于懒加载的FutureBuilder对象
          future: get(tabMap[widget.typeKey]),   //HTTP请求获取数据，将被AsyncSnapshot对象监视
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:        //get未执行时
              case ConnectionState.waiting:     //get正在执行时
                return new Center(
                  child: new Card(
                    child: new SizedBox(
                      width: 40.0,
                      height: 40.0,
                      child: new CircularProgressIndicator(
                        backgroundColor: Colors.blue,
                      ),
                    ),    //在页面中央显示正在加载
                  ),
                ) ;
              default:
                if (snapshot.hasError)    //get执行完成但出现异常
                  return new Text('Error: ${snapshot.error}');
                else  //get正常执行完成
                  // 创建列表，列表数据来源于snapshot的返回值，而snapshot就是get(widget.newsType)执行完毕时的快照
                  // get(widget.newsType)执行完毕时的快照即函数最后的返回值。
                  return createListView(context, snapshot);
            }
          },
        ),
        onRefresh: loadData,
      ),
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot){
    // print(snapshot.data);
    List values;
    values = jsonDecode(snapshot.data)['result']!=null ? jsonDecode(snapshot.data)['result']['data']:[''];
    switch (values.length) {
      case 0:   //没有获取到数据，则返回请求失败的原因
        return new Center(
          child: new Card(
            child: new Text(jsonDecode(snapshot.data)['reason']),
          ),
        );
      default:
        return  new ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            itemCount: values == null ? 0 : values.length,
            itemBuilder: (context, i) {
              return _newsRow(context, new TopNews(values[i]["uniquekey"], values[i]["title"], values[i]["date"], values[i]["category"], values[i]["author_name"], values[i]["url"], values[i]["thumbnail_pic_s"], values[i]["thumbnail_pic_s02"], values[i]["thumbnail_pic_s03"]));
            }
        );
    }
  }


  Widget _newsRow(BuildContext mContext, TopNews topNews) {
    return new Card(
      child: new InkWell(
        onTap: () {
          Navigator.of(mContext).push(new MaterialPageRoute(builder: (BuildContext context) => new H5Page(title: widget.typeKey,url: topNews.url)));
        },
        child: new Padding(
          padding: new EdgeInsets.all(16.0),
          child: new Column(
            children: <Widget>[
              // 标题
              new Padding(
                padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 12.0),
                child: new Text(
                  topNews.title,
                  style: new TextStyle(fontSize: 16.0),
                ),
              ),

              // 缩略图（3张）
              new Row(
                children: <Widget>[
                  new Expanded(
                    flex: 1,
                    child: new Padding(
                      padding: new EdgeInsets.all(4.0),
                      child: _buildThumbnail(topNews.thumbnail_pic_s),
                    )


                  ),
                  new Expanded(
                    flex: 1,
                      child: new Padding(
                        padding: new EdgeInsets.all(4.0),
                        child: _buildThumbnail(topNews.thumbnail_pic_s02),
                      )
                  ),
                  new Expanded(
                    flex: 1,
                      child: new Padding(
                        padding: new EdgeInsets.all(4.0),
                        child: _buildThumbnail(topNews.thumbnail_pic_s03),
                      )
                  ),
                ],
              ),

              // 作者 + 发布日期
              new Padding(
                padding: new EdgeInsets.fromLTRB(0.0, 6.0, 0.0, 0.0),
                child: new Row(
                  children: <Widget>[
                    // 作者
                    new Text(
                      topNews.author_name,
                      style: new TextStyle(fontSize: 12.0, color: Colors.grey),
                    ),

                    // 发布日期
                    new Padding(
                      padding: new EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 0.0),
                      child: new Text(
                        topNews.date,
                        style: new TextStyle(fontSize: 12.0, color: Colors.grey),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      )
    );
  }

  Widget _buildThumbnail(String imageUrl) {
    var content;
    if (imageUrl != null && imageUrl?.isNotEmpty) {
      //如果数据不为空，则显示Text
      content = Image.network(imageUrl);
    } else {
      //当数据为空我们需要隐藏这个Text
      //我们又不能返回一个null给当前的Widget Tree
      //只能返回一个长宽为0的widget占位
      content = new Container(height:0.0,width:0.0);
    }
    return content;
  }

  //HTTP请求的函数返回值为异步控件Future
  Future<String> get(String type) async {
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse('${_url}&type=$type&key=78680e3da065e3dc96e7facc732aa9e0'));
    var response = await request.close();
    return await response.transform(utf8.decoder).join();
  }

  Future<Null> loadData() async{
    await get(tabMap[widget.typeKey]);   //注意await关键字
    if (!mounted) return; //异步处理，防止报错
    setState(() {});//什么都不做，只为触发RefreshIndicator的子控件刷新
  }
  
}