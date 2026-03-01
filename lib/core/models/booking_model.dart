class BookingModel {
  final String? name;
  final String? userId;

  BookingModel({this.name, this.userId});

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(name: json['name'], userId: json['user_id']);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'user_id': userId};
  }
}
