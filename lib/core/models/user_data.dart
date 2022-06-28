class UserModel {
  String? name;
  String? email;
  String? phone;
  String? image;
  String? cover;
  String? bio;
  String? uId;

  UserModel({
    this.name,
    this.email,
    this.phone,
    this.image,
    this.cover,
    this.bio,
    this.uId,
  });

  UserModel.fromMap(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    email = json['email'] ?? '';
    phone = json['phone'] ?? '';
    image = json['image'] ?? '';
    cover = json['cover'] ?? '';
    bio = json['bio'] ?? '';
    uId = json['uId'] ?? '';
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'email': email,
    'phone': phone,
    'uId': uId,
    'bio': bio,
    'image': image,
    'cover': cover,
  };
}