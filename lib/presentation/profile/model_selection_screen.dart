import 'package:flutter/material.dart';
import 'package:sakhi_yatra/core/models/vehicle_selection_model.dart';
import 'package:sakhi_yatra/presentation/profile/color_selection_screen.dart';
import 'package:sakhi_yatra/presentation/widgets/common_app_bar.dart';

class ModelSelectionScreen extends StatelessWidget {
  final VehicleBrand brand;

  const ModelSelectionScreen({super.key, required this.brand});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: Text("Select ${brand.name} Model")),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: brand.models.length,
        itemBuilder: (context, index) {
          final model = brand.models[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              title: Text(
                model.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) => ColorSelectionScreen(
                      brandName: brand.name,
                      model: model,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
