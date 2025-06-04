import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:open_seed/l10n/g/app_localizations.dart';
import 'package:open_seed/openseed/bloc/openseed_bloc.dart';
import 'package:open_seed/openseed/view/webview_page.dart';
// import 'package:open_seed/openseed/view/species_details_page.dart';

class InferencePage extends StatelessWidget {
  const InferencePage({required this.inferenceImageBytes, this.imgName, super.key});

  static Route<Uint8List> route(Uint8List imageBytes, {String? imgName}) {
    return MaterialPageRoute<Uint8List>(
      builder: (_) => InferencePage(inferenceImageBytes: imageBytes, imgName: imgName),
    );
  }

  final Uint8List inferenceImageBytes;
  final String? imgName;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OpenSeedBloc, OpenSeedState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(TR.of(context).inference),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, OpenSeedState state) {
    switch (state.status) {
      case OpenSeedInferenceStatus.inferencing:
        return const Center(child: CircularProgressIndicator());
      case OpenSeedInferenceStatus.failure:
        return Center(child: Text(TR.of(context).inferenceFailed));
      case OpenSeedInferenceStatus.initial:
      case OpenSeedInferenceStatus.success:
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageSection(context, state),
          const SizedBox(height: 24),

          _buildModelInfoSection(context, state),
          const SizedBox(height: 24),

          _buildResultsSection(context, state),
        ],
      ),
    );
  }

  Widget _buildImageSection(BuildContext context, OpenSeedState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          TR.of(context).inferenceImage,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 12),
        Center(
          child: Container(
            constraints: const BoxConstraints(maxHeight: 300),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.memory(inferenceImageBytes, fit: BoxFit.contain),
            ),
          ),
        ),
        if (imgName != null)
          Center(
            child: Text(
              imgName!,
              style: Theme.of(context).textTheme.bodyLarge,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }

  Widget _buildModelInfoSection(BuildContext context, OpenSeedState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(TR.of(context).modelInfo, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(TR.of(context).model, state.modelName),
                const Divider(),
                _buildInfoRow(TR.of(context).backend, state.backendName),
                const Divider(),
                _buildInfoRow(TR.of(context).memory, state.memoryInfo),
                const Divider(),
                _buildInfoRow(TR.of(context).flops, state.flopsInfo),
                const Divider(),
                _buildInfoRow(TR.of(context).time, state.inferTime),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildResultsSection(BuildContext context, OpenSeedState state) {
    if (state.results == null || state.results!.isEmpty) {
      return const SizedBox.shrink();
    }

    final results = state.results!.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(TR.of(context).results, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: results.length,
          itemBuilder: (context, index) {
            final result = results[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8.0),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  child: Text('${index + 1}'),
                ),
                title: Text(result.label, style: const TextStyle(fontStyle: FontStyle.italic)),
                subtitle: Text(
                  '${TR.of(context).confidence}: ${(result.probability * 100).toStringAsFixed(2)} %',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Symbols.info),
                      tooltip: TR.of(context).details,
                      onPressed: () {
                        context.read<OpenSeedBloc>().add(
                          OpenSeedSpDetailLaunched(oseedId: result.labelId, latinName: result.label),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Symbols.copy_all),
                      tooltip: TR.of(context).copySpNameToClipboard,
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: result.label));
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(TR.of(context).copiedSpNameToClipboard),
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                onTap: () async {
                  // launch external detail page
                  // context.read<OpenSeedBloc>().add(
                  //   OpenSeedSpDetailLaunched(oseedId: result.labelId, latinName: result.label),
                  // );

                  // built-in detail page
                  // if (context.mounted) {
                  //   await Navigator.of(context).push<void>(SpeciesDetailsPage.route(result.labelId));
                  // }

                  // format detail url
                  final url = await context.read<OpenSeedBloc>().formatBkItemUrl(
                    oseedId: result.labelId,
                    latinName: result.label,
                  );
                  if (context.mounted) {
                    await Navigator.of(context).push<void>(WebViewPage.route(url: url, title: result.label));
                  }
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
