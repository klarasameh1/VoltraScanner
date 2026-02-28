class Event {
  final int id;
  final String name;
  final String date;
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
      date: json["date"],
      time: json["time"],
      checkedInCount: json["checkedInCount"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "date": date,
      "time": time,
      "checkedInCount": checkedInCount,
    };
  }

  Event copyWith({
    int? id,
    String? name,
    String? date,
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