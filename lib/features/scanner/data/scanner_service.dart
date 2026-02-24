import 'dart:async';

class ScannerService {
  Future<Map<String, dynamic>> validateTicket(String ticketId) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Dummy responses for testing
    if (ticketId == "VALID") {
      return {"status": "valid", "user_name": "Ahmed"};
    } else if (ticketId == "USED") {
      return {"status": "already_used"};
    } else {
      return {"status": "not_found"};
    }
  }
}