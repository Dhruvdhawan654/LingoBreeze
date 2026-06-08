/// Domain entity representing a vocabulary word.
/// This is the core business object, independent of any data source.
class Word {
  final String id;
  final String word;
  final String meaning;
  final String translation;
  final DateTime createdAt;

  const Word({
    required this.id,
    required this.word,
    required this.meaning,
    required this.translation,
    required this.createdAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Word && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Word(id: $id, word: $word)';
}
