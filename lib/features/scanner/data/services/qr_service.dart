import 'dart:convert';
import 'package:event_scanner_app/core/constants/api_constants.dart';
import 'package:event_scanner_app/core/utils/api_response.dart';
import 'package:http/http.dart' as http;

class QrService {
  // Dummy data مؤقتاً
  Future<ApiResponse<Map<String, dynamic>>> verifyToken(String token) async {
    await Future.delayed(const Duration(seconds: 1));

    if (token == "123") {
      return ApiResponse.success({
        "status": "success",
        "message": "Check-in successful"
      });
    } else {
      return ApiResponse.error("Invalid QR Code");
    }
  }

/// Real Code with API
/*
  Future<ApiResponse<Map<String, dynamic>>> verifyToken(String token) async {
    try {
      final response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}${ApiConstants.checkin}"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "token": token,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return ApiResponse.success(data);
      } else {
        return ApiResponse.error(data['message'] ?? 'Check-in failed');
      }
    } catch (e) {
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }
  */
}