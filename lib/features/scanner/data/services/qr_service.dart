import 'dart:convert';
import 'package:event_scanner_app/core/utils/api_response.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class QrService {
  String get baseUrl {
    if (kIsWeb) {
      return "/api"; //For Netlify proxy
    } else {
      return "https://node-core-1qx9.vercel.app/api";
    }
  }

  // Modified: now accepts a single token parameter
  Future<ApiResponse<Map<String, dynamic>>> verifyToken(String token) async {
    try {
      if (token.isEmpty) {
        return ApiResponse.error("Invalid token");
      }

      debugPrint("📡 Sending request...");
      debugPrint("📤 token=$token");

      final response = await http
          .post(
        Uri.parse("$baseUrl/events/verify-qr"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "qrData": token, // Send only token
        }),
      )
          .timeout(const Duration(seconds: 10));

      debugPrint("📥 Status: ${response.statusCode}");
      debugPrint("📥 Body: ${response.body}");

      if (response.body.isEmpty) {
        return ApiResponse.error("Empty response from server");
      }

      // Safe JSON parsing
      Map<String, dynamic> data;
      try {
        data = jsonDecode(response.body);
      } catch (e) {
        return ApiResponse.error("Invalid JSON response");
      }

      // Status Code
      if (response.statusCode == 200 || response.statusCode == 201) {
        bool isSuccess =
            data["success"] == true ||
                data["status"] == "success" ||
                data["statusCode"] == 200 ||
                (data["data"] is Map &&
                    (data["data"]["success"] == true ||
                        data["data"]["status"] == "success"));

        if (isSuccess) {
          debugPrint("✅ Success");
          return ApiResponse.success(data);
        } else {
          String errorMsg = data["message"] ??
              data["msg"] ??
              data["error"] ??
              "Check-in failed";

          return ApiResponse.error(errorMsg);
        }
      } else {
        String errorMsg = data["message"] ??
            data["msg"] ??
            data["error"] ??
            "Server error: ${response.statusCode}";

        return ApiResponse.error(errorMsg);
      }
    } catch (e) {
      debugPrint("💥 Error: $e");
      return ApiResponse.error("Network error: $e");
    }
  }
}