import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  void _addUser() async {
    String name = _nameController.text;
    String email = _emailController.text;
    String nickname = _nicknameController.text;
    String phone = _phoneController.text;
    if (name.isNotEmpty && email.isNotEmpty) {
      await _firestore.collection('users').add({
        'ชื่อ': name,
        'ชื่อเล่น': nickname,
        'อีเมล': email,
        'เบอร์โทร': phone,
      });
      _nameController.clear();
      _emailController.clear();
      _nicknameController.clear();
      _phoneController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เพิ่มข้อมูลเรียบร้อย')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('กรอกชื่อ ชื่อเล่น อีเมล และเบอร์โทร')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('เพิ่มข้อมูล'),
        ),
        body: Padding(
        padding: const EdgeInsets.all(16.0),
    child: Column(
    children: <Widget>[
    TextField(
    controller: _nameController,
    decoration: InputDecoration(labelText: 'ชื่อ'),
    ),
      TextField(
        controller: _nicknameController,
        decoration: InputDecoration(labelText: 'ชื่อเล่น'),
      ),
    TextField(controller: _emailController,
      decoration: InputDecoration(labelText: 'อีเมล'),
    ),
      TextField(
        controller: _phoneController,
        decoration: InputDecoration(labelText: 'เบอร์โทร'),
      ),
      SizedBox(height: 20),
      ElevatedButton(
        onPressed: _addUser,
        child: Text('เพิ่มข้อมูล'),
      ),
    ],
    ),
        ),
    );

  }
}
