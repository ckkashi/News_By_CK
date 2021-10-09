class FavNewsModel {
  String? id;
  String? userId;
  String? author;
  String? title;
  String? description;
  String? url;
  String? urlToImage;
  String? publishedAt;
  String? content;

  // FavNewsModel(
  //     {this._id,
  //     this.userId,
  //     this.author,
  //     this.title,
  //     this.description,
  //     this.url,
  //     this.urlToImage,
  //     this.publishedAt,
  //     this.content});

  FavNewsModel(String _id,String userId,String author,String title,String description,String url,String urlToImage,String publishedAt,String content){
    this.id = _id;
    this.userId = userId;
    this.author = author;
      this.title = title;
      this.description = description;
      this.url = url;
      this.urlToImage = urlToImage ;
      this.publishedAt = publishedAt;
      this.content = content;
  }

  FavNewsModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    userId = json['userId'];
    author = json['author'];
    title = json['title'];
    description = json['description'];
    url = json['url'];
    urlToImage = json['urlToImage'];
    publishedAt = json['publishedAt'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['userId'] = this.userId;
    data['author'] = this.author;
    data['title'] = this.title;
    data['description'] = this.description;
    data['url'] = this.url;
    data['urlToImage'] = this.urlToImage;
    data['publishedAt'] = this.publishedAt;
    data['content'] = this.content;
    return data;
  }
}
