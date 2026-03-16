import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakhi_yatra/providers/create_ride_provider.dart';
import 'package:sakhi_yatra/presentation/publish/passenger_count_screen.dart';
import 'package:sakhi_yatra/presentation/publish/widgets/selection_tile.dart';
import 'package:sakhi_yatra/presentation/widgets/shared_gradient_background.dart';
import 'package:sakhi_yatra/presentation/widgets/common_app_bar.dart';

class RideTimePickerScreen extends StatefulWidget {
  const RideTimePickerScreen({super.key});
  @override
  State<RideTimePickerScreen> createState() => _RideTimePickerScreenState();
}

class _RideTimePickerScreenState extends State<RideTimePickerScreen> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    final p = context.read<CreateRideProvider>();
    if (p.selectedDate != null) _selectedDate = p.selectedDate!;
    if (p.selectedTime != null) _selectedTime = p.selectedTime!;
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (c, ch) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: Theme.of(context).primaryColor,
            onPrimary: Theme.of(context).colorScheme.onPrimary,
            onSurface: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        child: ch!,
      ),
    );
    if (d != null) setState(() => _selectedDate = d);
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (c, ch) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: Theme.of(context).primaryColor,
            onPrimary: Theme.of(context).colorScheme.onPrimary,
            onSurface: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        child: ch!,
      ),
    );
    if (t != null) setState(() => _selectedTime = t);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: const Text("Select Time"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SharedGradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: Theme.of(context).brightness == Brightness.light
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "When are you picking up?",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 40),
                  SelectionTile(
                    title: "Date",
                    value:
                        "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                    icon: Icons.calendar_today,
                    onTap: _pickDate,
                  ),
                  const SizedBox(height: 20),
                  SelectionTile(
                    title: "Time",
                    value: _selectedTime.format(context),
                    icon: Icons.access_time,
                    onTap: _pickTime,
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<CreateRideProvider>().updateDate(
                          _selectedDate,
                        );
                        context.read<CreateRideProvider>().updateTime(
                          _selectedTime,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (c) => const PassengerCountScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        "Next",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
