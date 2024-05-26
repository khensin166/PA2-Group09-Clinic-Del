class UploadProfilePicModel {
    String image;
    String message;
    String status;

    UploadProfilePicModel({
        required this.image,
        required this.message,
        required this.status,
    });

    factory UploadProfilePicModel.fromJson(Map<String, dynamic> json) => UploadProfilePicModel(
        image: json["image"] ?? "",
        message: json["message"] ?? "",
        status: json["status"],
    );
}
