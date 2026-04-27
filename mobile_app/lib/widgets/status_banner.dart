import 'package:flutter/material.dart';

class StatusBanner extends StatelessWidget {
  const StatusBanner({
    super.key,
    required this.firebaseReady,
    this.compact = false,
  });

  final bool firebaseReady;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final text = firebaseReady ? 'Firebase ready' : 'Firebase setup needed';
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 12,
        vertical: compact ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: compact ? Colors.green.shade50 : Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: compact ? Colors.black87 : Colors.white,
          fontSize: compact ? 11 : 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
