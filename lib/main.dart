import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookMyBoti',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
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
  Future<void> _signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return;
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    // Check if user exists in Firestore, if not, create with default role
    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid);
    final doc = await userDoc.get();
    if (!doc.exists) {
      await userDoc.set({'role': 'Customer'}); // Default role
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign In')),
      body: Center(
        child: ElevatedButton.icon(
          icon: Icon(Icons.login),
          label: Text('Sign in with Google'),
          onPressed: () => _signInWithGoogle(context),
        ),
      ),
    );
  }
}

class RoleRedirectScreen extends StatelessWidget {
  final User user;
  RoleRedirectScreen({required this.user});

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
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.data == 'Boti') {
          return BotiHomeScreen();
        } else {
          return CustomerHomeScreen();
        }
      },
    );
  }
}

class CustomerHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Customer Home')),
      body: Center(child: Text('Welcome, Customer!')),
    );
  }
}

class BotiHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Boti Home')),
      body: Center(child: Text('Welcome, Boti!')),
    );
  }
}

// TODO: Add your Firebase configuration files (google-services.json for Android, GoogleService-Info.plist for iOS) to the respective platform folders.
