class ProfileDataModel {
    Data data;
    String message;
    String status;

    ProfileDataModel({
        required this.data,
        required this.message,
        required this.status,
    });

    factory ProfileDataModel.fromJson(Map<String, dynamic> json) => ProfileDataModel(
        data: Data.fromJson(json["data"]),
        message: json["message"],
        status: json["status"],
    );

}

class Data {

    int id;

    String profilePicture;

    Data({

        required this.id,

        required this.profilePicture,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(

        id: json["id"],

        profilePicture: json["profilePicture"] ?? "",
    );
}
