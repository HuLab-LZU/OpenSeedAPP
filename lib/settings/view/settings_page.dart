import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:open_seed/l10n/g/app_localizations.dart';
import 'package:open_seed/openseed/bloc/openseed_bloc.dart';
import 'package:open_seed/openseed/models/models.dart';
import 'package:open_seed/settings/view/about_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const SettingsPage());
  }

  String _getLanguageDisplayName(OseedLocale language) {
    switch (language) {
      case OseedLocale.zh_CN:
        return '中文';
      case OseedLocale.en_US:
        return 'English';
    }
  }

  Future<String> _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future<void> _downloadModel(BuildContext context, ModelConfig model) async {
    final modelFile = await model.getModelFile();
    final downloadUrl = '${ModelConfig.modelMirrorUrl}/${model.fileName}';

    final dio = Dio();
    final CancelToken cancelToken = CancelToken();
    bool downloadCancelled = false;

    try {
      unawaited(
        showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => AlertDialog(
                title: Text(TR.of(context).downloadingModel),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(TR.of(context).downloadingModelName(model.name)),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      downloadCancelled = true;
                      cancelToken.cancel(TR.of(context).userCancelledDownload);
                      Navigator.pop(context);
                    },
                    child: Text(TR.of(context).cancel),
                  ),
                ],
              ),
        ),
      );

      final response = await dio.download(downloadUrl, modelFile.path, cancelToken: cancelToken);

      if (context.mounted && !downloadCancelled && response.statusCode == HttpStatus.ok) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(TR.of(context).modelDownloadCompleted(model.name))));
      } else {
        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(TR.of(context).downloadFailed)));
        }
      }
    } catch (e) {
      if (downloadCancelled || e is DioException && e.type == DioExceptionType.cancel) {
        try {
          if (await modelFile.exists()) {
            await modelFile.delete();
          }
        } catch (deleteError) {
          // ignore
        }

        if (context.mounted) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(TR.of(context).downloadCancelled)));
        }
      } else {
        try {
          if (await modelFile.exists()) {
            await modelFile.delete();
          }
        } catch (deleteError) {
          // ignore
        }

        if (context.mounted) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          debugPrint('${TR.of(context).downloadFailed}: $e');
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(TR.of(context).downloadFailedWithError(e.toString()))));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(TR.of(context).settings)),
      body: BlocBuilder<OpenSeedBloc, OpenSeedState>(
        builder: (context, state) {
          final settings = state.settingsState;
          return ListView(
            padding: const EdgeInsets.all(21),
            children: [
              _buildGeneralSection(context, settings),
              const Divider(),
              _buildInferenceSection(context, settings),
              const Divider(),
              _buildAdvancedSection(context, settings),
              const Divider(),
              _buildAboutSection(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGeneralSection(BuildContext context, SettingsState settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            TR.of(context).general,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListTile(
          title: Text(TR.of(context).language),
          leading: const Icon(Symbols.language),
          subtitle: Text(_getLanguageDisplayName(settings.language)),
          onTap: () async {
            final selectedLanguage = await showModalBottomSheet<OseedLocale>(
              context: context,
              builder: (BuildContext context) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: OseedLocale.values.length,
                  itemBuilder: (context, index) {
                    final language = OseedLocale.values[index];
                    return ListTile(
                      title: Text(_getLanguageDisplayName(language)),
                      trailing:
                          settings.language == language
                              ? Icon(Symbols.check, color: Theme.of(context).colorScheme.primary)
                              : null,
                      onTap: () {
                        Navigator.pop(context, language);
                      },
                    );
                  },
                );
              },
            );
            if (selectedLanguage != null && context.mounted) {
              context.read<OpenSeedBloc>().add(
                OpenSeedSettingsChanged(settings.copyWith(language: selectedLanguage)),
              );
            }
          },
        ),
        ListTile(
          title: Text(TR.of(context).theme),
          leading: const Icon(Symbols.color_lens),
          subtitle: Text(settings.theme.toString().split('.').last),
          trailing: Switch(
            value: settings.theme == ThemeSettings.dark,
            onChanged: (v) {
              final newTheme = v ? ThemeSettings.dark : ThemeSettings.light;
              context.read<OpenSeedBloc>().add(OpenSeedSettingsChanged(settings.copyWith(theme: newTheme)));
            },
          ),
          onTap: () {
            final newTheme = settings.theme == ThemeSettings.light ? ThemeSettings.dark : ThemeSettings.light;
            context.read<OpenSeedBloc>().add(OpenSeedSettingsChanged(settings.copyWith(theme: newTheme)));
          },
        ),
      ],
    );
  }

  Widget _buildInferenceSection(BuildContext context, SettingsState settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            TR.of(context).inference,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // model list
        ListTile(
          title: Text(TR.of(context).modelConfig),
          leading: const Icon(Symbols.settings_applications),
          subtitle: Text(settings.modelConfig.name),
          onTap: () async {
            final selectedModel = await showModalBottomSheet<ModelConfig>(
              context: context,
              builder: (BuildContext context) => _buildModelList(context, settings),
            );
            if (selectedModel != null) {
              if (selectedModel.type == ModelType.file) {
                final modelFile = await selectedModel.getModelFile();
                if (!await modelFile.exists()) {
                  return;
                }
              }
              if (context.mounted) {
                context.read<OpenSeedBloc>().add(
                  OpenSeedSettingsChanged(settings.copyWith(modelConfig: selectedModel)),
                );
              }
            }
          },
        ),

        // backend list
        ListTile(
          title: Text(TR.of(context).backendType),
          leading: const Icon(Symbols.memory),
          subtitle: Text(settings.backendType.name),
          onTap: () async {
            final selectedBackendType = await showModalBottomSheet<BackendType>(
              context: context,
              builder: (BuildContext context) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: BackendType.all.length,
                  itemBuilder: (context, index) {
                    final backendType = BackendType.all[index];
                    return ListTile(
                      title: Text(backendType.name),
                      subtitle: Text(backendType.description),
                      onTap: () {
                        Navigator.pop(context, backendType);
                      },
                    );
                  },
                );
              },
            );
            if (selectedBackendType != null && context.mounted) {
              context.read<OpenSeedBloc>().add(
                OpenSeedSettingsChanged(settings.copyWith(backendType: selectedBackendType)),
              );
            }
          },
        ),

        // threads
        ListTile(
          title: Text(TR.of(context).numberOfThreads),
          leading: const Icon(Symbols.format_list_numbered_rtl),
          subtitle: Text(settings.numThreads.toString()),
          onTap: () async {
            final newNumThreads = await showDialog<int>(
              context: context,
              builder: (BuildContext context) {
                final TextEditingController controller = TextEditingController();
                return AlertDialog(
                  title: Text(TR.of(context).setNumberOfThreads),
                  content: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: TR.of(context).enterANumberGtZero),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text(TR.of(context).cancel),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text(TR.of(context).ok),
                      onPressed: () {
                        final int? value = int.tryParse(controller.text);
                        if (value != null && value > 0) {
                          Navigator.of(context).pop(value);
                        } else {
                          // Optionally, show an error message
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(TR.of(context).pleaseEnterANumberGtZero)));
                        }
                      },
                    ),
                  ],
                );
              },
            );
            if (newNumThreads != null && context.mounted) {
              context.read<OpenSeedBloc>().add(
                OpenSeedSettingsChanged(settings.copyWith(numThreads: newNumThreads)),
              );
            }
          },
        ),
        ListTile(
          title: Text(TR.of(context).topK),
          leading: const Icon(Symbols.filter_list),
          subtitle: Text(settings.topK.toString()),
          onTap: () async {
            final newTopK = await showModalBottomSheet<int>(
              context: context,
              builder: (BuildContext context) {
                final options = [1, 5, 10, 20, 50, 100];
                return ListView(
                  shrinkWrap: true,
                  children:
                      options
                          .map(
                            (option) => ListTile(
                              title: Text(option.toString()),
                              onTap: () {
                                Navigator.of(context).pop(option);
                              },
                            ),
                          )
                          .toList(),
                );
              },
            );
            if (newTopK != null && context.mounted) {
              context.read<OpenSeedBloc>().add(OpenSeedSettingsChanged(settings.copyWith(topK: newTopK)));
            }
          },
        ),
      ],
    );
  }

  // settings/inference/models
  Widget _buildModelList(BuildContext context, SettingsState settings) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: ModelConfig.all.length,
      itemBuilder: (context, index) {
        final model = ModelConfig.all[index];
        return ListTile(
          title: Text(model.name),
          subtitle: Text(model.description),
          selected: model == settings.modelConfig,
          trailing:
              model.type == ModelType.file
                  ? FutureBuilder<bool>(
                    future: model.getModelFile().then((file) => file.exists()),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        );
                      }
                      final isDownloaded = snapshot.data ?? false;
                      return Icon(isDownloaded ? Symbols.folder_open : Symbols.download);
                    },
                  )
                  : Icon(switch (model.type) {
                    ModelType.api => Symbols.cloud,
                    ModelType.assets => Symbols.memory,
                    ModelType.file => Symbols.folder_open, // fallback, won't be used
                  }),
          onTap: () async {
            // check if the model file exists for [ModelType.file]
            final modelFile = await model.getModelFile();
            if (model.type == ModelType.file && !await modelFile.exists()) {
              if (context.mounted) {
                final shouldDownload = await showDialog<bool>(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: Text(TR.of(context).modelFileNotExists),
                        content: Text(TR.of(context).modelFileNotExistsDownload(model.name)),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text(TR.of(context).cancel),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text(TR.of(context).download),
                          ),
                        ],
                      ),
                );

                if ((shouldDownload ?? false) && context.mounted) {
                  await _downloadModel(context, model);
                }
              }
            }

            if (context.mounted) {
              Navigator.pop(context, model);
            }
          },
        );
      },
    );
  }

  Widget _buildAdvancedSection(BuildContext context, SettingsState settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            TR.of(context).advanced,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListTile(
          title: Text(TR.of(context).apiBaseUrl),
          leading: const Icon(Symbols.http),
          subtitle: Text(settings.apiBaseUrl ?? TR.of(context).notSet),
          onTap: () {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Comming soon~'), duration: Durations.medium4));
          },
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            TR.of(context).about,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListTile(
          title: Text(TR.of(context).about),
          leading: const Icon(Symbols.info),
          subtitle: Text(TR.of(context).title),
          onTap: () async {
            if (context.mounted) {
              showAboutDialog(
                context: context,
                applicationName: TR.of(context).title,
                applicationIcon: Image.asset('assets/icons/logo.png', width: 54.1, height: 54.1),
                applicationVersion: await _getAppVersion(),
                children: [Text.rich(TextSpan(text: TR.of(context).appIntroduction))],
              );
            }
          },
        ),
        const AboutWidget(),
      ],
    );
  }
}
