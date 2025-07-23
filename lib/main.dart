import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookMyBoti',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        if (!snapshot.hasData) {
          return SignInScreen();
        }
        return RoleRedirectScreen(user: snapshot.data!);
      },
    );
  }
}

class SignInScreen extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  SignInScreen({super.key});

  Future<void> _signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount? account = await _googleSignIn.signIn();
    if (account == null) return;
    final GoogleSignInAuthentication auth = await account.authentication;
    final String? accessToken = auth.accessToken;

    final credential = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );

    if (!context.mounted) return;

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    // Check if user exists in Firestore, if not, prompt for role selection
    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid);
    final doc = await userDoc.get();
    if (!doc.exists || !(doc.data()?.containsKey('role') ?? false)) {
      // Show role selection dialog
      final role = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (context) => const RoleSelectionDialog(),
      );
      if (role != null) {
        await userDoc.set({'role': role}, SetOptions(merge: true));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.login),
          label: const Text('Sign in with Google'),
          onPressed: () => _signInWithGoogle(context),
        ),
      ),
    );
  }
}

class RoleSelectionDialog extends StatelessWidget {
  const RoleSelectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Your Role'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop('Customer'),
            child: const Text('Customer'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop('Boti'),
            child: const Text('Boti (Cook)'),
          ),
        ],
      ),
    );
  }
}

class RoleRedirectScreen extends StatelessWidget {
  final User user;
  const RoleRedirectScreen({super.key, required this.user});

  Future<String> _getUserRole() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    return doc.data()?['role'] ?? 'Customer';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getUserRole(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.data == 'Boti') {
          return const BotiHomeScreen();
        } else {
          return const CustomerHomeScreen();
        }
      },
    );
  }
}

class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Home')),
      body: const Center(child: Text('Welcome, Customer!')),
    );
  }
}

class BotiHomeScreen extends StatelessWidget {
  const BotiHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Boti Home')),
      body: const Center(child: Text('Welcome, Boti!')),
    );
  }
}

// TODO: Add your Firebase configuration files (google-services.json for Android, GoogleService-Info.plist for iOS) to the respective platform folders.
