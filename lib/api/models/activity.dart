class ActivityModel {
  final String id;
  final double lat;
  final double long;
  final String name;
  final String day;
  final String time;
  final String location;

  ActivityModel({
    required this.id,
    required this.lat,
    required this.long,
    required this.name,
    required this.day,
    required this.time,
    required this.location,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['_id'],
      lat:json['lat'],
      long:json['long'],
      name: json['name'],
      day:json['day'],
      time:json['time'],  
      location:json['location'],    
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lat': lat,
      'long': long,
      'name': name,
      'day': day,
      'time': time,
      'location': location,
    };
  }
}
