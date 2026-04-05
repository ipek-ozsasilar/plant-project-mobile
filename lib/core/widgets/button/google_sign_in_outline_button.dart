import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:bitirme_mobile/gen/colors.gen.dart';
import 'package:flutter/material.dart';

/// Google ile giriş — modern çerçeveli buton.
class GoogleSignInOutlineButton extends StatelessWidget {
  const GoogleSignInOutlineButton({
    required this.onPressed,
    this.isLoading = false,
    super.key,
  });

  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: WidgetSizesEnum.buttonHeight.value,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: context.palSurfaceCard,
          foregroundColor: context.palOnSurface,
          side: BorderSide(color: context.palOutline.withValues(alpha: 0.9), width: 1.5),
          shape: const StadiumBorder(),
        ),
        child: isLoading
            ? SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: context.palPrimary,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _GoogleGMark(size: IconSizesEnum.medium.value),
                  SizedBox(width: WidgetSizesEnum.cardRadius.value * 0.75),
                  Text(
                    context.l10n.loginWithGoogle,
                    style: TextStyle(
                      fontSize: TextSizesEnum.subtitle.value,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _GoogleGMark extends StatelessWidget {
  const _GoogleGMark({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size * 0.2),
          color: Colors.white,
          border: Border.all(color: context.palOutline.withValues(alpha: 0.5)),
        ),
        child: Center(
          child: Text(
            'G',
            style: TextStyle(
              fontSize: size * 0.55,
              fontWeight: FontWeight.w800,
              color: ColorName.googleBrandBlue,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}
