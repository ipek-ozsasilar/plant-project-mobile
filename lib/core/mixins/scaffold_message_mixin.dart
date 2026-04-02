import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/gen/colors.gen.dart';
import 'package:flutter/material.dart';

/// Snackbar göstermek için [ScaffoldMessenger] yardımcısı.
mixin ScaffoldMessageMixin {
  void showAppSnackBar(
    BuildContext context, {
    required String message,
    bool isError = false,
  }) {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(fontSize: TextSizesEnum.body.value),
        ),
        backgroundColor: isError ? ColorName.error : ColorName.primary,
      ),
    );
  }
}
