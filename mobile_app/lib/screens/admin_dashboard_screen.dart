import 'package:flutter/material.dart';

import '../widgets/order_tile.dart';
import '../widgets/section_title.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        SectionTitle(title: 'Admin Dashboard', subtitle: 'Admin: munimm247@gmail.com'),
        Card(child: ListTile(title: Text('Orders'), trailing: Text('2'))),
        Card(child: ListTile(title: Text('Pending'), trailing: Text('1'))),
        OrderTile(id: 'VNG-1001', status: 'assigned', collector: 'Rafiq Collector'),
        OrderTile(id: 'VNG-1002', status: 'pending', collector: 'Unassigned'),
      ],
    );
  }
}
