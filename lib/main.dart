import 'package:flutter/material.dart';
import 'package:kanokponunit15/pages/add_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:kanokponunit15/pages/list_page.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'บทที่ 15',
      debugShowCheckedModeBanner: false,
      home: ListPage(),
    );
  }
}

