import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Empty state widget shown when no words have been saved yet.
/// Features a friendly message and a warm call-to-action button.
class EmptyState extends StatefulWidget {
  final VoidCallback onAddWord;

  const EmptyState({super.key, required this.onAddWord});

  @override
  State<EmptyState> createState() => _EmptyStateState();
}

class _EmptyStateState extends State<EmptyState>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6, curve: Curves.easeOut)),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.1, 0.7, curve: Curves.easeOutCubic)),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.3, 1.0, curve: Curves.elasticOut)),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon with warm background
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.warmBeige,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accentTerracotta.withValues(alpha: 0.08),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.auto_stories_rounded,
                    size: 52,
                    color: AppTheme.accentTerracotta.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 32),

                // Title
                Text(
                  'No words yet',
                  style: AppTheme.headingMedium.copyWith(
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),

                // Subtitle
                Text(
                  'You haven\'t saved any words yet.\nStart building your vocabulary!',
                  textAlign: TextAlign.center,
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textMuted,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 40),

                // Animated CTA Button — warm solid
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: GestureDetector(
                    onTap: widget.onAddWord,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 18,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.accentTerracotta,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.accentTerracotta.withValues(alpha: 0.25),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Add Your First Word',
                            style: AppTheme.buttonText,
                          ),
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
    );
  }
}
