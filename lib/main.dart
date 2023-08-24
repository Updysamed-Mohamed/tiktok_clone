import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:somtok/screens/feed_screen.dart';
import 'package:somtok/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(); // Await the initialization
  } catch (e) {
    print('Firebase initialization failed: $e');
  }
  
  setup();
  runApp(MaterialApp(
     theme: ThemeData(
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.red, // Change this color to your desired color
          ),
        )
     ),
    debugShowCheckedModeBanner: false,
    home: FeedScreen(),
  ));
}
