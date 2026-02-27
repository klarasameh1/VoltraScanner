import 'dart:convert';
import 'package:event_scanner_app/core/constants/api_constants.dart';

/// DUMMY DATA
class QrService {
  Future<Map<String, dynamic>> verifyToken(String token) async {
    await Future.delayed(const Duration(seconds: 1));

    if (token == "123") {
      return {
        "status": "success",
        "message": "Check-in successful"
      };
    } else {
      return {
        "status": "error",
        "message": "Invalid QR Code"
      };
    }
  }
}

/// TO DO:  REPLACE WITH THIS WHEN API IS READY

// class CheckinService {
//   final String baseUrl = "https://yourbackend.com/api";
//
// Future<Map<String, dynamic>> verifyToken(String token) async {
//   final response = await http.post(
//     Uri.parse("${ApiConstants.baseUrl}/checkin"),
//     headers: {
//       "Content-Type": "application/json",
//     },
//     body: jsonEncode({
//       "token": token,
//     }),
//   );
//
//   final data = jsonDecode(response.body);
//   return data;
// }