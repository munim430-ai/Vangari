import 'package:flutter/material.dart';

import '../widgets/order_tile.dart';
import '../widgets/section_title.dart';

class CollectorDashboardScreen extends StatelessWidget {
  const CollectorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        SectionTitle(title: 'Assigned Pickups', subtitle: 'Customer location, status update, payment proof'),
        OrderTile(id: 'VNG-1001', status: 'assigned', collector: 'You'),
        OrderTile(id: 'VNG-1003', status: 'picked', collector: 'You'),
      ],
    );
  }
}
