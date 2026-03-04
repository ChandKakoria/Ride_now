class VehicleModel {
  final String? id;
  final String name;
  final String model;
  final String color;

  VehicleModel({
    this.id,
    required this.name,
    required this.model,
    required this.color,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id']?.toString() ?? json['_id']?.toString(),
      name: json['name'] ?? json['vehicle_name'] ?? "",
      model: json['model'] ?? json['vehicle_model'] ?? "",
      color: json['color'] ?? json['vehicle_color'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'vehicle_name': name,
      'vehicle_model': model,
      'vehicle_color': color,
    };
  }
}
