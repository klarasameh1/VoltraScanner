class Event {
  final int id;
  final String name;
  final DateTime date;
  final String time;
  final String city;
  final String description;
  final String type;
  final String category;
  final List<Speaker> speakers;
  final List<String> photos;
  int checkedInCount; // من غير final

  Event({
    required this.id,
    required this.name,
    required this.date,
    required this.time,
    required this.city,
    required this.description,
    required this.type,
    required this.category,
    required this.speakers,
    required this.photos,
    required this.checkedInCount,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    DateTime dateTime;

    try {
      String date = json["date"];
      String? time = json["time"];

      if (time != null) {

        String dateOnly = date.split("T")[0];

        dateTime = DateTime.parse("$dateOnly $time");
      } else {
        dateTime = DateTime.parse(date);
      }

      dateTime = dateTime.toLocal(); // important for timezone
    } catch (e) {
      dateTime = DateTime.now();
    }

    return Event(
      id: json["event_id"],
      name: json["title"],
      date: dateTime,
      time: _formatTime(dateTime),
      city: json["city"] ?? "N/A",
      description: json["description"] ?? "",
      type: json["type"] ?? "offline",
      category: json["category"] ?? "N/A",
      speakers: (json["event_speakers"] as List?)
          ?.map((s) => Speaker.fromJson(s))
          .toList() ?? [],
      photos: (json["photos"] as List?)?.cast<String>() ?? [],
      checkedInCount: json["checkedInCount"] ?? 0,
    );
  }

  static String _formatTime(DateTime dateTime) {
    int hour = dateTime.hour;
    int minute = dateTime.minute;
    String period = hour >= 12 ? 'PM' : 'AM';
    int hour12 = hour % 12;
    hour12 = hour12 == 0 ? 12 : hour12;
    return '$hour12:${minute.toString().padLeft(2, '0')} $period';
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "date": date.toIso8601String(),
      "time": time,
      "city": city,
      "description": description,
      "type": type,
      "category": category,
      "speakers": speakers.map((s) => s.toJson()).toList(),
      "photos": photos,
      "checkedInCount": checkedInCount,
    };
  }

  Event copyWith({
    int? id,
    String? name,
    DateTime? date,
    String? time,
    String? city,
    String? description,
    String? type,
    String? category,
    List<Speaker>? speakers,
    List<String>? photos,
    int? checkedInCount,
  }) {
    return Event(
      id: id ?? this.id,
      name: name ?? this.name,
      date: date ?? this.date,
      time: time ?? this.time,
      city: city ?? this.city,
      description: description ?? this.description,
      type: type ?? this.type,
      category: category ?? this.category,
      speakers: speakers ?? this.speakers,
      photos: photos ?? this.photos,
      checkedInCount: checkedInCount ?? this.checkedInCount,
    );
  }
}

class Speaker {
  final int id;
  final String name;
  final String position;

  Speaker({
    required this.id,
    required this.name,
    required this.position,
  });

  factory Speaker.fromJson(Map<String, dynamic> json) {
    return Speaker(
      id: json["speaker_id"],
      name: json["name"],
      position: json["position"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "speaker_id": id,
      "name": name,
      "position": position,
    };
  }

  Speaker copyWith({
    int? id,
    String? name,
    String? position,
  }) {
    return Speaker(
      id: id ?? this.id,
      name: name ?? this.name,
      position: position ?? this.position,
    );
  }
}