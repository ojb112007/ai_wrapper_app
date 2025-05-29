// lib/services/ai_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIService {
  // Base URL for the AI API - can be changed to other providers
  static const String _baseUrl = 'https://api.anthropic.com/v1/messages';
  
  // Different AI models you might want to use
  static const String claudeHaiku = 'claude-3-haiku-20240307';
  static const String claudeSonnet = 'claude-3-sonnet-20240229';
  static const String claudeOpus = 'claude-3-opus-20240229';
  
  // Default model to use
  static const String defaultModel = claudeHaiku;

  // Method to send a prompt to the AI service
  static Future<Map<String, dynamic>> sendPrompt({
    required String prompt, 
    String model = defaultModel,
    int maxTokens = 1024,
  }) async {
    try {
      // Get the API key from environment variables
      final apiKey = dotenv.env['API_KEY'];
      
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('API key not found. Please check your .env file.');
      }

      // Make the API request
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': apiKey,
          'anthropic-version': '2023-06-01',
        },
        body: jsonEncode({
          'model': model,
          'max_tokens': maxTokens,
          'messages': [{'role': 'user', 'content': prompt}],
        }),
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get response: ${response.statusCode}\n${response.body}');
      }
    } catch (e) {
      throw Exception('Error sending prompt to AI service: $e');
    }
  }
  
  // Method to extract just the text response from the AI response
  static String extractResponseText(Map<String, dynamic> response) {
    try {
      return response['content'][0]['text'];
    } catch (e) {
      throw Exception('Error extracting text from response: $e');
    }
  }
}