import 'package:flutter/material.dart';

class RideDriverInfo extends StatelessWidget {
  final String name;
  final String? email;
  final VoidCallback? onTap;

  const RideDriverInfo({super.key, required this.name, this.email, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 28,
              backgroundColor: Color(0xFFE0F7FA),
              child: Icon(Icons.person, color: Colors.grey, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Color(0xFF003B4D),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (email != null)
                    Text(
                      email!,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  const Row(
                    children: [
                      Icon(Icons.star, color: Colors.grey, size: 16),
                      SizedBox(width: 4),
                      Text(
                        "4.5/5 - 12 ratings",
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
