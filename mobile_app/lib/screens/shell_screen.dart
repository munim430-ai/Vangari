import 'package:flutter/material.dart';

import '../models/app_role.dart';
import '../widgets/status_banner.dart';
import 'admin_dashboard_screen.dart';
import 'collector_dashboard_screen.dart';
import 'customer_home_screen.dart';
import 'pickup_request_screen.dart';
import 'pricing_screen.dart';
import 'support_screen.dart';
import 'tracking_screen.dart';

class ShellScreen extends StatefulWidget {
  const ShellScreen({
    super.key,
    required this.role,
    required this.firebaseReady,
  });

  final AppRole role;
  final bool firebaseReady;

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  var index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = _pagesForRole(widget.role);
    final destinations = _destinationsForRole(widget.role);

    return Scaffold(
      appBar: AppBar(
        title: Text(appRoleTitle(widget.role)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: StatusBanner(firebaseReady: widget.firebaseReady, compact: true),
          ),
        ],
      ),
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: destinations,
      ),
    );
  }

  List<Widget> _pagesForRole(AppRole role) {
    switch (role) {
      case AppRole.customer:
        return const [CustomerHomeScreen(), PickupRequestScreen(), TrackingScreen(), SupportScreen()];
      case AppRole.collector:
        return const [CollectorDashboardScreen(), TrackingScreen(), SupportScreen()];
      case AppRole.admin:
        return const [AdminDashboardScreen(), PricingScreen(), TrackingScreen(), SupportScreen()];
    }
  }

  List<NavigationDestination> _destinationsForRole(AppRole role) {
    switch (role) {
      case AppRole.customer:
        return const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.sell_outlined), selectedIcon: Icon(Icons.sell), label: 'Sell'),
          NavigationDestination(icon: Icon(Icons.route_outlined), selectedIcon: Icon(Icons.route), label: 'Track'),
          NavigationDestination(icon: Icon(Icons.support_agent_outlined), selectedIcon: Icon(Icons.support_agent), label: 'Support'),
        ];
      case AppRole.collector:
        return const [
          NavigationDestination(icon: Icon(Icons.local_shipping_outlined), selectedIcon: Icon(Icons.local_shipping), label: 'Jobs'),
          NavigationDestination(icon: Icon(Icons.route_outlined), selectedIcon: Icon(Icons.route), label: 'Track'),
          NavigationDestination(icon: Icon(Icons.support_agent_outlined), selectedIcon: Icon(Icons.support_agent), label: 'Support'),
        ];
      case AppRole.admin:
        return const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Admin'),
          NavigationDestination(icon: Icon(Icons.price_change_outlined), selectedIcon: Icon(Icons.price_change), label: 'Pricing'),
          NavigationDestination(icon: Icon(Icons.route_outlined), selectedIcon: Icon(Icons.route), label: 'Orders'),
          NavigationDestination(icon: Icon(Icons.support_agent_outlined), selectedIcon: Icon(Icons.support_agent), label: 'Support'),
        ];
    }
  }
}
