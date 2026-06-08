import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/word.dart';
import 'word_card.dart';

/// An animated list of word cards.
/// Handles the list rendering with proper padding and animations.
class WordList extends StatelessWidget {
  final List<Word> words;
  final Future<void> Function() onRefresh;
  final void Function(String id)? onDelete;

  const WordList({
    super.key,
    required this.words,
    required this.onRefresh,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppTheme.accentTerracotta,
      backgroundColor: AppTheme.warmWhite,
      strokeWidth: 2.5,
      displacement: 60,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        itemCount: words.length,
        itemBuilder: (context, index) {
          return WordCard(
            word: words[index],
            index: index,
            onDelete: onDelete != null
                ? () => onDelete!(words[index].id)
                : null,
          );
        },
      ),
    );
  }
}
