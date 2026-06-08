import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../models/word_model.dart';

/// Data source for the Node.js REST API.
/// Handles network requests to retrieve and create words via the backend.
class ApiDatasource {
  final http.Client _client;

  ApiDatasource({http.Client? client}) : _client = client ?? http.Client();

  /// Fetch all words from the Node.js API (GET /words).
  Future<List<WordModel>> fetchAllWords() async {
    try {
      final response = await _client
          .get(Uri.parse(ApiConstants.wordsUrl))
          .timeout(ApiConstants.timeout);

      if (response.statusCode == 200) {
        final body = json.decode(response.body) as Map<String, dynamic>;

        if (body['success'] == true && body['data'] != null) {
          final List<dynamic> wordsJson = body['data'];
          return wordsJson
              .map((json) => WordModel.fromJson(json as Map<String, dynamic>))
              .toList();
        }

        throw Exception('Invalid API response format');
      } else {
        throw HttpException(
          'Failed to fetch words: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on http.ClientException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    }
  }

  /// Add a new word via the API (POST /words).
  Future<WordModel> addWord({
    required String word,
    required String meaning,
    required String translation,
  }) async {
    try {
      final response = await _client
          .post(
            Uri.parse(ApiConstants.wordsUrl),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'word': word.trim(),
              'meaning': meaning.trim(),
              'translation': translation.trim(),
            }),
          )
          .timeout(ApiConstants.timeout);

      if (response.statusCode == 201) {
        final body = json.decode(response.body) as Map<String, dynamic>;
        if (body['success'] == true && body['data'] != null) {
          return WordModel.fromJson(body['data'] as Map<String, dynamic>);
        }
        throw Exception('Invalid API response format');
      } else {
        throw HttpException(
          'Failed to add word: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on http.ClientException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    }
  }

  /// Delete a word via the API (DELETE /words/:id).
  Future<void> deleteWord(String id) async {
    try {
      final response = await _client
          .delete(Uri.parse('${ApiConstants.wordsUrl}/$id'))
          .timeout(ApiConstants.timeout);

      if (response.statusCode != 200) {
        throw HttpException(
          'Failed to delete word: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on http.ClientException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    }
  }

  /// Dispose the HTTP client when no longer needed.
  void dispose() {
    _client.close();
  }
}

/// Custom exception for HTTP errors.
class HttpException implements Exception {
  final String message;
  final int statusCode;

  HttpException(this.message, this.statusCode);

  @override
  String toString() => 'HttpException($statusCode): $message';
}

/// Custom exception for network connectivity errors.
class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}
