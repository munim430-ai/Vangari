import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {
  const OrderTile({
    super.key,
    required this.id,
    required this.status,
    required this.collector,
  });

  final String id;
  final String status;
  final String collector;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(id, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text('Collector: $collector'),
        trailing: Chip(label: Text(status)),
      ),
    );
  }
}
