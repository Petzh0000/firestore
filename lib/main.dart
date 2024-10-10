import 'package:flutter/material.dart';
import 'package:kanokponunit15/pages/add_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kanokponunit15/pages/list_page.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class PhoneDialer {
  static Future<void> makePhoneCall(String phoneNumber) async {
    final url = Uri(scheme: 'tel', path: phoneNumber);

    // ตรวจสอบและขออนุญาต
    var status = await Permission.phone.status;
    if (!status.isGranted) {
      status = await Permission.phone.request();
    }

    if (status.isGranted) {
      // เปิดแอปโทรศัพท์
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        print('Cannot launch dialer for URL: $url');
      }
    } else {
      // ถ้าไม่อนุญาต
      print('Permission to access phone not granted');
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'บทที่ 15',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.purple,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.purple,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.purple,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: ListPage(),
    );
  }
}

