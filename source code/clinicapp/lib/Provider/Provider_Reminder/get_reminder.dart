import 'dart:convert';
import 'package:clinicapp/Constants/url.dart';
import 'package:clinicapp/Model/reminder_model.dart';
import 'package:clinicapp/Provider/Database/db_provider.dart';
import 'package:http/http.dart' as http;

class GetUserReminder {
  final url = AppUrl.baseUrl;

  Future<ReminderModel> getReminder({required String date}) async {
    // Tambahkan parameter date
    final token = await DatabaseProvider().getToken();

    // Sertakan parameter tanggal dalam URL
    String _url = "$url/reminders-auth/${date.toString()}";

    try {
      final request =
          await http.get(Uri.parse(_url), headers: {'Authorization': '$token'});

      print(request.statusCode);

      if (request.statusCode == 200 || request.statusCode == 201) {
        print(request.body);

        if (json.decode(request.body)['data'] == null) {
          return ReminderModel();
        } else {
          final reminderModel = reminderModelFromJson(request.body);
          // Sorting appointments by id in descending order
          reminderModel.data!.sort((a, b) => b.id!.compareTo(a.id!));
          return reminderModel;
        }
      } else {
        print(request.body);
        return ReminderModel();
        // Returning an empty model in case of error
      }
    } catch (e) {
      print(e);
      return Future.error(e.toString());
    }
  }
}
