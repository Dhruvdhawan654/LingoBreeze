import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/vocabulary_repository.dart';
import '../../domain/entities/word.dart';

/// Provider for the VocabularyRepository singleton.
final vocabularyRepositoryProvider = Provider<VocabularyRepository>((ref) {
  final repo = VocabularyRepository();
  ref.onDispose(() => repo.dispose());
  return repo;
});

/// AsyncNotifier that manages the vocabulary word list state.
/// Handles loading, error, and data states cleanly.
class VocabularyNotifier extends AsyncNotifier<List<Word>> {
  @override
  Future<List<Word>> build() async {
    return _fetchWords();
  }

  /// Fetch all words from the repository.
  Future<List<Word>> _fetchWords() async {
    final repository = ref.read(vocabularyRepositoryProvider);
    return await repository.getAllWords();
  }

  /// Refresh the word list from the API.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchWords());
  }

  /// Add a new word and refresh the list.
  Future<void> addWord({
    required String word,
    required String meaning,
    required String translation,
  }) async {
    final repository = ref.read(vocabularyRepositoryProvider);
    await repository.addWord(
      word: word,
      meaning: meaning,
      translation: translation,
    );
    // Refresh the list after adding
    await refresh();
  }

  /// Delete a word and refresh the list.
  Future<void> deleteWord(String id) async {
    final repository = ref.read(vocabularyRepositoryProvider);
    await repository.deleteWord(id);
    // Optimistically remove from local state
    state = AsyncValue.data(
      state.value?.where((w) => w.id != id).toList() ?? [],
    );
  }
}

/// The main provider for vocabulary words.
/// Use `ref.watch(vocabularyProvider)` to get the current state.
final vocabularyProvider =
    AsyncNotifierProvider<VocabularyNotifier, List<Word>>(
  VocabularyNotifier.new,
);
