import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/word_model.dart';

/// Data source for Firestore operations on vocabulary words.
/// Handles direct CRUD operations with the Firestore database.
class FirestoreDatasource {
  final FirebaseFirestore _firestore;
  static const String _collection = 'words';

  FirestoreDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Reference to the words collection.
  CollectionReference get _wordsRef => _firestore.collection(_collection);

  /// Add a new word to Firestore.
  /// Returns the document ID of the newly created word.
  Future<String> addWord(WordModel word) async {
    final docRef = await _wordsRef.add(word.toFirestore());
    return docRef.id;
  }

  /// Get all words from Firestore, ordered by creation date (newest first).
  Future<List<WordModel>> getAllWords() async {
    final snapshot = await _wordsRef
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => WordModel.fromFirestore(doc))
        .toList();
  }

  /// Stream of all words for real-time updates.
  Stream<List<WordModel>> watchAllWords() {
    return _wordsRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => WordModel.fromFirestore(doc))
            .toList());
  }

  /// Delete a word by its document ID.
  Future<void> deleteWord(String id) async {
    await _wordsRef.doc(id).delete();
  }
}
