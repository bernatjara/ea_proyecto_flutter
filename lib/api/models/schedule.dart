class ScheduleModel {
  final String id;
  final String name;
  final String clase;
  final int start;
  final int duration;

  ScheduleModel({
    required this.id,
    required this.name,
    required this.clase,
    required this.duration,
    required this.start,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['_id'],
      name: json['name'],
      clase: json['clase'],
      start: json['start'],
      duration: json['duration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'clase': clase,
      'start': start,
      'duration': duration,
    };
  }
}
