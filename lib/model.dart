class KehadiranModel {
  String username;
  String name;
  String seat_number;
  String room_name;
  String attendance;
 
  KehadiranModel({this.username, this.name, this.seat_number, this.room_name, this.attendance});
 
  factory KehadiranModel.fromJson(Map<String, dynamic> json) {
    return KehadiranModel(
      username: json['username'] as String,
      name: json['name'] as String,
      seat_number: json['seat_number'] as String,
      room_name: json['room_name'] as String,
      attendance: json['attendance'] as String,
    );
  }
}
