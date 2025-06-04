// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class TREn extends TR {
  TREn([String locale = 'en']) : super(locale);

  @override
  String get title => 'OpenSeed';

  @override
  String get home => 'Home';

  @override
  String get explore => 'Explore';

  @override
  String get settings => 'Settings';

  @override
  String get backToTop => 'Back to top';

  @override
  String get search => 'Search';

  @override
  String get refersh => 'Refersh';

  @override
  String get loadFailed => 'Loading failed';

  @override
  String get retry => 'Retry';

  @override
  String get notFound => 'Not Found';

  @override
  String get pageNotFound => 'Page Not Found';

  @override
  String pageNotFoundMessage(String title) {
    return 'Sorry, $title is currently not available';
  }

  @override
  String get tryToUseOtherKeywords => 'Try to use other keywords';

  @override
  String get menu => 'Menu';

  @override
  String get takePhoto => 'Take photo';

  @override
  String get selectFromGallery => 'Select from gallery';

  @override
  String get general => 'General';

  @override
  String get advanced => 'Advanced';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get system => 'System';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get modelConfig => 'Model Config';

  @override
  String get backendType => 'Backend Type';

  @override
  String get numberOfThreads => 'Number of Threads';

  @override
  String get setNumberOfThreads => 'Set Number of Threads';

  @override
  String get enterANumberGtZero => 'Enter a number > 0';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get pleaseEnterANumberGtZero => 'Please enter a valid number greater than 0';

  @override
  String get topK => 'Top K';

  @override
  String get apiBaseUrl => 'API Base URL';

  @override
  String get notSet => 'Not Set';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get appVersion => 'V1.0.0';

  @override
  String get appIntroduction =>
      'OpenSeed APP is an AI-powered, large-scale and open-source seed identification showcase for seed analysis ecosystem.\n\nAuthor: XXX\n\nCopyright © 2025 OpenSeed All rights reserved.\n\n';

  @override
  String get appAuthor => 'Author: Rainyl and all contributors.';

  @override
  String get appCopyright => 'Copyright © 2025 OpenSeed All rights reserved.';

  @override
  String get inference => 'Inference';

  @override
  String get results => 'Results';

  @override
  String get inferenceFailed => 'Inference Failed';

  @override
  String get inferenceImage => 'Inference Image';

  @override
  String get modelInfo => 'Model Info';

  @override
  String get model => 'Model';

  @override
  String get backend => 'Backend';

  @override
  String get memory => 'Memory';

  @override
  String get time => 'Time';

  @override
  String get flops => 'FLOPs';

  @override
  String get confidence => 'Confidence';

  @override
  String get details => 'Details';

  @override
  String get copySpNameToClipboard => 'Copy species name to clipboard';

  @override
  String get copiedSpNameToClipboard => 'Copied species name to clipboard';

  @override
  String get spInfoNotAvailable => 'Species information not available';

  @override
  String get pullToFetchMore => 'Pull to fetch more';

  @override
  String get copyUrl => 'Copy URL';

  @override
  String get copiedUrlToClipboard => 'Copied URL to clipboard';

  @override
  String get openInBrowser => 'Open in Browser';

  @override
  String get downloadingModel => 'Downloading Model';

  @override
  String downloadingModelName(String modelName) {
    return 'Downloading $modelName...';
  }

  @override
  String get userCancelledDownload => 'User cancelled download';

  @override
  String get startDownloading => 'Starting download';

  @override
  String modelDownloadCompleted(String modelName) {
    return 'Model $modelName download completed';
  }

  @override
  String get downloadFailed => 'Download failed';

  @override
  String get downloadCancelled => 'Download cancelled';

  @override
  String downloadFailedWithError(String error) {
    return 'Download failed: $error';
  }

  @override
  String get modelFileNotExists => 'Model file does not exist';

  @override
  String modelFileNotExistsDownload(String modelName) {
    return 'Model $modelName file does not exist, download it?';
  }

  @override
  String get download => 'Download';
}
