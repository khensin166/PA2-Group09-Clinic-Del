import 'dart:convert';
import 'package:clinicapp/Constants/url.dart';
import 'package:clinicapp/Model/appointment_model.dart';
import 'package:clinicapp/Provider/Database/db_provider.dart';
import 'package:http/http.dart' as http;

class GetUserAppointment {
  final url = AppUrl.baseUrl;

  Future<AppointmentModel> getAppointment() async {
    final userId = await DatabaseProvider().getUserId();
    final token = await DatabaseProvider().getToken();

    String _url = "$url/appointments-auth";

    try {
      final request =
          await http.get(Uri.parse(_url), headers: {'Authorization': '$token'});

      print(request.statusCode);

      if (request.statusCode == 200 || request.statusCode == 201) {
        print(request.body);

        if (json.decode(request.body)['data'] == null) {
          return AppointmentModel();
        } else {
          final appointmentModel = appointmentModelFromJson(request.body);
          // Sorting appointments by id in descending order
          appointmentModel.data!.sort((a, b) => b.id!.compareTo(a.id!));
          return appointmentModel;
        }
      } else {
        print(request.body);
        return AppointmentModel();
        // Returning an empty model in case of error
      }
    } catch (e) {
      print(e);
      return Future.error(e.toString());
    }
  }
}
