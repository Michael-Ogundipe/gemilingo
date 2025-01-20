import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  late final GenerativeModel _model;

  GeminiService() {
    final apiKey = dotenv.env['API_KEY']!;
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
    );
  }

  Future<String> translateText(String text, String targetLanguage) async {
    try {
      final prompt = 'Translate this text to $targetLanguage: "$text"';
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? 'Translation error';
    } catch (e) {
      return 'Error: $e';
    }
  }
}
