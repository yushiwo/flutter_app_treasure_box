class Joke {
  String content;
  String hashId;
  int unixtime;
  String updatetime;

  Joke({this.content, this.hashId, this.unixtime, this.updatetime});


  factory Joke.fromJson(Map<String, dynamic> parsedJson){
    return Joke(
      content: parsedJson['content'],
      hashId: parsedJson['hashId'],
      unixtime: parsedJson['unixtime'],
      updatetime: parsedJson['updatetime'],
    );
  }

  @override
  String toString() {
    return 'Joke{content: $content, hashId: $hashId, unixtime: $unixtime, updatetime: $updatetime}';
  }
}
