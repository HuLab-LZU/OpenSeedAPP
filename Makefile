l10n:
	@echo "Generating l10n files"
	dart run intl_translation:extract_to_arb --output-file=lib/l10n/intl_en.arb lib/l10n/localization_intl.dart
	dart run intl_translation:generate_from_arb --output-dir=lib/l10n/g --no-use-deferred-loading lib/l10n/localization_intl.dart lib/l10n/intl_*.arb

build_runner:
	dart run build_runner clean
	dart run build_runner build --delete-conflicting-outputs
