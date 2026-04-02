import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/enums/strings_enum.dart';
import 'package:bitirme_mobile/core/widgets/button/app_primary_button.dart';
import 'package:bitirme_mobile/core/widgets/input/app_text_field.dart';
import 'package:bitirme_mobile/features/auth/register/view_model/register_view_model.dart';
import 'package:bitirme_mobile/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Kayıt arayüzü.
class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  ConsumerState<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() => _loading = true);
    final RegisterViewModel vm = RegisterViewModel(ref: ref);
    await vm.submit(
      context: context,
      name: _name.text,
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
      appBar: AppBar(title: Text(StringsEnum.registerTitle.value)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.25),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  StringsEnum.registerSubtitle.value,
                  style: TextStyle(
                    fontSize: TextSizesEnum.subtitle.value,
                    color: ColorName.onSurfaceMuted,
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.5),
                AppTextField(
                  label: StringsEnum.nameLabel.value,
                  controller: _name,
                  validator: (String? v) => (v == null || v.trim().isEmpty)
                      ? StringsEnum.validationRequired.value
                      : null,
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value),
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
                  label: StringsEnum.registerCta.value,
                  isLoading: _loading,
                  onPressed: _onSubmit,
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value),
                TextButton(
                  onPressed: () => context.pop(),
                  child: Text(StringsEnum.goLogin.value),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
