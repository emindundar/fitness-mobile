import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_service.dart';

class ProgramPage extends StatefulWidget {
  final String selectedGoal;
  final int selectedDays;
  final String selectedExperience;

  const ProgramPage({
    Key? key,
    required this.selectedGoal,
    required this.selectedDays,
    required this.selectedExperience,
  }) : super(key: key);

  @override
  State<ProgramPage> createState() => _ProgramPageState();
}

class _ProgramPageState extends State<ProgramPage> {
  String? responseText;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProgramData();
  }

  Future<void> fetchProgramData() async {
    const String apiKey = ApiService.apiKey;
    const String apiUrl =
        'https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent';

    final prompt = {
      "contents": [
        {
          "parts": [
            {
              "text": "Kullanıcının aşağıdaki bilgilerine göre kişiye özel bir fitness programı önerin. "
                  "Hedef: ${widget.selectedGoal}. "
                  "Haftada egzersiz yapılacak gün sayısı: ${widget.selectedDays} veya daha fazla gün. "
                  "Tecrübe: ${widget.selectedExperience}. "
                  "Program, her gün için başlıklar (örn. Pazartesi, Salı, Çarşamba) ve her gün için yapılacak "
                  "egzersizlerin (örn. Squat 5x5) detaylarıyla sunulsun. Set ve tekrar sayıları da belirtilecektir. "
                  "Programda, egzersizlerin her biri için açıklamalar, önerilen hareketler ve gün içeriği düzgün şekilde yer alsın. "
                  "Son olarak, programla ilgili genel notlar (örn. 'Haftada 3 gün yapılacak') da eklenmelidir."
            }
          ]
        }
      ]
    };

    try {
      final response = await http.post(
        Uri.parse('$apiUrl?key=$apiKey'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(prompt),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          responseText = data['candidates'][0]['content']['parts'][0]['text'];
          isLoading = false;
        });
      } else {
        throw Exception("Veri çekme hatası: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        responseText = "Hata: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Programlar"),
        backgroundColor: const Color(0xFF0C454E),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : responseText != null
              ? ProgramDisplay(
                  response:
                      responseText ?? 'Veri alınamadı, lütfen tekrar deneyin.')
              : const Center(child: Text("Veri alınamadı, tekrar deneyin.")),
    );
  }
}

class ProgramDisplay extends StatelessWidget {
  final String response;

  const ProgramDisplay({Key? key, required this.response}) : super(key: key);

  Map<String, List<String>> parsePrograms(String response) {
    if (response.isEmpty) {
      return {};
    }
    final Map<String, List<String>> programs = {};
    final List<String> programBlocks = response.split('\n\n');

    for (var block in programBlocks) {
      final lines = block.split('\n');
      if (lines.isNotEmpty) {
        final dayTitle = lines[0].trim();
        final details = lines.sublist(1).map((e) => e.trim()).toList();
        programs[dayTitle] = details;
      }
    }
    return programs;
  }

  @override
  Widget build(BuildContext context) {
    final programs = parsePrograms(response);

    return Scrollbar(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Kişiye Özel Fitness Programı",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                    letterSpacing: 1.2),
              ),
            ),
            const Divider(color: Colors.black87, thickness: 1),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: programs.entries.map((entry) {
                  return ProgramCard(
                      dayTitle: entry.key, movements: entry.value);
                }).toList(),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Program Notları",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "• Haftada 3 gün yapılacak program.",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "• Her gün için ayrı egzersizler ve set/tekrarlar belirlenmiştir.",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProgramCard extends StatelessWidget {
  final String dayTitle;
  final List<String> movements;

  const ProgramCard({Key? key, required this.dayTitle, required this.movements})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.green, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dayTitle,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: movements
                .map((movement) => Text(
                      "• $movement",
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black54),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
