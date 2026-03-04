import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_now/providers/vehicle_provider.dart';
import 'package:ride_now/core/api_response.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _nameController = TextEditingController();
  final _modelController = TextEditingController();
  final _colorController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _modelController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  Future<void> _saveVehicle() async {
    if (_nameController.text.isEmpty ||
        _modelController.text.isEmpty ||
        _colorController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    setState(() => _isLoading = true);
    final res = await context.read<VehicleProvider>().addVehicle(
      name: _nameController.text,
      model: _modelController.text,
      color: _colorController.text,
    );
    setState(() => _isLoading = false);

    if (mounted) {
      if (res.status == Status.COMPLETED) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Vehicle added successfully")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res.message ?? "Failed to add vehicle")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Vehicle"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF003B4D),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildTextField("Vehicle Name (e.g. Toyota)", _nameController),
            const SizedBox(height: 20),
            _buildTextField("Vehicle Model (e.g. Camry)", _modelController),
            const SizedBox(height: 20),
            _buildTextField("Vehicle Color (e.g. White)", _colorController),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveVehicle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A3E0),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Save Vehicle",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF0F4F8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
