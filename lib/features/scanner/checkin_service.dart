/// DUMMY DATA
class CheckinService {
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
//   Future<Map<String, dynamic>> verifyToken(String token) async {
//     final response = await http.post(
//       Uri.parse("$baseUrl/checkin"),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({"qr_code": token}),
//     );
//
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body); // الباك هيرجع {"status": "...", "message": "..."}
//     } else {
//       return {
//         "status": "error",
//         "message": "Server error"
//       };
//     }
//   }
// }