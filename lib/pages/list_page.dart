import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanokponunit15/pages/add_page.dart';
import 'package:kanokponunit15/pages/update_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
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

class _ListPageState extends State<ListPage> {

  void _deleteUser(String docId) async {
    await FirebaseFirestore.instance.collection('users').doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Page'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('เกิดข้อผิดพลาด'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text('ชื่อ: ${data['ชื่อ']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ชื่อเล่น: ${data['ชื่อเล่น'] }'),
                    Text('อีเมล: ${data['อีเมล'] }'),
                    Row(
                      children: [
                        Text('เบอร์โทร: ${data['เบอร์โทร']}'),
                        if (data['เบอร์โทร'] != null) // Show button if phone is not null
                          IconButton(
                            icon: Icon(Icons.phone),
                            onPressed: () {
                              final phone = data['เบอร์โทร'].replaceAll(' ', ''); // ดึงหมายเลขโทรศัพท์
                              if (phone.isNotEmpty) {
                                PhoneDialer.makePhoneCall(phone); // โทรออกโดยใช้หมายเลขที่ดึงมา
                              } else {
                                // แจ้งเตือนเมื่อไม่มีหมายเลขโทรศัพท์
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('ไม่พบหมายเลขโทรศัพท์'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                          ),

                      ],
                    ),
                  ],
                ),
                trailing:  Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdatePage(
                              docId: document.id,
                              currentName: data['ชื่อ'] ,
                              currentNickname: data['ชื่อ'] ,
                              currentEmail: data['อีเมล'],
                              currentPhone: data['เบอร์โทร'],
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteUser(document.id);
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
