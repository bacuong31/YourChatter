class DetailBlogRequestModel {
  String articleId;

  DetailBlogRequestModel({this.articleId});

  DetailBlogRequestModel.fromJson(Map<String, dynamic> json) {
    articleId = json['articleId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['articleId'] = this.articleId;
    return data;
  }
}
