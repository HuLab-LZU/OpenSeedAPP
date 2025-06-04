import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:open_seed/l10n/g/app_localizations.dart';
import 'package:open_seed/openseed/bloc/openseed_bloc.dart';
import 'package:open_seed/openseed/models/models.dart';
import 'package:open_seed/openseed/view/inference_page.dart';
import 'package:open_seed/openseed/view/photo_edit_page.dart';
import 'package:open_seed/openseed/widgets/widgets.dart';
import 'package:open_seed/settings/view/settings_page.dart';

class OpenSeedPage extends StatelessWidget {
  const OpenSeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ExpandableFab(
        tooltip: TR.of(context).menu,
        distance: 112,
        children: [
          ActionButton(
            tooltip: TR.of(context).refersh,
            onPressed: () {
              context.read<OpenSeedBloc>().add(OpenSeedWeatherRefreshed());
            },
            icon: const Icon(Symbols.refresh),
          ),
          ActionButton(
            tooltip: TR.of(context).takePhoto,
            onPressed: () async {
              await _pickImage(context, ImageSource.camera);
            },
            icon: const Icon(Symbols.camera_alt),
          ),
          ActionButton(
            tooltip: TR.of(context).selectFromGallery,
            onPressed: () async {
              await _pickImage(context, ImageSource.gallery);
            },
            icon: const Icon(Symbols.photo_library),
          ),
          ActionButton(
            tooltip: TR.of(context).settings,
            onPressed: () {
              Navigator.of(context).push<void>(SettingsPage.route());
            },
            icon: const Icon(Symbols.settings),
          ),
        ],
      ),
      body: BlocBuilder<OpenSeedBloc, OpenSeedState>(
        builder:
            (context, state) => CheckMarkIndicator(
              onRefresh: () async {
                context.read<OpenSeedBloc>().add(OpenSeedWeatherRefreshed());
              },
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image:
                            state.homeBgImageUrl == null
                                ? const AssetImage(OpenSeedBloc.homeBackgroundImage)
                                : CachedNetworkImageProvider(state.homeBgImageUrl!),
                      ),
                    ),
                  ),
                  // WeatherBackground(),
                  Positioned.fill(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(30, MediaQuery.of(context).padding.top + 50, 30, 0),
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildWeatherWidget(context, state),
                          _buildDateWidget(context, state),
                          const SizedBox(height: 50),
                          _buildImageSelectionWidget(context, state),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }

  Widget _buildWeatherWidget(BuildContext context, OpenSeedState state) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
      margin: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
      decoration: BoxDecoration(color: Colors.black.withAlpha(150), borderRadius: BorderRadius.circular(8.0)),
      child: WeatherWidget(
        weather: state.weather,
        onTap: () async {
          return context.read<OpenSeedBloc>().add(OpenSeedWeatherRefreshed());
        },
      ),
    );
  }

  Widget _buildDateWidget(BuildContext context, OpenSeedState state) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(color: Colors.black.withAlpha(150), borderRadius: BorderRadius.circular(8.0)),
      child: Column(
        children: [
          Text(
            DateFormat("yM", state.settingsState.language.name).format(DateTime.now()),
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            DateTime.now().day.toString().padLeft(2, '0'),
            style: textTheme.displayLarge!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat("EEEE", state.settingsState.language.name).format(DateTime.now()),
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSelectionWidget(BuildContext context, OpenSeedState state) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 3.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Symbols.camera_alt),
              label: Text(TR.of(context).takePhoto),
              // style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.black.withAlpha(128))),
              onPressed: () async {
                await _pickImage(context, ImageSource.camera);
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Symbols.photo_library),
              label: Text(TR.of(context).selectFromGallery),
              // style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.black.withAlpha(128))),
              onPressed: () async {
                await _pickImage(context, ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final XFile? photo = await ImagePicker().pickImage(source: source);
    if (photo != null && context.mounted) {
      final bytes = await Navigator.of(context).push<Uint8List>(PhotoEditPage.route(photo.path));
      if (bytes != null && context.mounted) {
        context.read<OpenSeedBloc>().add(OpenSeedInferenceImageBytesChanged(bytes));
        await Navigator.of(context).push<void>(InferencePage.route(bytes, imgName: photo.name));
      }
    }
  }
}
