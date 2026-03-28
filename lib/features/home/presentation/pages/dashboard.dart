import 'package:echoemaar_commerce/features/auth/presentation/pages/profile_page.dart';
import 'package:echoemaar_commerce/features/cart/presentation/pages/cart_page.dart';
import 'package:echoemaar_commerce/features/home/presentation/pages/home_page.dart';
import 'package:echoemaar_commerce/features/products/presentation/pages/categories_page.dart';
import 'package:echoemaar_commerce/features/search/presentation/screens/search_page.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
//list of pages
  final List<Widget> _pages = [
   const HomePage(), 
   const SearchPage(),
      const CategoriesPage(),

   const CartPage(),
  const ProfilePage()
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}