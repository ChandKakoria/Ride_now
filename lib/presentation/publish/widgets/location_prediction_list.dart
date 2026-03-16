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
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: predictions.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          indent: 16,
          endIndent: 16,
          color: Theme.of(context).dividerColor,
        ),
        itemBuilder: (context, index) {
          final prediction = predictions[index];
          final mainText =
              prediction['structured_formatting']['main_text'] ??
              prediction['description'];
          final secondaryText =
              prediction['structured_formatting']['secondary_text'] ?? "";

          return ListTile(
            leading: Icon(
              Icons.location_on_outlined,
              color: Theme.of(context).disabledColor,
            ),
            title: Text(
              mainText,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              secondaryText,
              style: TextStyle(
                color: Theme.of(context).disabledColor,
                fontSize: 13,
              ),
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
