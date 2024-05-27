import 'dart:convert';

class UserModel {
  String? address;
  int? age;
  String? birthday;
  String? gender;
  int? height;
  int? id;
  String? name;
  int? nik;
  String? phone;
  int? role;
  String? username;
  int? weight;
  String? profilePicture;

  UserModel({
    this.address,
    this.age,
    this.birthday,
    this.gender,
    this.height,
    this.id,
    this.name,
    this.nik,
    this.phone,
    this.role,
    this.username,
    this.weight,
    this.profilePicture,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      address: json["address"],
      age: json["age"],
      birthday: json["birthday"],
      gender: json["gender"],
      height: json["height"],
      id: json["id"],
      name: json["name"],
      nik: json["nik"],
      phone: json["phone"],
      role: json["role"],
      username: json["username"],
      weight: json["weight"],
      profilePicture: json["profilePicture"],
    );
  }

  Map<String, dynamic> toJson() => {
        "address": address,
        "age": age,
        "birthday": birthday,
        "gender": gender,
        "height": height,
        "id": id,
        "name": name,
        "nik": nik,
        "phone": phone,
        "role": role,
        "username": username,
        "weight": weight,
        "profilePicture": profilePicture,
      };
}

UserModel userModelFromJson(String str) {
  final jsonData = json.decode(str);
  return UserModel.fromJson(jsonData['data']);
}

String userModelToJson(UserModel data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}
