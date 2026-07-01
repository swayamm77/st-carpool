import 'package:flutter/material.dart';

class StatChip extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const StatChip({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.deepPurple.withOpacity(.18),
            child: Icon(icon, color: Colors.deepPurpleAccent, size: 20),
          ),

          const SizedBox(height: 14),

          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),

          const SizedBox(height: 6),

          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
