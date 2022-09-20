final TIMESTABLENAME = "timetable";

class TimeModelDBFields {
  static const String id = "_id";
  static const String lltype = "lltype";
  static const String llcase = "llcase";
  static const String time = "time";
}

class TimeModel {
  final int? id;
  final String lltype;
  final String llcase;
  final double time;

  const TimeModel({
    this.id,
    required this.lltype,
    required this.llcase,
    required this.time,
  });

  Map<String, Object?> toJson() => {
        TimeModelDBFields.id: id,
        TimeModelDBFields.lltype: lltype,
        TimeModelDBFields.llcase: llcase,
        TimeModelDBFields.time: time,
      };

  TimeModel copy({
    required int id,
    String? lltype,
    String? llcase,
    double? time,
  }) =>
      TimeModel(
        id: this.id,
        lltype: lltype ?? this.lltype,
        llcase: llcase ?? this.llcase,
        time: time ?? this.time,
      );

  static TimeModel fromJson(json) {
    return TimeModel(
        id: json[TimeModelDBFields.id] as int,
        lltype: json[TimeModelDBFields.lltype] as String,
        llcase: json[TimeModelDBFields.llcase] as String,
        time: json[TimeModelDBFields.time].toDouble(),
      );
  }
}
