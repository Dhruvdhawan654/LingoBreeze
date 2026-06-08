import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/vocabulary_provider.dart';

/// Modal bottom sheet for adding a new vocabulary word.
/// Features warm styling, form validation, and loading state.
class AddWordSheet extends ConsumerStatefulWidget {
  const AddWordSheet({super.key});

  @override
  ConsumerState<AddWordSheet> createState() => _AddWordSheetState();
}

class _AddWordSheetState extends ConsumerState<AddWordSheet>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _wordController = TextEditingController();
  final _meaningController = TextEditingController();
  final _translationController = TextEditingController();
  bool _isLoading = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _wordController.dispose();
    _meaningController.dispose();
    _translationController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _submitWord() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(vocabularyProvider.notifier).addWord(
            word: _wordController.text,
            meaning: _meaningController.text,
            translation: _translationController.text,
          );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded,
                    color: AppTheme.successColor, size: 20),
                const SizedBox(width: 10),
                Text(
                  '"${_wordController.text}" added successfully!',
                  style: AppTheme.bodyMedium
                      .copyWith(color: AppTheme.textPrimary),
                ),
              ],
            ),
            backgroundColor: AppTheme.warmWhite,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline_rounded,
                    color: AppTheme.errorColor, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Failed to add word. Please try again.',
                    style: AppTheme.bodyMedium
                        .copyWith(color: AppTheme.textPrimary),
                  ),
                ),
              ],
            ),
            backgroundColor: AppTheme.warmWhite,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: EdgeInsets.only(bottom: bottomInset),
        decoration: BoxDecoration(
          color: AppTheme.warmCream,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: const Border(
            top: BorderSide(
              color: AppTheme.cardBorder,
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: AppTheme.textMuted.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Title
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.accentTerracotta,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  AppTheme.accentTerracotta.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Add New Word',
                              style: AppTheme.headingSmall),
                          const SizedBox(height: 2),
                          Text(
                            'Save a word to your vocabulary',
                            style: AppTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Word field
                  TextFormField(
                    controller: _wordController,
                    style: AppTheme.bodyLarge,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: AppTheme.inputDecoration(
                      label: 'Word',
                      hint: 'e.g., Apple',
                      icon: Icons.text_fields_rounded,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a word';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),

                  // Meaning field
                  TextFormField(
                    controller: _meaningController,
                    style: AppTheme.bodyLarge,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 2,
                    decoration: AppTheme.inputDecoration(
                      label: 'Meaning',
                      hint: 'e.g., A fruit',
                      icon: Icons.lightbulb_outline_rounded,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter the meaning';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),

                  // Translation field
                  TextFormField(
                    controller: _translationController,
                    style: AppTheme.bodyLarge,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: AppTheme.inputDecoration(
                      label: 'Translation',
                      hint: 'e.g., Manzana',
                      icon: Icons.translate_rounded,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter the translation';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 28),

                  // Submit button — warm solid
                  GestureDetector(
                    onTap: _isLoading ? null : _submitWord,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 56,
                      decoration: BoxDecoration(
                        color: _isLoading
                            ? AppTheme.accentTerracotta.withValues(alpha: 0.5)
                            : AppTheme.accentTerracotta,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: _isLoading
                            ? []
                            : [
                                BoxShadow(
                                  color: AppTheme.accentTerracotta
                                      .withValues(alpha: 0.25),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                      ),
                      child: Center(
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.save_rounded,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 10),
                                  Text('Save Word',
                                      style: AppTheme.buttonText),
                                ],
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Shows the add word bottom sheet.
void showAddWordSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black38,
    builder: (context) => const AddWordSheet(),
  );
}
