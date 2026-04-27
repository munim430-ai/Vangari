import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const VangariApp());
}

class VangariApp extends StatelessWidget {
  const VangariApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vangari',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B8F43)),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F2),
      appBar: AppBar(
        title: const Text('ভাঙারি'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Admin'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          HeroCard(),
          SizedBox(height: 16),
          PickupRequestCard(),
          SizedBox(height: 16),
          OrderTrackingCard(),
          SizedBox(height: 16),
          AdminPreviewCard(),
        ],
      ),
    );
  }
}

class HeroCard extends StatelessWidget {
  const HeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'বাড়ির পুরনো কাগজ, প্লাস্টিক, লোহা বিক্রি করুন',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('OTP login, pickup request, live status, collector assignment, payment proof.'),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: () {},
              child: const Text('বিক্রি করুন / Pickup Request'),
            ),
          ],
        ),
      ),
    );
  }
}

class PickupRequestCard extends StatelessWidget {
  const PickupRequestCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Pickup request flow', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('1. Phone OTP signup/login'),
            Text('2. Scrap category selection'),
            Text('3. Weight estimate and price estimate'),
            Text('4. Location/map selection'),
            Text('5. Booking confirmation'),
          ],
        ),
      ),
    );
  }
}

class OrderTrackingCard extends StatelessWidget {
  const OrderTrackingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final statuses = ['pending', 'assigned', 'picked', 'paid'];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Order tracking', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: statuses.map((status) => Chip(label: Text(status))).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminPreviewCard extends StatelessWidget {
  const AdminPreviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Admin dashboard', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Admin email: munimm247@gmail.com'),
            Text('Manual collector assignment first'),
            Text('Area availability, pricing, overrides, conversion tracking'),
          ],
        ),
      ),
    );
  }
}
