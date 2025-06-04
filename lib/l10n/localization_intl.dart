import 'package:intl/intl.dart';

class TR {
  // app.dart
  String get title => Intl.message('OpenSeed', name: 'title', desc: 'Title');
  String get home => Intl.message('Home', name: 'home', desc: 'Home');
  String get explore => Intl.message('Explore', name: 'explore', desc: 'Explore');
  String get settings => Intl.message('Settings', name: 'settings', desc: 'Settings');

  // explore_page.dart
  String get backToTop => Intl.message('Back to top', name: 'backToTop', desc: 'Back to top');
  String get search => Intl.message('Search', name: 'search', desc: 'Search');
  String get refersh => Intl.message('Refersh', name: 'refersh', desc: 'Refersh');
  String get loadFailed => Intl.message('Loading failed', name: 'loadFailed', desc: 'Load failed');
  String get retry => Intl.message('Retry', name: 'retry', desc: 'Retry');
  String get notFound => Intl.message('Not Found', name: 'notFound', desc: 'Not Found');
  String get tryToUseOtherKeywords => Intl.message(
    'Try to use other keywords',
    name: 'tryToUseOtherKeywords',
    desc: 'Try to use other keywords',
  );

  // open_seed_page.dart
  String get menu => Intl.message('Menu', name: 'menu', desc: 'Menu');
  String get takePhoto => Intl.message('Take photo', name: 'takePhoto', desc: 'Take Photo');
  String get selectFromGallery =>
      Intl.message('Select from gallery', name: 'selectFromGallery', desc: 'Select from gallery');

  // settings_page.dart
  String get language => Intl.message('Language', name: 'language', desc: 'Language');
  String get theme => Intl.message('Theme', name: 'theme', desc: 'Theme');
  String get system => Intl.message('System', name: 'system', desc: 'System');
  String get light => Intl.message('Light', name: 'light', desc: 'Light');
  String get dark => Intl.message('Dark', name: 'dark', desc: 'Dark');
  String get modelConfig => Intl.message('Model Config', name: 'modelConfig', desc: 'Model Config');
  String get backendType => Intl.message('Backend Type', name: 'backendType', desc: 'Backend Type');
  String get numberOfThreads =>
      Intl.message('Number of Threads', name: 'numberOfThreads', desc: 'Number of Threads');
  String get setNumberOfThreads =>
      Intl.message('Set Number of Threads', name: 'setNumberOfThreads', desc: 'Set Number of Threads');
  String get enterANumberGtZero => Intl.message(
    'Enter a number > 0',
    name: 'enterANumberGtZero',
    desc: 'Enter a number greater than zero',
  );
  String get cancel => Intl.message('Cancel', name: 'cancel', desc: 'Cancel');
  String get ok => Intl.message('OK', name: 'ok', desc: 'OK');
  String get pleaseEnterANumberGtZero => Intl.message(
    'Please enter a valid number greater than 0',
    name: 'pleaseEnterANumberGtZero',
    desc: 'Please enter a number greater than zero',
  );
  String get topK => Intl.message('Top K', name: 'topK', desc: 'Top K');
  String get apiBaseUrl => Intl.message('API Base URL', name: 'apiBaseUrl', desc: 'API Base URL');
  String get notSet => Intl.message('Not Set', name: 'notSet', desc: 'Not Set');
  String get about => Intl.message('About', name: 'about', desc: 'About');
  String get version => Intl.message('Version', name: 'version', desc: 'Version');
  String get appVersion => Intl.message('V1.0.0', name: 'appVersion', desc: 'App Version');
  String get appIntroduction => Intl.message(
    "OpenSeed APP is an AI-powered, large-scale and open-source seed "
    "identification showcase for seed analysis ecosystem.",
    name: 'appIntroduction',
    desc: 'App Introduction',
  );
  String get appAuthor =>
      Intl.message("Author: Rainyl and all contributors.", name: 'appAuthor', desc: 'App Author');

  String get appCopyright => Intl.message(
    "Copyright © 2025 OpenSeed All rights reserved.",
    name: 'appCopyright',
    desc: 'App Copyright',
  );

  // inference_page.dart
  String get inference => Intl.message('Inference', name: 'inference', desc: 'Inference');
  String get results => Intl.message('Results', name: 'results', desc: 'Inference Result');
  String get inferenceFailed =>
      Intl.message('Inference Failed', name: 'inferenceFailed', desc: 'Inference Failed');
  String get inferenceImage =>
      Intl.message('Inference Image', name: 'inferenceImage', desc: 'Inference Image');
  String get modelInfo => Intl.message('Model Info', name: 'modelInfo', desc: 'Model Info');
  String get model => Intl.message('Model', name: 'model', desc: 'Model');
  String get backend => Intl.message('Backend', name: 'backend', desc: 'Backend');
  String get memory => Intl.message('Memory', name: 'memory', desc: 'Memory');
  String get time => Intl.message('Time', name: 'time', desc: 'Time');
  String get flops => Intl.message('FLOPs', name: 'flops', desc: 'FLOPs');
  String get confidence => Intl.message('Confidence', name: 'confidence', desc: 'Confidence');
  String get details => Intl.message('Details', name: 'details', desc: 'Details');
  String get copySpNameToClipboard => Intl.message(
    'Copy species name to clipboard',
    name: 'copySpNameToClipboard',
    desc: 'Copy species Name to Clipboard',
  );
  String get copiedSpNameToClipboard => Intl.message(
    'Copied species name to clipboard',
    name: 'copiedSpNameToClipboard',
    desc: 'Copied species Name to Clipboard',
  );
  String get spInfoNotAvailable => Intl.message(
    'Species information not available',
    name: 'spInfoNotAvailable',
    desc: 'Species information not available',
  );

  // fetch_more_indicator.dart
  String get pullToFetchMore =>
      Intl.message('Pull to fetch more', name: 'pullToFetchMore', desc: 'Pull to fetch more');

  // webview_page.dart
  String get copyUrl => Intl.message('Copy URL', name: 'copyUrl', desc: 'Copy URL');
  String get copiedUrlToClipboard =>
      Intl.message('Copied URL to clipboard', name: 'copiedUrlToClipboard', desc: 'Copied URL to Clipboard');
  String get openInBrowser => Intl.message('Open in Browser', name: 'openInBrowser', desc: 'Open in Browser');
}
