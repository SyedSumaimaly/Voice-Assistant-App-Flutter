import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:voice_assistant_app/secrets.dart';

// Assuming you have both keys now
// const openAPIKey = 'sk-proj-iCsYl09Cfpo8Bfrq4dIvf2VIHTsryb9fdXBODMWYmGn2AZVwsCeoxoyRanaMj1UYNAHLB1eZMfT3BlbkFJNHw0y7kOtY0Q9wTdwbpGI3IRdY';
// const geminiAPIKey = 'AIzaSyBPeqL1ErMwAEw7DicAJtK_C73pEE4MV_M';

class OpenAIService {
  // Use a map to track conversation history for the currently active chat service
  final List<Map<String, String>> messages = [];

  // Use a flag to decide which chat API to use (set to true for free tier)
  final bool useGeminiForChat = true;

  // Use correct models
  final String chatModel = 'gpt-3.5-turbo';
  final String geminiModel = 'gemini-2.5-flash';
  final String dalleModel = 'dall-e-3';

  // --- Primary Routing Function ---

  Future<String> isArtPromptAPI(String prompt) async {
    // We will still use OpenAI to check if it's an art prompt, as it's quick
    // and if you use the Gemini Chat API for everything, you won't trigger DALL-E

    // NOTE: If this OpenAI call runs out of quota, you must hardcode a 'no'
    // answer or use a local check. For now, we assume this initial check
    // will still attempt to use the OpenAI API key.

    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAPIKey',
        },
        body: jsonEncode({
          "model": chatModel,
          "messages": [
            {"role": "user", "content": "Does this message want to generate an AI picture, image, art or anything similar: $prompt ? Simply answer with a yes or no."}
          ]
        }),
      );

      if (res.statusCode == 200) {
        final content = jsonDecode(res.body)['choices'][0]['message']['content'].toString().trim();

        if (content.toLowerCase().startsWith('yes')) {
          // Keep DALL-E (OpenAI) for image generation
          return await dalleAPI(prompt);
        } else {
          // Use the free Gemini API for general chat
          return await geminiChatAPI(prompt);
        }
      } else {
        // If the API check fails (e.g., quota error 429), default to chat via Gemini
        if (kDebugMode) {
          print('OpenAI Check Failed (${res.statusCode}): Defaulting to Gemini Chat.');
        }
        // Force the prompt to be treated as a chat request
        return await geminiChatAPI(prompt);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception in isArtPromptAPI: $e. Defaulting to Gemini Chat.');
      }
      return await geminiChatAPI(prompt);
    }
  }

  // ---------------------------------------------------------------------------

  /// 🌟 NEW: Uses the free Gemini 2.5 Flash model for chat.
  Future<String> geminiChatAPI(String prompt) async {
    // Add prompt to history for context
    messages.add({'role': 'user', 'content': prompt});

    // Convert history to Gemini's 'contents' format
    final geminiContents = messages.map((m) {
      final role = (m['role'] == 'assistant') ? 'model' : 'user';
      return {
        "role": role,
        "parts": [{"text": m['content']}]
      };
    }).toList();

    try {
      final res = await http.post(
        // Note: Key is in the URL query parameter for Gemini
        Uri.parse(
            'https://generativelanguage.googleapis.com/v1beta/models/$geminiModel:generateContent?key=$geminiAPIKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "contents": geminiContents, // Sending the conversation history
        }),
      );

      if (res.statusCode == 200) {
        final content = jsonDecode(res.body)['candidates'][0]['content']['parts'][0]['text']
            .toString()
            .trim();

        // Add response to history
        messages.add({'role': 'assistant', 'content': content});
        return content;
      } else {
        if (kDebugMode) {
          print('Gemini Error Body: ${res.body}');
        }
        return "Gemini Error: ${res.statusCode}";
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception in geminiChatAPI: $e');
      }
      return "Gemini Exception: $e";
    }
  }

  // ---------------------------------------------------------------------------

  /// Keeping the OpenAI DALL-E API for image generation (as no direct free alternative exists).
  Future<String> dalleAPI(String prompt) async {
    // ... [The existing dalleAPI implementation remains here, using $openAPIKey] ...
    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/images/generations'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAPIKey',
        },
        body: jsonEncode({
          "model": dalleModel,
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
        if (kDebugMode) {
          print('OpenAI Error Body for dalleAPI: ${res.body}');
        }
        return "Error: ${res.statusCode}";
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception in dalleAPI: $e');
      }
      return "Exception: $e";
    }
  }

// Note: The original chatGPTAPI method is now obsolete and should be removed.
}