import 'dart:convert';
import 'package:intl/intl.dart';

ReminderModel reminderModelFromJson(String str) =>
    ReminderModel.fromJson(json.decode(str));

String reminderModelToJson(ReminderModel data) => json.encode(data.toJson());

class ReminderModel {
  List<Datum>? data;
  String? message;

  ReminderModel({
    this.data,
    this.message,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) => ReminderModel(
        data: json["data"] != null
            ? List<Datum>.from(json["data"].map((x) => Datum.fromJson(x)))
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

class Datum {
  int? duration;
  String? firstTime;
  int? id;
  String? name;
  String? secondTime;
  DateTime? startDate;
  String? thirdTime;

  Datum({
    this.duration,
    this.firstTime,
    this.id,
    this.name,
    this.secondTime,
    this.startDate,
    this.thirdTime,
  });

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      duration: json['duration'],
      firstTime: json['first_time'],
      id: json['id'],
      name: json['name'],
      secondTime: json['second_time'],
      startDate: DateFormat('yyyy-MM-dd')
          .parse(json['start_date']), // Parsing tanggal menggunakan DateFormat
      thirdTime: json['third_time'],
    );
  }

  Map<String, dynamic> toJson() => {
        'duration': duration,
        'first_time': firstTime,
        'id': id,
        'name': name,
        'second_time': secondTime,
        'start_date': DateFormat('yyyy-MM-dd')
            .format(startDate!), // Format tanggal menggunakan DateFormat
        'third_time': thirdTime,
      };
}
