import 'dart:convert';
BlogRespondModel blogRespondJson(String str) =>
    BlogRespondModel.fromJson(json.decode(str));
class BlogRespondModel {
  String status;
  List<BlogList> blogList;

  BlogRespondModel({this.status, this.blogList});

  BlogRespondModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['blog_list'] != null) {
      blogList = <BlogList>[];
      json['blog_list'].forEach((v) {
        blogList.add(new BlogList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.blogList != null) {
      data['blog_list'] = this.blogList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BlogList {
  String sId;
  String articleId;
  String createOn;
  String desc;
  String imageLink;
  List<Tag> tag;
  String title;

  BlogList(
      {this.sId,
        this.articleId,
        this.createOn,
        this.desc,
        this.imageLink,
        this.tag,
        this.title});

  BlogList.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    articleId = json['articleId'];
    createOn = json['createOn'];
    desc = json['desc'];
    imageLink = json['imageLink'] != null ? json['imageLink'] : null;
    if (json['tag'] != null) {
      tag = <Tag>[];
      json['tag'].forEach((v) {
        tag.add(new Tag.fromJson(v));
      });
    }
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['articleId'] = this.articleId;
    data['createOn'] = this.createOn;
    data['desc'] = this.desc;
    data['imageLink'] = this.imageLink;
    if (this.tag != null) {
      data['tag'] = this.tag.map((v) => v.toJson()).toList();
    }
    data['title'] = this.title;
    return data;
  }
}

class Tag {
  String name;
  String color;

  Tag({this.name, this.color});

  Tag.fromJson(Map<String, dynamic> json) {
    name = json['name'] != null ? json['name'] : null;
    color = json['color'] != null ? json['color'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['color'] = this.color;
    return data;
  }
}
