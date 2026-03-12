import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakhi_yatra/core/api_response.dart';
import 'package:sakhi_yatra/providers/vehicle_provider.dart';
import 'package:sakhi_yatra/presentation/profile/model_selection_screen.dart';
import 'package:sakhi_yatra/presentation/widgets/common_app_bar.dart';

class BrandSelectionScreen extends StatefulWidget {
  const BrandSelectionScreen({super.key});

  @override
  State<BrandSelectionScreen> createState() => _BrandSelectionScreenState();
}

class _BrandSelectionScreenState extends State<BrandSelectionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VehicleProvider>().fetchAvailableVehicles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: Text("Select Brand")),
      body: Consumer<VehicleProvider>(
        builder: (context, provider, _) {
          final res = provider.availableVehicles;

          if (res.status == Status.LOADING) {
            return const Center(child: CircularProgressIndicator());
          }

          if (res.status == Status.ERROR) {
            return Center(child: Text(res.message ?? "Error loading brands"));
          }

          final brands = res.data?.brands ?? [];

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: brands.length,
            itemBuilder: (context, index) {
              final brand = brands[index];
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
                    brand.name,
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
                        builder: (c) => ModelSelectionScreen(brand: brand),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
