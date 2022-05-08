class UserModel {
  String? name;
  String? email;
  String? phone;
  String? uId;
  String? imageUrl;

  UserModel({
    this.name,
    this.email,
    this.phone,
    this.uId,
    this.imageUrl,
  });

  UserModel.fromMap(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    uId = json['uId'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'email': email,
    'phone': phone,
    'uId': uId,
    'imageUrl': imageUrl,
  };
}