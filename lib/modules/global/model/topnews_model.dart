/// 新闻头条
class TopNews {
  String uniquekey;
  String title;
  String date;
  String category;
  String author_name;
  String url;
  String thumbnail_pic_s;
  String thumbnail_pic_s02;
  String thumbnail_pic_s03;

  TopNews(this.uniquekey, this.title, this.date, this.category,
      this.author_name, this.url, this.thumbnail_pic_s, this.thumbnail_pic_s02,
      this.thumbnail_pic_s03);

  @override
  String toString() {
    return 'TopNews{uniquekey: $uniquekey, title: $title, date: $date, category: $category, author_name: $author_name, url: $url, thumbnail_pic_s: $thumbnail_pic_s, thumbnail_pic_s02: $thumbnail_pic_s02, thumbnail_pic_s03: $thumbnail_pic_s03}';
  }


}