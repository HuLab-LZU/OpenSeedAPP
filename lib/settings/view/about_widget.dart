import 'package:flutter/material.dart';
import 'package:open_seed/l10n/g/app_localizations.dart';

class AboutWidget extends StatelessWidget {
  const AboutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withAlpha(128),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text.rich(
            TextSpan(text: TR.of(context).title, style: Theme.of(context).textTheme.titleLarge),
            textAlign: TextAlign.center,
          ),
          const Divider(),
          Image.asset("assets/icons/logo.png", height: 100),
          const SizedBox(height: 10),
          Text.rich(
            TextSpan(text: TR.of(context).appIntroduction, style: Theme.of(context).textTheme.bodyLarge),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
