import 'package:flutter/cupertino.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ApiService {
  static const apiKey = "AIzaSyA5G2Hxjj1Zwx6pOUW9ZhAeL1VgcfhCakc";

}

class MessageService {
  final String apiKey;
  final String allMessage;

  // Constructor'da apiKey varsayılan bir değer alıyor
  MessageService({
    this.apiKey = ApiService.apiKey, // Varsayılan API anahtarı
    this.allMessage = "",
  });

  Future<String> generateAiResponse(String allMessage) async {
    // API anahtarı kontrolü
    if (apiKey.isEmpty) {
      debugPrint('API anahtarı bulunamadı');
      return "";
    }

    try {
      // Model oluşturma
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
      );

      // İçerik oluşturma
      final content = [
        Content.text(
          allMessage,
        )
      ];

      final response = await model.generateContent(content);
      debugPrint("Mesaj: $content");
      final aiResponse = response.text!.replaceAll(RegExp(r'\s+'), ' ');


      return aiResponse;
    } catch (e) {
      debugPrint('Hata oluştu: $e');
      return "";
    }
  }
}
