import 'package:flutter/material.dart';

import '../widgets/section_title.dart';

class PickupRequestScreen extends StatefulWidget {
  const PickupRequestScreen({super.key});

  @override
  State<PickupRequestScreen> createState() => _PickupRequestScreenState();
}

class _PickupRequestScreenState extends State<PickupRequestScreen> {
  final prices = const {
    'কাগজ': 18,
    'প্লাস্টিক': 22,
    'লোহা': 55,
    'ই-ওয়েস্ট': 120,
    'গ্লাস': 8,
  };

  var category = 'কাগজ';
  var weight = 5.0;

  @override
  Widget build(BuildContext context) {
    final estimate = prices[category]! * weight;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SectionTitle(title: 'Pickup Request', subtitle: 'স্ক্র্যাপের ধরন, ওজন ও লোকেশন দিন'),
        DropdownButtonFormField<String>(
          value: category,
          decoration: const InputDecoration(labelText: 'Scrap category', border: OutlineInputBorder()),
          items: prices.keys.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
          onChanged: (value) => setState(() => category = value ?? category),
        ),
        const SizedBox(height: 12),
        TextFormField(
          initialValue: weight.toStringAsFixed(0),
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Estimated weight kg', border: OutlineInputBorder()),
          onChanged: (value) => setState(() => weight = double.tryParse(value) ?? weight),
        ),
        const SizedBox(height: 12),
        const TextField(decoration: InputDecoration(labelText: 'Address', border: OutlineInputBorder())),
        const SizedBox(height: 12),
        Container(
          height: 120,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: Colors.greenAccent, borderRadius: BorderRadius.all(Radius.circular(16))),
          child: const Text('Map/location selector placeholder'),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            title: const Text('Estimated price'),
            subtitle: Text('BDT ${estimate.toStringAsFixed(0)}'),
            trailing: const Icon(Icons.payments),
          ),
        ),
        FilledButton(onPressed: null, child: const Text('Booking Confirm করুন')),
      ],
    );
  }
}
