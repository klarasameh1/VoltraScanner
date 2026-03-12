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

    final dateTime = DateTime.parse(json["date"]);

    return Event(
      id: json["event_id"],
      name: json["title"],
      date: dateTime,
      time: "${dateTime.hour}:${dateTime.minute}",
      checkedInCount: 0,
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