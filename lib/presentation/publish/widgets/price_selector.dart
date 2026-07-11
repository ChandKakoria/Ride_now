import 'package:flutter/material.dart';

class PriceSelector extends StatelessWidget {
  final double price;
  final TextEditingController controller;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final ValueChanged<String> onChanged;
  final int recommendedPrice;

  const PriceSelector({
    super.key,
    required this.price,
    required this.controller,
    required this.onIncrement,
    required this.onDecrement,
    required this.onChanged,
    required this.recommendedPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPriceButton(
                context: context,
                icon: Icons.remove,
                onTap: onDecrement,
                enabled: price > 0,
              ),
              Expanded(child: _buildInputArea(context)),
              _buildPriceButton(
                context: context,
                icon: Icons.add,
                onTap: onIncrement,
                enabled: true,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "Recommended: ₹$recommendedPrice - ₹${recommendedPrice + 100}",
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).disabledColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "₹",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 120),
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onTap,
    required bool enabled,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: enabled
              ? Theme.of(context).primaryColor
              : Theme.of(context).disabledColor.withOpacity(0.1),
          shape: BoxShape.circle,
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          color: enabled
              ? Colors.white
              : Theme.of(context).disabledColor,
          size: 32,
        ),
      ),
    );
  }
}
