import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:flutter/material.dart';

/// Birincil dolgu butonu — hap şekil, hafif gölge.
class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    return SizedBox(
      width: double.infinity,
      height: WidgetSizesEnum.buttonHeight.value,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(WidgetSizesEnum.buttonHeight.value / 2),
          boxShadow: onPressed == null || isLoading
              ? null
              : <BoxShadow>[
                  BoxShadow(
                    color: cs.primary.withValues(alpha: 0.35),
                    blurRadius: WidgetSizesEnum.fabBlurRadius.value,
                    offset: Offset(0, WidgetSizesEnum.fabYOffset.value),
                  ),
                ],
        ),
        child: FilledButton(
          onPressed: isLoading ? null : onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: cs.primary,
            foregroundColor: cs.onPrimary,
            disabledBackgroundColor: cs.primary.withValues(alpha: 0.45),
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: const StadiumBorder(),
            textStyle: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
          child: isLoading
              ? SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: cs.onPrimary.withValues(alpha: 0.95),
                  ),
                )
              : Text(label),
        ),
      ),
    );
  }
}
