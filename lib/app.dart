import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iplant_api/iplant_api.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:open_seed/explore/view/explore_page.dart';
import 'package:open_seed/l10n/g/app_localizations.dart';
import 'package:open_seed/openseed/bloc/openseed_bloc.dart';
import 'package:open_seed/openseed/models/settings_state.dart';
import 'package:open_seed/openseed/view/openseed_page.dart';
import 'package:open_seed/repository/repository.dart';
import 'package:open_seed/settings/view/settings_page.dart';

class OpenSeedApp extends StatelessWidget {
  const OpenSeedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => IPlantApiClient(), dispose: (repo) => repo.dispose()),
        RepositoryProvider(create: (_) => DatabaseRepository(), dispose: (repo) => repo.dispose()),
      ],
      child: BlocProvider(
        create:
            (context) => OpenSeedBloc(
              iplantApiClient: context.read<IPlantApiClient>(),
              db: context.read<DatabaseRepository>(),
            )..add(OpenSeedInitEvent()),
        child: BlocBuilder<OpenSeedBloc, OpenSeedState>(
          builder: (context, state) {
            return MaterialApp(
              localizationsDelegates: TR.localizationsDelegates,
              supportedLocales: TR.supportedLocales,
              locale: state.settingsState.language.locale,
              onGenerateTitle: (context) => TR.of(context).title,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.white, brightness: Brightness.light),
              ),
              darkTheme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.black, brightness: Brightness.dark),
              ),
              themeMode: state.settingsState.theme == ThemeSettings.dark ? ThemeMode.dark : ThemeMode.light,
              home: const HomePage(),
            );
          },
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const pages = [OpenSeedPage(), ExplorePage(), SettingsPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        height: 60,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateTextStyle.resolveWith((Set<WidgetState> states) {
          final ThemeData theme = Theme.of(context);
          final TextStyle style = theme.textTheme.labelMedium!;
          return style.apply(
            color:
                states.contains(WidgetState.selected)
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
          );
        }),
        onDestinationSelected: (int index) {
          context.read<OpenSeedBloc>().add(OpenSeedBottomNavChanged(index));
        },
        indicatorColor: Colors.transparent,
        selectedIndex: context.watch<OpenSeedBloc>().state.currentBottomNavIndex,
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Symbols.home, color: Theme.of(context).colorScheme.primary),
            icon: const Icon(Symbols.home),
            label: TR.of(context).home,
            tooltip: TR.of(context).home,
          ),
          NavigationDestination(
            selectedIcon: Icon(Symbols.explore, color: Theme.of(context).colorScheme.primary),
            icon: const Icon(Symbols.explore),
            label: TR.of(context).explore,
            tooltip: TR.of(context).explore,
          ),
          NavigationDestination(
            selectedIcon: Icon(Symbols.settings, color: Theme.of(context).colorScheme.primary),
            icon: const Icon(Symbols.settings),
            label: TR.of(context).settings,
            tooltip: TR.of(context).settings,
          ),
        ],
      ),
      body: pages[context.watch<OpenSeedBloc>().state.currentBottomNavIndex],
    );
  }
}
