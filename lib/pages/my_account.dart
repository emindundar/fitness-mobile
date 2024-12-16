import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyAccountPage extends StatefulWidget {
  final String uid;  // Kullanıcının UID'sini almak için bir parametre ekliyoruz.

  const MyAccountPage({Key? key, required this.uid}) : super(key: key);

  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  bool isLoading = true;  // Verilerin yüklenip yüklenmediğini kontrol etmek için

  String fullName = '';
  String gender = '';
  int age = 0;
  int height = 0;
  int weight = 0;
  String avatarUrl = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();  // Kullanıcı verilerini yüklemek için çağırıyoruz
  }

  // Firebase'den kullanıcı verilerini alıyoruz
  Future<void> _loadUserData() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)  // UID ile kullanıcının verisini alıyoruz
          .get();

      if (snapshot.exists) {
        setState(() {
          fullName = snapshot['fullName'] ?? '';
          gender = snapshot['gender'] ?? '';
          age = snapshot['age'] ?? 0;
          height = snapshot['height'] ?? 0;
          weight = snapshot['weight'] ?? 0;
          avatarUrl = snapshot['avatarUrl'] ?? '';
          isLoading = false;  // Veriler yüklendikten sonra isLoading false yapıyoruz
        });
      } else {
        // Kullanıcı verisi bulunamazsa
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;  // Hata durumunda da loading'i durduruyoruz
      });
      print("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hesabım"),
        backgroundColor: const Color(0xFF0C454E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())  // Yükleme sırasında göstereceğimiz widget
            : SingleChildScrollView(  // Yükleme tamamlandıktan sonra verileri gösteriyoruz
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: avatarUrl.isNotEmpty
                    ? NetworkImage(avatarUrl)  // Eğer avatar URL varsa, onu kullan
                    : const AssetImage('assets/default_avatar.png') as ImageProvider,  // Yoksa varsayılan avatar kullan
              ),
              const SizedBox(height: 16),
              Text(
                "Ad Soyad: $fullName",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                "Cinsiyet: $gender",
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                "Yaş: $age",
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                "Boy: $height cm",
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                "Kilo: $weight kg",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Geri gitmek için Navigator.pop(context) kullanılır
                  Navigator.pop(context);
                },
                child: const Text("Geri Git"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
