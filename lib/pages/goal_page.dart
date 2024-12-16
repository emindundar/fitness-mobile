import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_service.dart';
import 'my_account.dart';

class GoalPage extends StatefulWidget {
  const GoalPage({Key? key}) : super(key: key);

  @override
  _GoalPageState createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  String? selectedGoal;
  String? selectedDays;
  String? selectedExperience;
  bool isLoading = false;

  // Kullanıcının seçtiği hedef, egzersiz günü ve fitness deneyimine göre program önerisini alır.
  Future<void> fetchProgramSuggestions() async {
    if (selectedGoal == null ||
        selectedDays == null ||
        selectedExperience == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm seçimleri yapın.')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final prompt = """
      Lütfen aşağıdaki bilgilerle bir fitness programı oluştur:
      - Hedef: $selectedGoal
      - Egzersiz Günleri: $selectedDays
      - Fitness Deneyimi: $selectedExperience
      Lütfen her gün için egzersizleri listeleyin ve detayları ekleyin.
    """;

    // API isteği gönder
    final response = await ApiService().generateAiResponse(prompt);

    setState(() {
      isLoading = false;
    });

    // Yanıt geldiyse, ProgramPage'e yönlendir
    if (response.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProgramPage(
            selectedGoal: selectedGoal!,
            selectedDays: int.parse(selectedDays!),
            selectedExperience: selectedExperience!,
            programResponse: response,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Program önerisi alınamadı.')),
      );
    }
  }

  Widget selectableButton(String title, String value, String? groupValue,
      Function(String) onChanged) {
    bool isSelected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Klavye açıldığında ekranı uygun şekilde ayarlar
      appBar: AppBar(
        title: const Text("Hedefin Nedir?"),
        backgroundColor: const Color(0xFF0C454E),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              // Taşmayı engellemek için SingleChildScrollView eklendi
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Hedefin Nedir?",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    selectableButton("Kilo Almak İstiyorum",
                        "Kilo Almak İstiyorum", selectedGoal, (value) {
                      setState(() => selectedGoal = value);
                    }),
                    selectableButton("Kilomu Korumak İstiyorum",
                        "Kilomu Korumak İstiyorum", selectedGoal, (value) {
                      setState(() => selectedGoal = value);
                    }),
                    selectableButton("Kilo Vermek İstiyorum",
                        "Kilo Vermek İstiyorum", selectedGoal, (value) {
                      setState(() => selectedGoal = value);
                    }),
                    const SizedBox(height: 16),
                    const Text(
                      "Haftada Kaç Gün Egzersiz Yapacaksın?",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    selectableButton("1 Gün", "1", selectedDays, (value) {
                      setState(() => selectedDays = value);
                    }),
                    selectableButton("2 Gün", "2", selectedDays, (value) {
                      setState(() => selectedDays = value);
                    }),
                    selectableButton("3 Gün veya Daha Fazla", "3", selectedDays,
                        (value) {
                      setState(() => selectedDays = value);
                    }),
                    const SizedBox(height: 16),
                    const Text(
                      "Ne Kadar Süredir Fitness Yapıyorsun?",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    selectableButton(
                        "1 Yıldan Az", "1 Yıldan Az", selectedExperience,
                        (value) {
                      setState(() => selectedExperience = value);
                    }),
                    selectableButton("1-2 Yıl", "1-2 Yıl", selectedExperience,
                        (value) {
                      setState(() => selectedExperience = value);
                    }),
                    selectableButton("2-5 Yıl", "2-5 Yıl", selectedExperience,
                        (value) {
                      setState(() => selectedExperience = value);
                    }),
                    selectableButton("5 Yıldan Daha Fazla",
                        "5 Yıldan Daha Fazla", selectedExperience, (value) {
                      setState(() => selectedExperience = value);
                    }),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: fetchProgramSuggestions,
                      child: const Text("Program Önerilerini Al"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class ProgramPage extends StatefulWidget {
  final String selectedGoal;
  final int selectedDays;
  final String selectedExperience;
  final String programResponse;

  const ProgramPage({
    Key? key,
    required this.selectedGoal,
    required this.selectedDays,
    required this.selectedExperience,
    required this.programResponse,
  }) : super(key: key);

  @override
  State<ProgramPage> createState() => _ProgramPageState();
}

class _ProgramPageState extends State<ProgramPage> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Programlar"),
        backgroundColor: const Color(0xFF0C454E),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  // Taşmayı engellemek için SingleChildScrollView eklendi
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hedef: ${widget.selectedGoal}",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Egzersiz Günleri: ${widget.selectedDays}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Deneyim: ${widget.selectedExperience}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Önerilen Program:",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(widget.programResponse),

                      // "İlerle" butonunu ekledik
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // İlerle butonuna tıklandığında yapılacak işlemi buraya ekleyin
                          // Örneğin, bir sonraki ekrana geçmek için Navigator kullanılabilir.
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyAccountPage(
                                  uid:
                                      'kullanici_uid'), // UID'yi buraya geçiriyoruz
                            ),
                          );
                        },
                        child: const Text("İlerle"),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class ApiService {
  static const String apiKey = "AIzaSyA5G2Hxjj1Zwx6pOUW9ZhAeL1VgcfhCakc";

  Future<String> generateAiResponse(String prompt) async {
    const String apiUrl =
        'https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent';

    final response = await http.post(
      Uri.parse('$apiUrl?key=$apiKey'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "contents": [
          {
            "parts": [
              {
                "text": prompt,
              }
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['candidates'][0]['content']['parts'][0]['text'];
    } else {
      return "API istek hatası: ${response.statusCode}";
    }
  }
}
