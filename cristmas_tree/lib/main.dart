import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'booking.dart';
import 'firebase_options.dart';
import 'auth_screen.dart';
import 'tree_design.dart';
import 'hive_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);


  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://YOUR-PROJECT-REF.supabase.co',
    anonKey: 'your anon key
',
  );

  // Initialize Hive local DB
  await Hive.initFlutter();
  Hive.registerAdapter(TreeDesignAdapter());
  Hive.registerAdapter(BookingAdapter());
  await HiveService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CTCA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthScreen(), // 🟢 start with login/signup as before
    );
  }
}
