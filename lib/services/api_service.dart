import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://tether-backend-laue.onrender.com';
  static const Duration _timeout = Duration(seconds: 25);

  /// Send a message to an AI instance.
  /// Returns status codes including: processed, needs_clarification, error,
  /// network_error, timeout, rejected (HTTP 400).
  static Future<Map<String, dynamic>> sendMessage({
    required String instanceId,
    required String input,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/process'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'instance_id': instanceId,
              'input': input,
            }),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      if (response.statusCode == 400) {
        return {
          'status': 'rejected',
          'response': "Couldn't process that. Try rewording?",
          'instance_id': instanceId,
        };
      }
      return {
        'status': 'error',
        'response': 'Server error: ${response.statusCode}',
        'instance_id': instanceId,
      };
    } on TimeoutException {
      return {
        'status': 'timeout',
        'response': 'Taking longer than expected. Still trying...',
        'instance_id': instanceId,
      };
    } catch (e) {
      return {
        'status': 'network_error',
        'response': "Couldn't reach the server. Check your connection.",
        'instance_id': instanceId,
        'error_detail': e.toString(),
      };
    }
  }

  /// Get conversation history for an instance
  static Future<List<Map<String, String>>> getConversation(String instanceId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/conversation/$instanceId'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final messages = data['messages'] as List;
        return messages.map((m) => {
          'role': m['role'] as String,
          'content': m['content'] as String,
        }).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Health check
  static Future<bool> checkHealth() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/health'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == 'operational';
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Get list of all available instances
  static Future<List<Map<String, dynamic>>> getInstances() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/instances'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['instances']);
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
