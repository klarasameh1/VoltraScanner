import 'dart:convert';
import 'package:event_scanner_app/core/utils/api_response.dart';
import 'package:http/http.dart' as http;

class QrService {
  Future<ApiResponse<Map<String, dynamic>>> verifyToken(
      int id, int eventId) async {
    try {
      print("📡 Sending request to API...");
      print("📤 Data: id=$id, event_id=$eventId");

      final response = await http.post(
        Uri.parse("https://node-core-1qx9.vercel.app/api/events/verify-qr"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id": id,
          "event_id": eventId,
        }),
      );

      print("📥 Status Code: ${response.statusCode}");
      print("📥 Response Body: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print("✅ API call successful!");
        return ApiResponse.success(data);
      } else {
        print("❌ API error: ${data["message"] ?? "Unknown error"}");
        return ApiResponse.error(data["message"] ?? "Unknown server error");
      }
    } catch (e) {
      print("💥 Network error: $e");
      return ApiResponse.error('Network error: $e');
    }
  }
}