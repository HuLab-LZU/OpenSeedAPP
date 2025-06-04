import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:open_seed/l10n/g/app_localizations.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({required this.title, this.message, this.onRetry, super.key});

  final String title;
  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 404 Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              Symbols.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
          ),
          const SizedBox(height: 32),

          // 404 Title
          Text(
            '404',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          const SizedBox(height: 16),

          // Page Not Found
          Text(
            TR.of(context).pageNotFound,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),

          // Custom message or default message
          Text(
            message ?? TR.of(context).pageNotFoundMessage(title),
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Retry button if callback provided
          if (onRetry != null)
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Symbols.refresh),
              label: Text(TR.of(context).retry),
            ),
        ],
      ),
    );
  }
}
