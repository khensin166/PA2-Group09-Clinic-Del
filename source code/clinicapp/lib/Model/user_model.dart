// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    String? address;
    int? age;
    String? birthday;
    int? exp;
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
        this.exp,
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

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        address: json["address"],
        age: json["age"],
        birthday: json["birthday"],
        exp: json["exp"],
        gender: json["gender"],
        height: json["height"],
        id: json["id"],
        name: json["name"],
        nik: json["nik"],
        phone: json["phone"],
        role: json["role"],
        username: json["username"],
        profilePicture: json["profilePicture"],
        weight: json["weight"],
    );

    Map<String, dynamic> toJson() => {
        "address": address,
        "age": age,
        "birthday": birthday,
        "exp": exp,
        "gender": gender,
        "height": height,
        "id": id,
        "name": name,
        "nik": nik,
        "phone": phone,
        "role": role,
        "profilePicture": profilePicture,
        "username": username,
        "weight": weight,
    };
}
