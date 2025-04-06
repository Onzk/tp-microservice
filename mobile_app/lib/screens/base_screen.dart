import 'package:billing_app/properties.dart';
import 'package:billing_app/screens/bills_screen.dart';
import 'package:billing_app/screens/clients_screen.dart';
import 'package:billing_app/screens/products_screen.dart';
import 'package:flutter/material.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _pageIndex = 1;

  @override
  void initState() {
    super.initState();
  }

  void navigateTo(int index) => setState(() => _pageIndex = index);

  @override
  void dispose() => super.dispose();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        const ClientsScreen(),
        const BillsScreen(),
        const ProductsScreen(),
      ][_pageIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8).copyWith(bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: baseColor,
        ),
        child: BottomNavigationBar(
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          unselectedItemColor: Colors.white54,
          selectedItemColor: Colors.white,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          currentIndex: _pageIndex,
          onTap: (index) => setState(() => _pageIndex = index),
          selectedLabelStyle: const TextStyle(fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Clients",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.line_style_outlined),
              label: "Factures",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.stacked_bar_chart),
              label: "Produits",
            ),
          ],
        ),
      ),
    );
  }
}
