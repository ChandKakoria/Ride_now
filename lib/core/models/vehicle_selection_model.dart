class VehicleBrand {
  final String name;
  final List<VehicleModelInfo> models;

  VehicleBrand({required this.name, required this.models});

  factory VehicleBrand.fromJson(String name, List<dynamic> json) {
    // The API returns a list containing one object with "models"
    final modelData = json.isNotEmpty ? json[0]['models'] as List : [];
    return VehicleBrand(
      name: name,
      models: modelData.map((m) => VehicleModelInfo.fromJson(m)).toList(),
    );
  }
}

class VehicleModelInfo {
  final String name;
  final List<String> colors;

  VehicleModelInfo({required this.name, required this.colors});

  factory VehicleModelInfo.fromJson(Map<String, dynamic> json) {
    return VehicleModelInfo(
      name: json['name'] ?? "",
      colors: List<String>.from(json['colors'] ?? []),
    );
  }
}

class VehicleSelectionData {
  final List<VehicleBrand> brands;

  VehicleSelectionData({required this.brands});

  factory VehicleSelectionData.fromJson(Map<String, dynamic> json) {
    final List brandsList = json['vehicles'] as List;
    final List<VehicleBrand> brands = [];

    for (var brandItem in brandsList) {
      if (brandItem is Map<String, dynamic>) {
        brandItem.forEach((brandName, brandContent) {
          brands.add(VehicleBrand.fromJson(brandName, brandContent));
        });
      }
    }

    return VehicleSelectionData(brands: brands);
  }
}
