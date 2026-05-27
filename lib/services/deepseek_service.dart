import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/message.dart';
import '../utils/constants.dart';

class DeepSeekService {
  String? _apiKey;
  static final DeepSeekService _instance = DeepSeekService._internal();
  factory DeepSeekService() => _instance;
  DeepSeekService._internal();

  void setApiKey(String key) {
    _apiKey = key;
  }

  Future<String> sendMessage({
    required String instanceId,
    required List<Message> conversationHistory,
    required String userMessage,
  }) async {
    if (_apiKey == null) {
      throw Exception('DeepSeek API key not set. Call setApiKey() first.');
    }

    final instance = InstanceRegistry.getById(instanceId);
    if (instance == null) {
      throw Exception('Unknown instance: $instanceId');
    }

    final messages = <Map<String, String>>[];
    
    // Add system prompt
    messages.add({
      'role': 'system',
      'content': instance['system_prompt'],
    });

    // Add conversation history (last 20 messages to stay within token limits)
    final recentHistory = conversationHistory.length > 20 
        ? conversationHistory.sublist(conversationHistory.length - 20) 
        : conversationHistory;
    
    for (final msg in recentHistory) {
      messages.add(msg.toApiFormat());
    }

    // Add current user message
    messages.add({
      'role': 'user',
      'content': userMessage,
    });

    final response = await http.post(
      Uri.parse(AppConstants.deepseekApiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: jsonEncode({
        'model': AppConstants.deepseekModel,
        'messages': messages,
        'temperature': 0.7,
        'max_tokens': 500,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('DeepSeek API error: ${response.statusCode} ${response.body}');
    }
  }
}