import 'dart:convert';
import 'package:event_scanner_app/core/utils/api_response.dart';
import 'package:http/http.dart' as http;

class QrService {
  // Dummy data
  Future<ApiResponse<Map<String, dynamic>>> verifyToken(String token) async {
    try {
      // post - to return qr status
      final response = await http.post(
        Uri.parse("https://node-core-2f9r.vercel.app/api/events/verify-qr"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"qr_code": token}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ApiResponse.success(data); // data: Map<String, dynamic>
      } else {
        return ApiResponse.error("Server error: ${response.statusCode}");
      }
    } catch (e) {
      return ApiResponse.error("Network error: $e");
    }
  }
}