import 'package:flutter/material.dart';
import 'role_selection_dialog.dart';
import 'customer_home_screen.dart';
import 'boti_home_screen.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  Future<void> _handleSignIn(BuildContext context) async {
    // Simulate Google Sign-In (replace with real logic later)
    final role = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const RoleSelectionDialog(),
    );
    if (role == 'Customer') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const CustomerHomeScreen()),
      );
    } else if (role == 'Boti') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const BotiHomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Book My Boti',
            style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 28,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.restaurant_menu, size: 80, color: Colors.blueAccent),
              const SizedBox(height: 32),
              const Text(
                'Welcome to Book My Boti app',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text('Sign in with Google'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                ),
                onPressed: () => _handleSignIn(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
