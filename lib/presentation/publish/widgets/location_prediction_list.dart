import 'package:flutter/material.dart';

class LocationPredictionList extends StatelessWidget {
  final List<Map<String, dynamic>> predictions;
  final Function(Map<String, dynamic>) onSelected;

  const LocationPredictionList({
    super.key,
    required this.predictions,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 250),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.black12)),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: predictions.length,
        separatorBuilder: (context, index) =>
            const Divider(height: 1, indent: 16, endIndent: 16),
        itemBuilder: (context, index) {
          final prediction = predictions[index];
          final mainText =
              prediction['structured_formatting']['main_text'] ??
              prediction['description'];
          final secondaryText =
              prediction['structured_formatting']['secondary_text'] ?? "";

          return ListTile(
            leading: const Icon(
              Icons.location_on_outlined,
              color: Color(0xFF7D8C98),
            ),
            title: Text(
              mainText,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF003B5C),
              ),
            ),
            subtitle: Text(
              secondaryText,
              style: const TextStyle(color: Color(0xFF7D8C98), fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () => onSelected(prediction),
          );
        },
      ),
    );
  }
}
