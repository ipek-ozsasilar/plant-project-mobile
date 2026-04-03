import 'package:bitirme_mobile/core/enums/error_strings_enum.dart';
import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/enums/strings_enum.dart';
import 'package:bitirme_mobile/core/mixins/scaffold_message_mixin.dart';
import 'package:bitirme_mobile/core/navigation/app_paths.dart';
import 'package:bitirme_mobile/core/widgets/button/app_primary_button.dart';
import 'package:bitirme_mobile/core/widgets/button/google_sign_in_outline_button.dart';
import 'package:bitirme_mobile/core/widgets/input/app_text_field.dart';
import 'package:bitirme_mobile/features/auth/login/view_model/login_view_model.dart';
import 'package:bitirme_mobile/features/auth/provider/auth_provider.dart';
import 'package:bitirme_mobile/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Giriş arayüzü.
class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> with ScaffoldMessageMixin {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool _googleLoading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() => _loading = true);
    final LoginViewModel vm = LoginViewModel(ref: ref);
    await vm.submit(
      context: context,
      email: _email.text,
      password: _password.text,
    );
    if (mounted) {
      setState(() => _loading = false);
    }
  }

  Future<void> _onGoogleSignIn() async {
    setState(() => _googleLoading = true);
    final bool ok = await ref.read(authProvider.notifier).signInWithGoogle();
    if (!mounted) {
      return;
    }
    setState(() => _googleLoading = false);
    if (ok) {
      context.go(AppPaths.home);
    } else {
      showAppSnackBar(
        context,
        message: ErrorStringsEnum.googleSignIn.value,
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(StringsEnum.loginTitle.value)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.25),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  StringsEnum.loginSubtitle.value,
                  style: TextStyle(
                    fontSize: TextSizesEnum.subtitle.value,
                    color: ColorName.onSurfaceMuted,
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.5),
                AppTextField(
                  label: StringsEnum.emailLabel.value,
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (String? v) => (v == null || v.trim().isEmpty)
                      ? StringsEnum.validationRequired.value
                      : null,
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value),
                AppTextField(
                  label: StringsEnum.passwordLabel.value,
                  controller: _password,
                  obscureText: true,
                  validator: (String? v) => (v == null || v.isEmpty)
                      ? StringsEnum.validationRequired.value
                      : null,
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.5),
                AppPrimaryButton(
                  label: StringsEnum.loginCta.value,
                  isLoading: _loading,
                  onPressed: _onSubmit,
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.25),
                Row(
                  children: <Widget>[
                    Expanded(child: Divider(color: ColorName.outline.withValues(alpha: 0.8))),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: WidgetSizesEnum.cardRadius.value),
                      child: Text(
                        StringsEnum.authOrDivider.value,
                        style: TextStyle(
                          fontSize: TextSizesEnum.caption.value,
                          color: ColorName.onSurfaceMuted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: ColorName.outline.withValues(alpha: 0.8))),
                  ],
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.25),
                GoogleSignInOutlineButton(
                  isLoading: _googleLoading,
                  onPressed: _onGoogleSignIn,
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value),
                TextButton(
                  onPressed: () => context.push(AppPaths.register),
                  child: Text(StringsEnum.goRegister.value),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
