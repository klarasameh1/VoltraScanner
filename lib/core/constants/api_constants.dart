class ApiConstants {
  static const String baseUrl = "https://your-api.com";
  static const String checkIn = "/api/events/verify-qr";
  static const String upcomingEvents = "/events/upcoming";
}

// Uri.parse("${ApiConstants.baseUrl}${ApiConstants.upcomingEvents}");