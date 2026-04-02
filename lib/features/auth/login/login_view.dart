import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/enums/strings_enum.dart';
import 'package:bitirme_mobile/core/navigation/app_paths.dart';
import 'package:bitirme_mobile/core/widgets/button/app_primary_button.dart';
import 'package:bitirme_mobile/core/widgets/input/app_text_field.dart';
import 'package:bitirme_mobile/features/auth/login/view_model/login_view_model.dart';
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

class _LoginViewState extends ConsumerState<LoginView> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loading = false;

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
