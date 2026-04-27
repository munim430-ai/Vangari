import 'package:flutter/material.dart';

import '../widgets/section_title.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        SectionTitle(title: 'Support', subtitle: 'WhatsApp fallback, reviews, privacy and terms'),
        Card(child: ListTile(leading: Icon(Icons.chat), title: Text('WhatsApp Support'), subtitle: Text('Add business number before launch'))),
        Card(child: ListTile(leading: Icon(Icons.verified_user), title: Text('Verified collectors'), subtitle: Text('All collectors must be admin approved'))),
        Card(child: ListTile(leading: Icon(Icons.receipt_long), title: Text('Payment proof'), subtitle: Text('Collector uploads image after payment'))),
      ],
    );
  }
}
