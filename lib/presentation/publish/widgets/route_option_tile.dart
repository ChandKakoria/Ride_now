import 'package:flutter/material.dart';

class RouteOptionTile extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final String duration;
  final String distance;
  final String via;
  final bool hasTolls;
  final Function(int) onTap;

  const RouteOptionTile({
    super.key,
    required this.index,
    required this.selectedIndex,
    required this.duration,
    required this.distance,
    required this.via,
    required this.onTap,
    this.hasTolls = false,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedIndex == index;
    return InkWell(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0F4F8) : Colors.transparent,
          border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          children: [
            Radio(
              value: index,
              groupValue: selectedIndex,
              onChanged: (v) => onTap(index),
              activeColor: const Color(0xFF00A3E0),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF003B5C),
                        fontWeight: FontWeight.w600,
                      ),
                      children: [
                        TextSpan(text: duration),
                        const TextSpan(
                          text: " - ",
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                        TextSpan(
                          text: hasTolls ? "Tolls" : "No tolls",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: hasTolls ? Colors.orange : Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$distance - $via",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
