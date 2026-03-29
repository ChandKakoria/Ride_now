import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakhi_yatra/core/api_response.dart';
import 'package:sakhi_yatra/core/models/vehicle_selection_model.dart';
import 'package:sakhi_yatra/providers/user_provider.dart';
import 'package:sakhi_yatra/providers/vehicle_provider.dart';
import 'package:sakhi_yatra/presentation/widgets/common_app_bar.dart';

class ColorSelectionScreen extends StatefulWidget {
  final String brandName;
  final VehicleModelInfo model;

  const ColorSelectionScreen({
    super.key,
    required this.brandName,
    required this.model,
  });

  @override
  State<ColorSelectionScreen> createState() => _ColorSelectionScreenState();
}

class _ColorSelectionScreenState extends State<ColorSelectionScreen> {
  bool _isLoading = false;
  String? _selectedColor;

  Future<void> _addVehicle() async {
    if (_selectedColor == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select a color")));
      return;
    }

    setState(() => _isLoading = true);
    final res = await context.read<VehicleProvider>().addVehicle(
      name: widget.brandName,
      model: widget.model.name,
      color: _selectedColor!,
    );
    setState(() => _isLoading = false);

    if (mounted) {
      if (res.status == Status.COMPLETED) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Vehicle added successfully")),
        );
        // Refresh profile to show new vehicle
        context.read<UserProvider>().fetchProfile();
        // Pop back to the profile screen.
        // The flow is: Profile -> Brand -> Model -> Color
        // So we need to pop 3 times to get back to Profile.
        Navigator.of(context).pop(); // Color
        Navigator.of(context).pop(); // Model
        Navigator.of(context).pop(); // Brand
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
      appBar: CommonAppBar(title: Text("Select ${widget.model.name} Color")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: widget.model.colors.length,
              itemBuilder: (context, index) {
                final colorName = widget.model.colors[index];
                final isSelected = _selectedColor == colorName;
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: CheckboxListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    secondary: CircleAvatar(
                      radius: 12,
                      backgroundColor: _getColorFromName(colorName),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.3),
                            width: 0.5,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      colorName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    value: isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedColor = colorName;
                        } else {
                          _selectedColor = null;
                        }
                      });
                    },
                    activeColor: Theme.of(context).primaryColor,
                    checkboxShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _addVehicle,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                ),
                child: _isLoading
                    ? CircularProgressIndicator(
                        )
                    : const Text(
                        "Add this vehicle",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorFromName(String name) {
    final n = name.toLowerCase();
    if (n.contains('white')) return Colors.white;
    if (n.contains('black')) return Colors.black;
    if (n.contains('silver') || n.contains('grey') || n.contains('gray'))
      return Colors.grey;
    if (n.contains('red')) return Colors.red;
    if (n.contains('blue')) return Colors.blue;
    if (n.contains('gold')) return const Color(0xFFFFD700);
    if (n.contains('brown')) return Colors.brown;
    if (n.contains('orange')) return Colors.orange;
    if (n.contains('purple')) return Colors.purple;
    if (n.contains('yellow')) return Colors.yellow;
    if (n.contains('green')) return Colors.green;
    return Colors.blueGrey;
  }
}
