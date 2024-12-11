import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_mobile/pages/custom_widgets.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreateProfilePage extends StatefulWidget {
  @override
  _CreateProfilePageState createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  String? selectedGender;
  File? avatarImage;

  Future<void> saveProfile() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("Kullanıcı oturumu açık değil.");

      final String uid = user.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'fullName': fullNameController.text,
        'gender': selectedGender,
        'age': int.parse(ageController.text),
        'height': int.parse(heightController.text),
        'weight': int.parse(weightController.text),
        'avatarUrl': avatarImage?.path ?? '',
      });
    } catch (e) {
      print("Hata: $e");
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        avatarImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil Oluştur"),
        backgroundColor: const Color(0xFF0C454E),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/arkaplan.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Scrollbar(
              thumbVisibility: false,
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          CustomTextField(
                            hintText: "İsim Soyisim",
                            controller: fullNameController,
                            icon: Icons.person,
                            keyboardType: TextInputType.text,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z\s]')),
                            ],
                          ),
                          SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            dropdownColor: Colors.black,
                            value: selectedGender,
                            items: ['Erkek', 'Kadın']
                                .map((gender) => DropdownMenuItem(
                                      value: gender,
                                      child: Text(
                                        gender,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ))
                                .toList(),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.3),
                              hintText: 'Cinsiyet',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              prefixIcon: Icon(Icons.transgender,
                                  color: const Color(0xFF0C454E)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value;
                              });
                            },
                          ),
                          SizedBox(height: 16),
                          TextField(
                            style: TextStyle(color: Colors.white),
                            controller: ageController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.4),
                              hintText: 'Yaş',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              prefixIcon: Icon(Icons.calendar_today,
                                  color: const Color(0xFF0C454E)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(2),
                            ],
                          ),
                          SizedBox(height: 16),
                          TextField(
                            style: TextStyle(color: Colors.white),
                            controller: heightController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.4),
                              hintText: 'Boy (cm)',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              prefixIcon: Icon(Icons.height,
                                  color: const Color(0xFF0C454E)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                          SizedBox(height: 16),
                          TextField(
                            style: TextStyle(color: Colors.white),
                            controller: weightController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.4),
                              hintText: 'Kilogram (kg)',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              prefixIcon: Icon(Icons.monitor_weight,
                                  color: const Color(0xFF0C454E)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                          SizedBox(height: 16),
                          GestureDetector(
                            onTap: pickImage,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: 150,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.4),
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10),
                                    image: avatarImage != null
                                        ? DecorationImage(
                                            image: FileImage(avatarImage!),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: avatarImage == null
                                      ? Icon(
                                          Icons.image,
                                          size: 50,
                                          color: Color(0xFF0C454E),
                                        )
                                      : null,
                                ),
                                if (avatarImage == null)
                                  Positioned(
                                    top: 15,
                                    child: Text(
                                      "Avatar",
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          ),
                          SizedBox(height: 32),
                          CustomButton(
                            text: "Kaydet",
                            onPressed: saveProfile,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
