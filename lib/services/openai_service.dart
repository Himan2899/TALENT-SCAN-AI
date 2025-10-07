import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class OpenAIService {
  static const String _baseUrl = ApiConfig.openaiBaseUrl;
  static const String _model = ApiConfig.openaiModel;
  static const String _apiKey = ApiConfig.openaiApiKey;
  
  static Future<String> generateResponse(String userMessage, List<Map<String, dynamic>> chatHistory) async {
    try {
      // Prepare the conversation history
      List<Map<String, String>> messages = [
        {
          'role': 'system',
          'content': ApiConfig.systemPrompt
        }
      ];
      
      // Add chat history
      for (var message in chatHistory) {
        messages.add({
          'role': message['isUser'] ? 'user' : 'assistant',
          'content': message['message']
        });
      }
      
      // Add current user message
      messages.add({
        'role': 'user',
        'content': userMessage
      });
      
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': messages,
          'max_tokens': ApiConfig.maxTokens,
          'temperature': ApiConfig.temperature,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        print('OpenAI API Error: ${response.statusCode} - ${response.body}');
        return 'Sorry, I encountered an error. Please try again later.';
      }
    } catch (e) {
      print('OpenAI Service Error: $e');
      return 'Sorry, I\'m having trouble connecting right now. Please check your internet connection.';
    }
  }
  
  static Future<String> generateQuickResponse(String quickReply) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {
              'role': 'system',
              'content': ApiConfig.systemPrompt
            },
            {
              'role': 'user',
              'content': quickReply
            }
          ],
          'max_tokens': 200,
          'temperature': ApiConfig.temperature,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        return 'I\'m here to help! What would you like to know about your fitness journey?';
      }
    } catch (e) {
      return 'I\'m here to help! What would you like to know about your fitness journey?';
    }
  }
}
