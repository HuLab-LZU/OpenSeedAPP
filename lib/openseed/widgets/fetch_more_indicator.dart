import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:open_seed/l10n/g/app_localizations.dart';

class FetchMoreIndicator extends StatelessWidget {
  final Widget child;
  final AsyncCallback onRefresh;

  const FetchMoreIndicator({required this.child, required this.onRefresh, super.key});

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      onRefresh: onRefresh,
      trigger: IndicatorTrigger.trailingEdge,
      trailingScrollIndicatorVisible: true,
      leadingScrollIndicatorVisible: true,
      durations: const RefreshIndicatorDurations(completeDuration: Duration(seconds: 1)),
      child: child,
      builder: (BuildContext context, Widget child, IndicatorController controller) {
        return AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            return Column(
              children: [
                Expanded(child: child),

                if (controller.state != IndicatorState.idle)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    alignment: Alignment.center,
                    child: switch (controller.state) {
                      IndicatorState.dragging ||
                      IndicatorState.canceling ||
                      IndicatorState.armed ||
                      IndicatorState.settling => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Symbols.keyboard_arrow_up),
                          const SizedBox(width: 8),
                          Text(TR.of(context).pullToFetchMore),
                        ],
                      ),
                      IndicatorState.loading => const CircularProgressIndicator(),
                      // IndicatorState.complete || IndicatorState.finalizing => const Text("Fetched 🚀"),
                      _ => const SizedBox.shrink(),
                    },
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
