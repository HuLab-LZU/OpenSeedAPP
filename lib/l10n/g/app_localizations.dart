import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of TR
/// returned by `TR.of(context)`.
///
/// Applications need to include `TR.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'g/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: TR.localizationsDelegates,
///   supportedLocales: TR.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the TR.supportedLocales
/// property.
abstract class TR {
  TR(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static TR of(BuildContext context) {
    return Localizations.of<TR>(context, TR)!;
  }

  static const LocalizationsDelegate<TR> delegate = _TRDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en'), Locale('zh')];

  /// Title
  ///
  /// In en, this message translates to:
  /// **'OpenSeed'**
  String get title;

  /// Home
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// Settings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Back to top
  ///
  /// In en, this message translates to:
  /// **'Back to top'**
  String get backToTop;

  /// Search
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Refersh
  ///
  /// In en, this message translates to:
  /// **'Refersh'**
  String get refersh;

  /// Load failed
  ///
  /// In en, this message translates to:
  /// **'Loading failed'**
  String get loadFailed;

  /// Retry
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Not Found
  ///
  /// In en, this message translates to:
  /// **'Not Found'**
  String get notFound;

  /// Page Not Found
  ///
  /// In en, this message translates to:
  /// **'Page Not Found'**
  String get pageNotFound;

  /// Page not found message with title
  ///
  /// In en, this message translates to:
  /// **'Sorry, {title} is currently not available'**
  String pageNotFoundMessage(String title);

  /// Try to use other keywords
  ///
  /// In en, this message translates to:
  /// **'Try to use other keywords'**
  String get tryToUseOtherKeywords;

  /// Menu
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// Take Photo
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get takePhoto;

  /// Select from gallery
  ///
  /// In en, this message translates to:
  /// **'Select from gallery'**
  String get selectFromGallery;

  /// General
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// Advanced
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// Language
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Theme
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// System
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// Light
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// Dark
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// Model Config
  ///
  /// In en, this message translates to:
  /// **'Model Config'**
  String get modelConfig;

  /// Backend Type
  ///
  /// In en, this message translates to:
  /// **'Backend Type'**
  String get backendType;

  /// Number of Threads
  ///
  /// In en, this message translates to:
  /// **'Number of Threads'**
  String get numberOfThreads;

  /// Set Number of Threads
  ///
  /// In en, this message translates to:
  /// **'Set Number of Threads'**
  String get setNumberOfThreads;

  /// Enter a number greater than zero
  ///
  /// In en, this message translates to:
  /// **'Enter a number > 0'**
  String get enterANumberGtZero;

  /// Cancel
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// OK
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Please enter a number greater than zero
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number greater than 0'**
  String get pleaseEnterANumberGtZero;

  /// Top K
  ///
  /// In en, this message translates to:
  /// **'Top K'**
  String get topK;

  /// API Base URL
  ///
  /// In en, this message translates to:
  /// **'API Base URL'**
  String get apiBaseUrl;

  /// Not Set
  ///
  /// In en, this message translates to:
  /// **'Not Set'**
  String get notSet;

  /// About
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Version
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// App Version
  ///
  /// In en, this message translates to:
  /// **'V1.0.0'**
  String get appVersion;

  /// App Introduction
  ///
  /// In en, this message translates to:
  /// **'OpenSeed APP is an AI-powered, large-scale and open-source seed identification showcase for seed analysis ecosystem.\n\nAuthor: XXX\n\nCopyright © 2025 OpenSeed All rights reserved.\n\n'**
  String get appIntroduction;

  /// App Author
  ///
  /// In en, this message translates to:
  /// **'Author: Rainyl and all contributors.'**
  String get appAuthor;

  /// App Copyright
  ///
  /// In en, this message translates to:
  /// **'Copyright © 2025 OpenSeed All rights reserved.'**
  String get appCopyright;

  /// Inference
  ///
  /// In en, this message translates to:
  /// **'Inference'**
  String get inference;

  /// Inference Result
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get results;

  /// Inference Failed
  ///
  /// In en, this message translates to:
  /// **'Inference Failed'**
  String get inferenceFailed;

  /// Inference Image
  ///
  /// In en, this message translates to:
  /// **'Inference Image'**
  String get inferenceImage;

  /// Model Info
  ///
  /// In en, this message translates to:
  /// **'Model Info'**
  String get modelInfo;

  /// Model
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get model;

  /// Backend
  ///
  /// In en, this message translates to:
  /// **'Backend'**
  String get backend;

  /// Memory
  ///
  /// In en, this message translates to:
  /// **'Memory'**
  String get memory;

  /// Time
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// FLOPs
  ///
  /// In en, this message translates to:
  /// **'FLOPs'**
  String get flops;

  /// Confidence
  ///
  /// In en, this message translates to:
  /// **'Confidence'**
  String get confidence;

  /// Details
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// Copy species Name to Clipboard
  ///
  /// In en, this message translates to:
  /// **'Copy species name to clipboard'**
  String get copySpNameToClipboard;

  /// Copied species Name to Clipboard
  ///
  /// In en, this message translates to:
  /// **'Copied species name to clipboard'**
  String get copiedSpNameToClipboard;

  /// Species information not available
  ///
  /// In en, this message translates to:
  /// **'Species information not available'**
  String get spInfoNotAvailable;

  /// Pull to fetch more
  ///
  /// In en, this message translates to:
  /// **'Pull to fetch more'**
  String get pullToFetchMore;

  /// Copy URL
  ///
  /// In en, this message translates to:
  /// **'Copy URL'**
  String get copyUrl;

  /// Copied URL to Clipboard
  ///
  /// In en, this message translates to:
  /// **'Copied URL to clipboard'**
  String get copiedUrlToClipboard;

  /// Open in Browser
  ///
  /// In en, this message translates to:
  /// **'Open in Browser'**
  String get openInBrowser;

  /// Downloading Model
  ///
  /// In en, this message translates to:
  /// **'Downloading Model'**
  String get downloadingModel;

  /// Downloading model with name
  ///
  /// In en, this message translates to:
  /// **'Downloading {modelName}...'**
  String downloadingModelName(String modelName);

  /// User cancelled download
  ///
  /// In en, this message translates to:
  /// **'User cancelled download'**
  String get userCancelledDownload;

  /// Starting download
  ///
  /// In en, this message translates to:
  /// **'Starting download'**
  String get startDownloading;

  /// Model download completed with name
  ///
  /// In en, this message translates to:
  /// **'Model {modelName} download completed'**
  String modelDownloadCompleted(String modelName);

  /// Download failed
  ///
  /// In en, this message translates to:
  /// **'Download failed'**
  String get downloadFailed;

  /// Download cancelled
  ///
  /// In en, this message translates to:
  /// **'Download cancelled'**
  String get downloadCancelled;

  /// Download failed with error message
  ///
  /// In en, this message translates to:
  /// **'Download failed: {error}'**
  String downloadFailedWithError(String error);

  /// Model file does not exist
  ///
  /// In en, this message translates to:
  /// **'Model file does not exist'**
  String get modelFileNotExists;

  /// Model file does not exist, ask to download
  ///
  /// In en, this message translates to:
  /// **'Model {modelName} file does not exist, download it?'**
  String modelFileNotExistsDownload(String modelName);

  /// Download
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;
}

class _TRDelegate extends LocalizationsDelegate<TR> {
  const _TRDelegate();

  @override
  Future<TR> load(Locale locale) {
    return SynchronousFuture<TR>(lookupTR(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_TRDelegate old) => false;
}

TR lookupTR(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return TREn();
    case 'zh':
      return TRZh();
  }

  throw FlutterError(
    'TR.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
