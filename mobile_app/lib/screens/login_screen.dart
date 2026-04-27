import 'package:flutter/material.dart';

import '../models/app_role.dart';
import '../widgets/status_banner.dart';
import 'shell_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.firebaseReady});

  final bool firebaseReady;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneController = TextEditingController(text: '+880');
  final otpController = TextEditingController();
  var otpSent = false;

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }

  void enterApp(AppRole role) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ShellScreen(role: role, firebaseReady: widget.firebaseReady),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF0B8F43),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ভাঙারি', style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  const Text('বাড়ির স্ক্র্যাপ বিক্রি করুন। কালেক্টর আসবে, ওজন হবে, টাকা পাবেন।', style: TextStyle(color: Colors.white, fontSize: 16, height: 1.5)),
                  const SizedBox(height: 16),
                  StatusBanner(firebaseReady: widget.firebaseReady),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('ফোন OTP লগইন', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 12),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(labelText: 'মোবাইল নম্বর', border: OutlineInputBorder()),
                    ),
                    if (otpSent) ...[
                      const SizedBox(height: 12),
                      TextField(
                        controller: otpController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'OTP কোড', border: OutlineInputBorder()),
                      ),
                    ],
                    const SizedBox(height: 14),
                    FilledButton(
                      onPressed: () => setState(() => otpSent = true),
                      child: Text(otpSent ? 'OTP যাচাই করুন' : 'OTP পাঠান'),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      onPressed: () => enterApp(AppRole.customer),
                      child: const Text('ডেমো হিসেবে ঢুকুন'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: () => enterApp(AppRole.collector), child: const Text('Collector Mode'))),
                const SizedBox(width: 10),
                Expanded(child: OutlinedButton(onPressed: () => enterApp(AppRole.admin), child: const Text('Admin'))),
              ],
            ),
            const SizedBox(height: 8),
            const Text('MVP admin email: munimm247@gmail.com', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
