import '../datasources/api_datasource.dart';
import '../datasources/firestore_datasource.dart';
import '../../domain/entities/word.dart';

/// Repository that coordinates between the API and Firestore data sources.
/// 
/// Strategy:
/// - Primary: Use the Node.js API for all operations (works without Firebase SDK)
/// - Fallback: Use Firestore directly if the API is unavailable and Firebase is configured
class VocabularyRepository {
  final ApiDatasource _apiDatasource;
  final FirestoreDatasource? _firestoreDatasource;

  VocabularyRepository({
    ApiDatasource? apiDatasource,
    FirestoreDatasource? firestoreDatasource,
  })  : _apiDatasource = apiDatasource ?? ApiDatasource(),
        _firestoreDatasource = firestoreDatasource;

  /// Fetch all words — API first, Firestore fallback.
  Future<List<Word>> getAllWords() async {
    try {
      return await _apiDatasource.fetchAllWords();
    } catch (e) {
      final firestore = _firestoreDatasource;
      if (firestore != null) {
        try {
          return await firestore.getAllWords();
        } catch (_) {
          rethrow;
        }
      }
      rethrow;
    }
  }

  /// Add a new word — API first, Firestore fallback.
  Future<void> addWord({
    required String word,
    required String meaning,
    required String translation,
  }) async {
    try {
      await _apiDatasource.addWord(
        word: word,
        meaning: meaning,
        translation: translation,
      );
    } catch (e) {
      final firestore = _firestoreDatasource;
      if (firestore != null) {
        final wordModel = _createWordModel(word, meaning, translation);
        await firestore.addWord(wordModel);
        return;
      }
      rethrow;
    }
  }

  /// Delete a word — API first, Firestore fallback.
  Future<void> deleteWord(String id) async {
    try {
      await _apiDatasource.deleteWord(id);
    } catch (e) {
      final firestore = _firestoreDatasource;
      if (firestore != null) {
        await firestore.deleteWord(id);
        return;
      }
      rethrow;
    }
  }

  /// Dispose resources.
  void dispose() {
    _apiDatasource.dispose();
  }

  /// Helper to create a WordModel for Firestore writes.
  _createWordModel(String word, String meaning, String translation) {
    // Import dynamically to avoid requiring Firebase when not needed
    return _firestoreDatasource != null
        ? _buildWordModel(word, meaning, translation)
        : null;
  }

  dynamic _buildWordModel(String word, String meaning, String translation) {
    // Lazy import to avoid Firebase dependency
    final models = _firestoreDatasource;
    if (models == null) return null;
    
    // We can use the datasource's addWord which handles model creation
    return null; // Not needed since we pass raw values
  }
}
