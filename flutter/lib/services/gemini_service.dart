import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ScrapEstimate {
  final double estimatedValueBDT;
  final List<String> categories;
  final double estimatedWeightKg;
  final String description;

  ScrapEstimate({
    required this.estimatedValueBDT,
    required this.categories,
    required this.estimatedWeightKg,
    required this.description,
  });

  factory ScrapEstimate.fromJson(Map<String, dynamic> json) {
    return ScrapEstimate(
      estimatedValueBDT: (json['estimatedValueBDT'] ?? 0).toDouble(),
      categories: List<String>.from(json['categories'] ?? []),
      estimatedWeightKg: (json['estimatedWeightKg'] ?? 0).toDouble(),
      description: json['description'] ?? '',
    );
  }
}

class GeminiService {
  static const _apiKey = String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');
  static const _model = 'gemini-2.0-flash';

  static Future<ScrapEstimate?> estimateFromFile(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    return _estimate(base64Encode(bytes));
  }

  static Future<ScrapEstimate?> estimateFromBytes(Uint8List bytes) async {
    return _estimate(base64Encode(bytes));
  }

  static Future<ScrapEstimate?> _estimate(String base64Image) async {
    if (_apiKey.isEmpty) return _mockEstimate();

    const prompt = '''
You are a scrap price estimator for Bangladesh. Analyze this image of scrap/recyclable materials.
Return ONLY a JSON object with these exact fields:
{
  "estimatedValueBDT": <number, total estimated value in Bangladeshi Taka>,
  "categories": <array of strings from: paper, plastic, iron, ewaste, glass, copper, aluminum, rubber>,
  "estimatedWeightKg": <number, estimated total weight in kg>,
  "description": <string, brief Bengali or English description of what you see>
}
Use these reference prices per kg: paper=12, plastic=18, iron=35, ewaste=80, glass=8, copper=450, aluminum=120, rubber=10.
''';

    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent?key=$_apiKey',
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [{
          'parts': [
            {'text': prompt},
            {'inline_data': {'mime_type': 'image/jpeg', 'data': base64Image}},
          ]
        }],
        'generationConfig': {'response_mime_type': 'application/json'},
      }),
    );

    if (response.statusCode != 200) return _mockEstimate();

    try {
      final data = jsonDecode(response.body);
      final text = data['candidates'][0]['content']['parts'][0]['text'] as String;
      final json = jsonDecode(text) as Map<String, dynamic>;
      return ScrapEstimate.fromJson(json);
    } catch (_) {
      return _mockEstimate();
    }
  }

  static ScrapEstimate _mockEstimate() => ScrapEstimate(
    estimatedValueBDT: 150,
    categories: ['plastic', 'paper'],
    estimatedWeightKg: 5.0,
    description: 'Mixed scrap materials detected. Add your GEMINI_API_KEY for accurate estimates.',
  );
}
