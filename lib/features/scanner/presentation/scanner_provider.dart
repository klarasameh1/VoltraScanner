import 'package:flutter/material.dart';
import '../data/scanner_service.dart';

class ScannerProvider extends ChangeNotifier {
  final ScannerService service = ScannerService();

  String status = '';
  String userName = '';
  bool isLoading = false;

  Future<void> scanTicket(String ticketId) async {
    if (ticketId.isEmpty) return;

    isLoading = true;
    notifyListeners();

    final response = await service.validateTicket(ticketId);

    status = response['status'] ?? 'unknown';
    userName = response['user_name'] ?? '';
    isLoading = false;

    notifyListeners();
  }
}