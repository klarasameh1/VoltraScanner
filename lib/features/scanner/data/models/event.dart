class Event {
  final int id;
  final String name;
  final DateTime date;
  final String time;
  int checkedInCount;

  Event({
    required this.id,
    required this.name,
    required this.date,
    required this.time,
    required this.checkedInCount,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json["id"],
      name: json["name"],
      date: DateTime.parse(json["date"]),
      time: json["time"],
      checkedInCount: json["checkedInCount"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "date": date.toIso8601String(),
      "time": time,
      "checkedInCount": checkedInCount,
    };
  }

  Event copyWith({
    int? id,
    String? name,
    DateTime? date,
    String? time,
    int? checkedInCount,
  }) {
    return Event(
      id: id ?? this.id,
      name: name ?? this.name,
      date: date ?? this.date,
      time: time ?? this.time,
      checkedInCount: checkedInCount ?? this.checkedInCount,
    );
  }
}