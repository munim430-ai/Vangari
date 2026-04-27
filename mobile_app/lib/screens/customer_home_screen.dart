import 'package:flutter/material.dart';

class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        CustomerHeroCard(),
        SizedBox(height: 14),
        TrustCard(),
      ],
    );
  }
}

class CustomerHeroCard extends StatelessWidget {
  const CustomerHeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'আজই স্ক্র্যাপ বিক্রি করুন',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            const Text('কাগজ, প্লাস্টিক, লোহা, ই-ওয়েস্ট — বাসা থেকে পিকআপ।'),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: null,
              icon: Icon(Icons.sell),
              label: Text('বিক্রি করুন / Pickup Request'),
            ),
          ],
        ),
      ),
    );
  }
}

class TrustCard extends StatelessWidget {
  const TrustCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Trust features', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            SizedBox(height: 8),
            Text('Verified collectors'),
            Text('Live pickup status'),
            Text('Payment proof'),
            Text('User reviews'),
          ],
        ),
      ),
    );
  }
}
