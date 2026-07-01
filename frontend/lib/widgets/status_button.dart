import 'package:flutter/material.dart';

import 'primary_button.dart';

class StatusButton extends StatelessWidget {
  final String? status;
  final VoidCallback? onPressed;

  const StatusButton({
    super.key,
    required this.status,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (status == null) {
      return PrimaryButton(text: "Request Ride", onPressed: onPressed);
    }

    Color color;
    String text;

    switch (status) {
      case "pending":
        color = Colors.orange;
        text = "Requested";
        break;

      case "approved":
        color = Colors.green;
        text = "Approved";
        break;

      case "rejected":
        color = Colors.red;
        text = "Rejected";
        break;

      default:
        color = Colors.grey;
        text = "Unknown";
    }

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          disabledBackgroundColor: color,
          disabledForegroundColor: Colors.white,
        ),
        child: Text(text),
      ),
    );
  }
}
