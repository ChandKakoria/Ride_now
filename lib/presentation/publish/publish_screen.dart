import 'package:flutter/material.dart';
import 'package:ride_now/presentation/publish/pick_up_screen.dart';

class PublishScreen extends StatelessWidget {
  const PublishScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Publish a Ride")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_circle_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PickUpScreen()),
                );
              },
              child: const Text("Set Pickup Location"),
            ),
          ],
        ),
      ),
    );
  }
}
