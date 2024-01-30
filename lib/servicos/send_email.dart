// ignore_for_file: unused_local_variable

import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> sendEmail({required String name,required String email,required String confirmationCode,}) async {
  const serviceId = 'service_1oc3r7m';
  const templateId = 'template_hp6m0y4';
  const userId = 'jOVrREwLpdap2AzSE';

  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'origin': 'http://localhost',
    },
    body: json.encode({
      'service_id': serviceId,
      'template_id': templateId,
      'user_id': userId,
      'template_params': {
        'user_name': name,
        'user_email': email,
        'confirmation_code': confirmationCode,
      },
    }),
  );
}
