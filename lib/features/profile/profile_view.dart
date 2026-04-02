import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/enums/strings_enum.dart';
import 'package:bitirme_mobile/core/navigation/app_paths.dart';
import 'package:bitirme_mobile/features/auth/provider/auth_provider.dart';
import 'package:bitirme_mobile/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Kullanıcı profili (yerel oturum).
class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthState auth = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: Text(StringsEnum.profileTitle.value)),
      body: Padding(
        padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            CircleAvatar(
              radius: 40,
              backgroundColor: ColorName.primary.withValues(alpha: 0.15),
              child: Icon(Icons.person, size: 40, color: ColorName.primary),
            ),
            SizedBox(height: WidgetSizesEnum.cardRadius.value),
            Text(
              auth.displayName ?? StringsEnum.placeholderDash.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: TextSizesEnum.title.value,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: WidgetSizesEnum.divider.value * 2),
            Text(
              auth.email ?? StringsEnum.placeholderDash.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: TextSizesEnum.body.value,
                color: ColorName.onSurfaceMuted,
              ),
            ),
            const Spacer(),
            FilledButton.tonal(
              onPressed: () async {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) {
                  context.go(AppPaths.login);
                }
              },
              child: Text(StringsEnum.logout.value),
            ),
          ],
        ),
      ),
    );
  }
}
