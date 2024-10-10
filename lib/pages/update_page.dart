import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdatePage extends StatefulWidget {
  final String docId;
  final String currentName;
  final String currentEmail;
  final String currentNickname;
  final String currentPhone;
  const UpdatePage({
    Key? key,
    required this.docId,
    required this.currentName,
    required this.currentEmail,
    required this.currentNickname,
    required this.currentPhone,
  }) : super(key: key);

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _nicknameController;
  late TextEditingController _phoneController;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _emailController = TextEditingController(text: widget.currentEmail);
    _nicknameController = TextEditingController(text: widget.currentNickname);
    _phoneController = TextEditingController(text: widget.currentPhone);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขข้อมูล'),
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
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'อีเมล'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'เบอร์โทร'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String name = _nameController.text;
                String email = _emailController.text;
                String nickname = _nicknameController.text;
                String phone = _phoneController.text;

                if (name.isNotEmpty && email.isNotEmpty) {
                  await _firestore
                      .collection('users')
                      .doc(widget.docId)
                      .update({
                    'ชื่อ': name,
                    'ชื่อเล่น': nickname,
                    'อีเมล': email,
                    'เบอร์โทร': phone,
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('แก้ไขข้อมูลเรียบร้อย')),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('กรอกชื่อและอีเมล')),
                  );
                }
              },
              child: Text('แก้ไขข้อมูล'),
            ),
          ],
        ),
      ),
    );
  }
}
