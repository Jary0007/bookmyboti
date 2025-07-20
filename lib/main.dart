import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookMyBoti',
      home: Scaffold(
        appBar: AppBar(title: Text('Book My Boti')),
        body: Center(child: Text('Welcome to BookMyBoti App!')),
      ),
    );
  }
}
