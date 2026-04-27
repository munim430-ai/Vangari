import 'package:flutter/material.dart';

import '../widgets/section_title.dart';

class PricingScreen extends StatelessWidget {
  const PricingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prices = const {
      'Paper': 18,
      'Plastic': 22,
      'Iron': 55,
      'E-waste': 120,
      'Glass': 8,
    };

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SectionTitle(title: 'Scrap Pricing', subtitle: 'Admin can update later from Firestore'),
        ...prices.entries.map(
          (entry) => Card(
            child: ListTile(
              title: Text(entry.key),
              trailing: Text('BDT ${entry.value}/kg'),
            ),
          ),
        ),
      ],
    );
  }
}
