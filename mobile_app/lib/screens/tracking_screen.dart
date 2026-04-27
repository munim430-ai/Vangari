import 'package:flutter/material.dart';

import '../widgets/order_tile.dart';
import '../widgets/section_title.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        SectionTitle(title: 'Order Tracking', subtitle: 'pending → assigned → picked → paid'),
        OrderTile(id: 'VNG-1001', status: 'assigned', collector: 'Rafiq Collector'),
        OrderTile(id: 'VNG-1002', status: 'pending', collector: 'Unassigned'),
      ],
    );
  }
}
