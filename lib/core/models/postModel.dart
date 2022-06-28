class PostModel {
  String? name;
  String? image;
  String? uId;
  String? dateTime;
  String? text;
  String? postImage;


  PostModel({
    this.name,
    this.text,
    this.dateTime,
    this.image,
    this.postImage,
    this.uId,
  });

  PostModel.fromMap(Map<String, dynamic> json) {
    name = json['name'];
    text = json['text'];
    dateTime = json['dateTime'];
    image = json['image'];
    postImage = json['postImage'];
    uId = json['uId'];
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'text': text,
    'uId': uId,
    'dateTime': dateTime,
    'image': image,
    'postImage': postImage,
  };
}
