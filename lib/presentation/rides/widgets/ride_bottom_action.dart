import 'package:flutter/material.dart';
import 'package:sakhi_yatra/core/app_strings.dart';

class RideBottomAction extends StatelessWidget {
  final String status;
  final VoidCallback? onBook;
  final bool isLoading;

  const RideBottomAction({
    super.key,
    required this.status,
    this.onBook,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final s = status.toLowerCase();
    final inactive = s == 'booked' || s == 'requested';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: (inactive || isLoading) ? null : onBook,
        style: ElevatedButton.styleFrom(
          backgroundColor: inactive ? Colors.grey : const Color(0xFF00A3E0),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    inactive ? Icons.check_circle : Icons.flash_on,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    s == 'booked'
                        ? AppStrings.labelBooked
                        : (s == 'requested'
                              ? AppStrings.labelRequested
                              : AppStrings.labelBook),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
