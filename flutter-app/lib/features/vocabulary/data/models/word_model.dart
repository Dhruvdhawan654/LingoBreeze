import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/word.dart';

/// Data model for vocabulary words with serialization support
/// for both Firestore and the REST API.
class WordModel extends Word {
  const WordModel({
    required super.id,
    required super.word,
    required super.meaning,
    required super.translation,
    required super.createdAt,
  });

  /// Create a WordModel from a Firestore document snapshot.
  factory WordModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WordModel(
      id: doc.id,
      word: data['word'] ?? '',
      meaning: data['meaning'] ?? '',
      translation: data['translation'] ?? '',
      createdAt: _parseTimestamp(data['createdAt']),
    );
  }

  /// Create a WordModel from a JSON map (API response).
  factory WordModel.fromJson(Map<String, dynamic> json) {
    return WordModel(
      id: json['id'] ?? '',
      word: json['word'] ?? '',
      meaning: json['meaning'] ?? '',
      translation: json['translation'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  /// Convert to a Firestore-compatible map.
  Map<String, dynamic> toFirestore() {
    return {
      'word': word,
      'meaning': meaning,
      'translation': translation,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  /// Convert to a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'word': word,
      'meaning': meaning,
      'translation': translation,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Helper to parse Firestore Timestamps and ISO strings.
  static DateTime _parseTimestamp(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    } else if (value is String) {
      return DateTime.parse(value);
    }
    return DateTime.now();
  }
}
