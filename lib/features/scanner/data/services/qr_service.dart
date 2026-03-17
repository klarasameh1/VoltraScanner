import 'dart:convert';
import 'package:event_scanner_app/core/utils/api_response.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class QrService {

  String get baseUrl {
    if (kIsWeb) {
      return "/api";
    } else {
      return "https://node-core-1qx9.vercel.app/api";
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> verifyToken(
      int id, int eventId) async {
    try {
      print("📡 Sending request to API...");
      print("📤 Data: id=$id, event_id=$eventId");

      final response = await http.post(
        Uri.parse("$baseUrl/events/verify-qr"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id": id,
          "event_id": eventId,
        }),
      );

      print("📥 Status Code: ${response.statusCode}");
      print("📥 Response Body: ${response.body}");

      if (response.body.isEmpty) {
        return ApiResponse.error('Empty response from server');
      }

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {

        bool isSuccess = data["success"] == true ||
            data["status"] == "success" ||
            data["statusCode"] == 200 ||
            (data["data"] != null &&
                (data["data"]["success"] == true ||
                    data["data"]["status"] == "success")) ||
            response.statusCode == 200; // fallback للـ status code

        if (isSuccess) {
          print("✅ API call successful!");
          return ApiResponse.success(data);
        } else {
          String errorMsg = data["message"] ??
              data["msg"] ??
              data["error"] ??
              "Check-in failed";
          return ApiResponse.error(errorMsg);
        }
      } else {
        // HTTP error
        String errorMsg = data["message"] ??
            data["msg"] ??
            data["error"] ??
            "Server error: ${response.statusCode}";
        return ApiResponse.error(errorMsg);
      }

    } catch (e) {
      print("💥 Network error: $e");
      return ApiResponse.error('Network error: $e');
    }
  }
}