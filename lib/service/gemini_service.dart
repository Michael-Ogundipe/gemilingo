import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  late GenerativeModel model;

  GeminiService() {
    final apiKey = dotenv.env['API_KEY']!;
    model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
    );
  }

  Future<String> translateText(String text, String translatedLanguage) async {
    try {
      final prompt = 'Translate this text to $translatedLanguage: "$text".  '
          'Respond with only the translation, no quotes or additional text.';
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      return response.text ?? 'Translation error';
    } catch (e) {
      return 'Translation error';
    }
  }
}
