import 'dart:convert';

AppointmentModel appointmentModelFromJson(String str) =>
    AppointmentModel.fromJson(json.decode(str));

String appointmentModelToJson(AppointmentModel data) =>
    json.encode(data.toJson());

class AppointmentModel {
  List<Data>? data;
  String? message;

  AppointmentModel({
    this.data,
    this.message,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) =>
      AppointmentModel(
        data: json["data"] != null
            ? List<Data>.from(json["data"].map((x) => Data.fromJson(x)))
            : null,
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data != null
            ? List<dynamic>.from(data!.map((x) => x.toJson()))
            : null,
        "message": message,
      };
}

class Data {
  dynamic approved;
  String? complaint;
  DateTime? date;
  int? id;
  DateTime? time;

  Data({
    this.approved,
    this.complaint,
    this.date,
    this.id,
    this.time,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        approved: json["approved"],
        complaint: json["complaint"],
        date: json["date"] != null ? DateTime.parse(json["date"]) : null,
        id: json["id"],
        time: json["time"] != null ? DateTime.parse(json["time"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "approved": approved,
        "complaint": complaint,
        "date": date?.toIso8601String(),
        "id": id,
        "time": time?.toIso8601String(),
      };
}
