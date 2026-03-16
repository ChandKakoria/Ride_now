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
            CircleAvatar(
              radius: 28,
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : null,
              child: Icon(
                Icons.person,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black
                    : Theme.of(context).primaryColor,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (email != null)
                    Text(
                      email!,
                      style: TextStyle(
                        color: Theme.of(context).disabledColor,
                        fontSize: 13,
                      ),
                    ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        "4.5/5 - 12 ratings",
                        style: TextStyle(
                          color: Theme.of(context).disabledColor,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).disabledColor,
              ),
          ],
        ),
      ),
    );
  }
}
