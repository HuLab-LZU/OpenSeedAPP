import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iplant_api/iplant_api.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:open_seed/l10n/g/app_localizations.dart';
import 'package:open_seed/openseed/bloc/openseed_bloc.dart';
import 'package:open_seed/openseed/view/webview_page.dart';
import 'package:open_seed/settings/view/settings_page.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  static final FocusNode _searchFocusNode = FocusNode();
  static final TextEditingController _searchController = TextEditingController();
  static Timer? _debounce;

  final ScrollController _scrollController = ScrollController();
  bool _showBackToTopButton = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    // back to top button
    if (_scrollController.offset >= 100 && !_showBackToTopButton) {
      setState(() {
        _showBackToTopButton = true;
      });
    } else if (_scrollController.offset < 100 && _showBackToTopButton) {
      setState(() {
        _showBackToTopButton = false;
      });
    }

    // load more on bottom
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent) {
      final currentState = context.read<OpenSeedBloc>().state;
      if (currentState.exploreStatus != ExploreStatus.loading) {
        context.read<OpenSeedBloc>().add(OpenSeedExploreFetchMoreItems(query: currentState.searchQuery));
      }
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  void _debounceSearch(BuildContext context, String query) {
    context.read<OpenSeedBloc>().add(OpenSeedExploreSearchChanged(query));

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<OpenSeedBloc>().add(OpenSeedExploreFetchMoreItems(query: query));
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<OpenSeedBloc>().state.exploreItems.isEmpty) {
        context.read<OpenSeedBloc>().add(OpenSeedExploreFetchMoreItems());
      }
    });

    return Scaffold(
      floatingActionButton: _showBackToTopButton
          ? FloatingActionButton(
              onPressed: _scrollToTop,
              tooltip: TR.of(context).backToTop,
              child: const Icon(Symbols.arrow_upward),
            )
          : null,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            title: Text(TR.of(context).explore),
            floating: true,
            snap: true,
            actions: [
              IconButton(
                onPressed: () {
                  _scrollToTop();
                  _searchFocusNode.requestFocus();
                },
                icon: const Icon(Symbols.search),
                tooltip: TR.of(context).search,
              ),
              IconButton(
                onPressed: () {
                  context.read<OpenSeedBloc>().add(OpenSeedExploreClearSearch());
                },
                icon: const Icon(Symbols.refresh),
                tooltip: TR.of(context).refersh,
              ),
              IconButton(
                onPressed: () => Navigator.of(context).push<void>(SettingsPage.route()),
                icon: const Icon(Symbols.settings),
                tooltip: TR.of(context).settings,
              ),
            ],
          ),
          SliverToBoxAdapter(child: _buildSearchBar(context)),
          _buildSliverContent(context),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return BlocBuilder<OpenSeedBloc, OpenSeedState>(
      buildWhen: (previous, current) => previous.searchQuery != current.searchQuery,
      builder: (context, state) {
        if (_searchController.text != state.searchQuery) {
          final selection = _searchController.selection;
          _searchController.text = state.searchQuery;
          if (selection.baseOffset > -1 && selection.baseOffset <= state.searchQuery.length) {
            _searchController.selection = selection;
          }
        }

        return Container(
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            decoration: InputDecoration(
              hintText: TR.of(context).search,
              prefixIcon: const Icon(Symbols.search),
              suffixIcon: state.searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Symbols.clear),
                      onPressed: () {
                        context.read<OpenSeedBloc>().add(OpenSeedExploreClearSearch());
                      },
                    )
                  : null,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
            ),
            onChanged: (query) {
              _debounceSearch(context, query);
            },
          ),
        );
      },
    );
  }

  Widget _buildSliverContent(BuildContext context) {
    return BlocBuilder<OpenSeedBloc, OpenSeedState>(
      builder: (context, state) {
        if (state.exploreStatus == ExploreStatus.initial) {
          return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
        }
        if (state.exploreStatus == ExploreStatus.loading && state.exploreItems.isEmpty) {
          return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
        }
        if (state.exploreStatus == ExploreStatus.error) {
          return SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(TR.of(context).loadFailed),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<OpenSeedBloc>().add(
                        OpenSeedExploreFetchMoreItems(query: state.searchQuery),
                      );
                    },
                    child: Text(TR.of(context).retry),
                  ),
                ],
              ),
            ),
          );
        }

        if (state.exploreItems.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Symbols.search_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(TR.of(context).notFound, style: Theme.of(context).textTheme.titleMedium),
                  if (state.searchQuery.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(TR.of(context).tryToUseOtherKeywords, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ],
              ),
            ),
          );
        }

        return SliverWaterfallFlow(
          gridDelegate: const SliverWaterfallFlowDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200.0,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) => _buildItem(context, state, index),
            childCount: state.exploreItems.length,
          ),
        );
      },
    );
  }

  Widget _buildItem(BuildContext context, OpenSeedState state, int index) {
    final item = state.exploreItems[index];
    final imageUrl = item.bkimg;
    final chineseName = item.bkcname ?? "";
    final latinName = item.bklatin ?? "";

    final textTheme = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () async {
          if (item.bkid != null) {
            // format detail url
            final url = await context.read<OpenSeedBloc>().formatBkItemUrl(
              bkid: item.bkid,
              latinName: latinName,
            );
            if (context.mounted) {
              await Navigator.of(
                context,
              ).push(WebViewPage.route(url: url, title: latinName.isNotEmpty ? latinName : chineseName));
            }
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1.0,
              child: imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      httpHeaders: {"Accept": "*/*", "User-Agent": getRandomUserAgent()},
                      progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(value: downloadProgress.progress),
                        ),
                      ),
                      errorWidget: (context, url, error) {
                        debugPrint(error.toString());
                        return const Center(child: Icon(Symbols.broken_image, size: 40));
                      },
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Center(child: Icon(Symbols.image_not_supported, size: 40)),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    latinName,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  Text(chineseName, style: textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
