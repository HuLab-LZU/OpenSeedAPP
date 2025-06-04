import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class CheckMarkColors {
  final Color content;
  final Color background;

  const CheckMarkColors({required this.content, required this.background});
}

class CheckMarkStyle {
  final CheckMarkColors loading;
  final CheckMarkColors success;
  final CheckMarkColors error;

  const CheckMarkStyle({required this.loading, required this.success, required this.error});

  static const defaultStyle = CheckMarkStyle(
    loading: CheckMarkColors(content: Colors.white, background: Colors.blueAccent),
    success: CheckMarkColors(content: Colors.black, background: Colors.greenAccent),
    error: CheckMarkColors(content: Colors.black, background: Colors.redAccent),
  );

  factory CheckMarkStyle.fromTheme(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CheckMarkStyle(
      loading: CheckMarkColors(content: colorScheme.onPrimary, background: colorScheme.primary),
      success: CheckMarkColors(content: colorScheme.onTertiary, background: colorScheme.tertiary),
      error: CheckMarkColors(content: colorScheme.onError, background: colorScheme.error),
    );
  }
}

class CheckMarkIndicator extends StatefulWidget {
  final Widget child;
  final CheckMarkStyle? style;
  final AsyncCallback onRefresh;
  final IndicatorController? controller;
  final IndicatorTrigger trigger;

  const CheckMarkIndicator({
    required this.child,
    required this.onRefresh,
    super.key,
    this.controller,
    this.trigger = IndicatorTrigger.leadingEdge,
    this.style,
  });

  @override
  State<CheckMarkIndicator> createState() => _CheckMarkIndicatorState();
}

class _CheckMarkIndicatorState extends State<CheckMarkIndicator> with SingleTickerProviderStateMixin {
  /// Whether to render check mark instead of spinner
  bool _renderCompleteState = false;

  ScrollDirection prevScrollDirection = ScrollDirection.idle;

  bool _hasError = false;

  Future<void> _handleRefresh() async {
    try {
      setState(() {
        _hasError = false;
      });
      await widget.onRefresh();
    } catch (_) {
      setState(() {
        _hasError = true;
      });
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = widget.style ?? CheckMarkStyle.fromTheme(context);

    return CustomMaterialIndicator(
      controller: widget.controller,
      onRefresh: _handleRefresh,
      trigger: widget.trigger,
      durations: const RefreshIndicatorDurations(completeDuration: Duration(seconds: 2)),
      onStateChanged: (change) {
        /// set [_renderCompleteState] to true when controller.state become completed
        if (change.didChange(to: IndicatorState.complete)) {
          _renderCompleteState = true;

          /// set [_renderCompleteState] to false when controller.state become idle
        } else if (change.didChange(to: IndicatorState.idle)) {
          _renderCompleteState = false;
        }
      },
      indicatorBuilder: (BuildContext context, IndicatorController controller) {
        final CheckMarkColors style;
        if (_renderCompleteState) {
          if (_hasError) {
            style = effectiveStyle.error;
          } else {
            style = effectiveStyle.success;
          }
        } else {
          style = effectiveStyle.loading;
        }

        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          alignment: Alignment.center,
          decoration: BoxDecoration(color: style.background, shape: BoxShape.circle),
          child:
              _renderCompleteState
                  ? Icon(_hasError ? Symbols.close : Symbols.check, color: style.content)
                  : SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: style.content,
                      value:
                          controller.isDragging || controller.isArmed
                              ? controller.value.clamp(0.0, 1.0)
                              : null,
                    ),
                  ),
        );
      },
      child: widget.child,
    );
  }
}
