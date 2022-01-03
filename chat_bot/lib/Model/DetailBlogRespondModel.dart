import 'BlogRespondModel.dart';
import 'dart:convert';
DetailBlogRespondModel detailBlogRespondJson(String str) =>
    DetailBlogRespondModel.fromJson(json.decode(str));
class DetailBlogRespondModel {
  String status;
  Blog blog;

  DetailBlogRespondModel({this.status, this.blog});

  DetailBlogRespondModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    blog = json['blog'] != null ? new Blog.fromJson(json['blog']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.blog != null) {
      data['blog'] = this.blog.toJson();
    }
    return data;
  }
}

class Blog {
  String sId;
  String title;
  List<Tag> tag;
  String desc;
  String createOn;
  String content;
  String articleId;
  String imageLink;

  Blog(
      {this.sId,
        this.title,
        this.tag,
        this.desc,
        this.createOn,
        this.content,
        this.articleId,
        this.imageLink});

  Blog.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    if (json['tag'] != null) {
      tag = <Tag>[];
      json['tag'].forEach((v) {
        tag.add(new Tag.fromJson(v));
      });
    }
    desc = json['desc'];
    createOn = json['createOn'];
    content = json['content'];
    articleId = json['articleId'];
    imageLink = json['imageLink'] != null ? json['imageLink'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    if (this.tag != null) {
      data['tag'] = this.tag.map((v) => v.toJson()).toList();
    }
    data['desc'] = this.desc;
    data['createOn'] = this.createOn;
    data['content'] = this.content;
    data['articleId'] = this.articleId;
    data['imageLink'] = this.imageLink;
    return data;
  }
}


