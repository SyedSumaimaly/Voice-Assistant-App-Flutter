import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:voice_assistant_app/secrets.dart';

class OpenAIService {
  /// Correct way to declare a list of message maps
  final List<Map<String, String>> messages = [];

  Future<String> isArtPromptAPI(String prompt) async {
    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAPIKey',
        },
        body: jsonEncode({
          "model": "gpt-5.1",
          "messages": [
            {
              "role": "user",
              "content":
              "Does this message want to generate an AI picture, image, art or anything similar: $prompt ? Simply answer with a yes or no."
            }
          ]
        }),
      );

      if (res.statusCode == 200) {
        final content =
        jsonDecode(res.body)['choices'][0]['message']['content']
            .toString()
            .trim();

        /// Decide between DALL·E and ChatGPT
        if (content.toLowerCase().startsWith('yes')) {
          return await dalleAPI(prompt);
        } else {
          return await chatGPTAPI(prompt);
        }
      } else {
        return "Error: ${res.statusCode}";
      }
    } catch (e) {
      return "Exception: $e";
    }
  }

  // ---------------------------------------------------------------------------

  Future<String> chatGPTAPI(String prompt) async {
    messages.add({
      'role': 'user',
      'content': prompt,
    });

    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAPIKey',
        },
        body: jsonEncode({
          "model": "gpt-5.1",
          "messages": messages,
        }),
      );

      if (res.statusCode == 200) {
        final content =
        jsonDecode(res.body)['choices'][0]['message']['content']
            .toString()
            .trim();

        messages.add({
          'role': 'assistant',
          'content': content,
        });

        return content;
      } else {
        return "Error: ${res.statusCode}";
      }
    } catch (e) {
      return "Exception: $e";
    }
  }

  // ---------------------------------------------------------------------------

  Future<String> dalleAPI(String prompt) async {
    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/images/generations'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAPIKey',
        },
        body: jsonEncode({
          "prompt": prompt,
          "n": 1,
          "size": "1024x1024",
        }),
      );

      if (res.statusCode == 200) {
        final imageUrl =
        jsonDecode(res.body)['data'][0]['url'].toString();

        return imageUrl;
      } else {
        return "Error: ${res.statusCode}";
      }
    } catch (e) {
      return "Exception: $e";
    }
  }
}
