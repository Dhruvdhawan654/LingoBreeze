import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Error state widget shown when word fetching fails.
/// Features a friendly error message and a retry button.
class ErrorState extends StatefulWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  State<ErrorState> createState() => _ErrorStateState();
}

class _ErrorStateState extends State<ErrorState>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Error icon with warm background
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.errorColor.withValues(alpha: 0.1),
                ),
                child: Icon(
                  Icons.cloud_off_rounded,
                  size: 48,
                  color: AppTheme.errorColor.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 28),

              // Title
              Text(
                'Something went wrong',
                style: AppTheme.headingSmall.copyWith(
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              // Error message
              Text(
                widget.message,
                textAlign: TextAlign.center,
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textMuted,
                  height: 1.5,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 32),

              // Retry button — warm terracotta outline
              OutlinedButton.icon(
                onPressed: widget.onRetry,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.accentTerracotta,
                  side: BorderSide(
                    color: AppTheme.accentTerracotta.withValues(alpha: 0.4),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.refresh_rounded, size: 22),
                label: Text('Try Again', style: AppTheme.labelMedium.copyWith(color: AppTheme.accentTerracotta)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
