import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/word.dart';
import 'package:intl/intl.dart';

/// A warm, paper-styled card displaying a vocabulary word.
/// Features a gentle slide-in animation on first build.
class WordCard extends StatefulWidget {
  final Word word;
  final int index;
  final VoidCallback? onDelete;

  const WordCard({
    super.key,
    required this.word,
    required this.index,
    this.onDelete,
  });

  @override
  State<WordCard> createState() => _WordCardState();
}

class _WordCardState extends State<WordCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Stagger the animation based on the card index
    final delay = (widget.index * 100).clamp(0, 500);
    Future.delayed(Duration(milliseconds: delay), () {
      if (mounted) _controller.forward();
    });

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: AppTheme.warmCard,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              splashColor: AppTheme.accentTerracotta.withValues(alpha: 0.08),
              highlightColor: AppTheme.accentTerracotta.withValues(alpha: 0.04),
              onTap: () {}, // Could expand for detail view
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row with word and delete
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Word indicator dot — warm earthy color
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(top: 8, right: 12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.index % 2 == 0
                                ? AppTheme.accentTerracotta
                                : AppTheme.accentSage,
                          ),
                        ),

                        // Word title
                        Expanded(
                          child: Text(
                            widget.word.word,
                            style: AppTheme.headingSmall.copyWith(
                              fontSize: 20,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),

                        // Delete button
                        if (widget.onDelete != null)
                          GestureDetector(
                            onTap: widget.onDelete,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppTheme.errorColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.delete_outline_rounded,
                                size: 18,
                                color: AppTheme.errorColor.withValues(alpha: 0.7),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Meaning
                    _InfoRow(
                      label: 'Meaning',
                      value: widget.word.meaning,
                      icon: Icons.lightbulb_outline_rounded,
                    ),
                    const SizedBox(height: 8),

                    // Translation
                    _InfoRow(
                      label: 'Translation',
                      value: widget.word.translation,
                      icon: Icons.translate_rounded,
                    ),

                    // Timestamp
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        DateFormat('MMM d, yyyy').format(widget.word.createdAt),
                        style: AppTheme.bodySmall.copyWith(
                          fontSize: 11,
                          color: AppTheme.textMuted.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A row showing a label-value pair with an icon.
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: AppTheme.accentTerracotta.withValues(alpha: 0.5),
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: AppTheme.bodySmall.copyWith(
            color: AppTheme.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
