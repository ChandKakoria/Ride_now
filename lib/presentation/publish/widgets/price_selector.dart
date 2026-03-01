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
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                icon: Icons.remove,
                onTap: onDecrement,
                enabled: price > 0,
              ),
              _buildInputArea(),
              _buildPriceButton(
                icon: Icons.add,
                onTap: onIncrement,
                enabled: true,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "Recommended: ₹$recommendedPrice - ₹${recommendedPrice + 100}",
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "₹",
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Color(0xFF003B5C),
          ),
        ),
        SizedBox(
          width: 120,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.bold,
              color: Color(0xFF003B5C),
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceButton({
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
          color: enabled ? const Color(0xFFF0F4F8) : Colors.grey[100],
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: enabled ? const Color(0xFF003B5C) : Colors.grey[400],
          size: 32,
        ),
      ),
    );
  }
}
