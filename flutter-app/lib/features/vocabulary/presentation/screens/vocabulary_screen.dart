import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../providers/vocabulary_provider.dart';
import '../widgets/empty_state.dart';
import '../widgets/error_state.dart';
import '../widgets/word_list.dart';
import '../widgets/add_word_sheet.dart';

/// Main vocabulary screen that displays the user's saved words.
/// Handles loading, empty, error, and filled states.
class VocabularyScreen extends ConsumerStatefulWidget {
  const VocabularyScreen({super.key});

  @override
  ConsumerState<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends ConsumerState<VocabularyScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fabController;
  late Animation<double> _fabScaleAnimation;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fabScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fabController,
        curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
      ),
    );
    _fabController.forward();
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  void _showAddWordSheet() {
    showAddWordSheet(context);
  }

  Future<void> _onRefresh() async {
    await ref.read(vocabularyProvider.notifier).refresh();
  }

  void _onDeleteWord(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.warmWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Delete Word', style: AppTheme.headingSmall),
        content: Text(
          'Are you sure you want to remove this word from your vocabulary?',
          style: AppTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: AppTheme.labelMedium
                    .copyWith(color: AppTheme.textMuted)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(vocabularyProvider.notifier).deleteWord(id);
            },
            child: Text('Delete',
                style: AppTheme.labelMedium
                    .copyWith(color: AppTheme.errorColor)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vocabularyState = ref.watch(vocabularyProvider);

    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.backgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Header ───────────────────────────────────────────
              _buildHeader(vocabularyState),

              // ─── Content ──────────────────────────────────────────
              Expanded(
                child: vocabularyState.when(
                  loading: () => const ShimmerLoading(),
                  error: (error, _) => ErrorState(
                    message: _getErrorMessage(error),
                    onRetry: _onRefresh,
                  ),
                  data: (words) {
                    if (words.isEmpty) {
                      return EmptyState(onAddWord: _showAddWordSheet);
                    }
                    return WordList(
                      words: words,
                      onRefresh: _onRefresh,
                      onDelete: _onDeleteWord,
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        // ─── FAB ──────────────────────────────────────────────────
        floatingActionButton: ScaleTransition(
          scale: _fabScaleAnimation,
          child: FloatingActionButton.extended(
            onPressed: _showAddWordSheet,
            backgroundColor: AppTheme.accentTerracotta,
            foregroundColor: Colors.white,
            elevation: 3,
            highlightElevation: 5,
            icon: const Icon(Icons.add_rounded, color: Colors.white),
            label: Text('Add Word', style: AppTheme.buttonText.copyWith(fontSize: 15)),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AsyncValue vocabularyState) {
    final wordCount = vocabularyState.valueOrNull?.length ?? 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App Logo / Brand
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.accentTerracotta,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.accentTerracotta.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.auto_stories_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('My Vocabulary', style: AppTheme.headingLarge),
                  const SizedBox(height: 2),
                  Text(
                    wordCount > 0
                        ? '$wordCount word${wordCount == 1 ? '' : 's'} saved'
                        : 'LingoBreeze',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.accentTerracotta.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  String _getErrorMessage(Object error) {
    final message = error.toString();
    if (message.contains('SocketException') ||
        message.contains('ClientException') ||
        message.contains('NetworkException')) {
      return 'Unable to connect to the server.\nPlease check your internet connection.';
    }
    if (message.contains('TimeoutException')) {
      return 'The request timed out.\nPlease try again.';
    }
    return 'Failed to load your vocabulary.\nPlease try again.';
  }
}
