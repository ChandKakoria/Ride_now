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
          color: isSelected
              ? (Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.1)
                    : Theme.of(context).primaryColor.withOpacity(0.1))
              : Colors.transparent,
          border: Border(
            bottom: BorderSide(color: Theme.of(context).dividerColor),
          ),
        ),
        child: Row(
          children: [
            Radio(
              value: index,
              groupValue: selectedIndex,
              onChanged: (v) => onTap(index),
              activeColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface,
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
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
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
