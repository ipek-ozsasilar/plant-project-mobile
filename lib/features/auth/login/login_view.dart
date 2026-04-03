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
import 'package:bitirme_mobile/features/auth/sub_view/auth_gradient_hero.dart';
import 'package:bitirme_mobile/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Giriş arayüzü — üst marka paneli + yuvarlatılmış form alanı.
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
    final String? error = await vm.submit(
      email: _email.text,
      password: _password.text,
    );
    if (!mounted) {
      return;
    }
    setState(() => _loading = false);
    if (error != null) {
      showAppSnackBar(
        context,
        message: error,
        isError: true,
      );
    } else if (ref.read(authProvider).isAuthenticated) {
      context.go(AppPaths.home);
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
    final double topRadius = WidgetSizesEnum.cardRadius.value * 1.45;
    final double hPad = WidgetSizesEnum.cardRadius.value * 1.35;
    final TextTheme tt = Theme.of(context).textTheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: ColorName.primaryDark,
        body: Column(
          children: <Widget>[
            Expanded(
              flex: WidgetSizesEnum.authLoginHeroFlexTop.value.toInt(),
              child: const AuthGradientHero(),
            ),
            Expanded(
              flex: WidgetSizesEnum.authLoginHeroFlexBottom.value.toInt(),
              child: Transform.translate(
                offset: Offset(0, -WidgetSizesEnum.homeHeaderExtend.value * 0.45),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: ColorName.surface,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(topRadius),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.09),
                        blurRadius: WidgetSizesEnum.cardShadowBlur.value,
                        offset: Offset(0, -WidgetSizesEnum.cardShadowOffsetY.value * 0.35),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(topRadius),
                    ),
                    child: SafeArea(
                      top: false,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                          hPad,
                          WidgetSizesEnum.cardRadius.value * 1.35,
                          hPad,
                          WidgetSizesEnum.cardRadius.value * 1.5,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Text(
                                StringsEnum.loginTitle.value,
                                style: tt.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: ColorName.onSurface,
                                  letterSpacing: -0.4,
                                ),
                              ),
                              SizedBox(height: WidgetSizesEnum.divider.value * 6),
                              Text(
                                StringsEnum.loginSubtitle.value,
                                style: tt.bodyLarge?.copyWith(
                                  color: ColorName.onSurfaceMuted,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.35),
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
                              SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.45),
                              AppPrimaryButton(
                                label: StringsEnum.loginCta.value,
                                isLoading: _loading,
                                onPressed: _onSubmit,
                              ),
                              SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.25),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Divider(
                                      color: ColorName.outline.withValues(alpha: 0.85),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: WidgetSizesEnum.cardRadius.value,
                                    ),
                                    child: Text(
                                      StringsEnum.authOrDivider.value,
                                      style: TextStyle(
                                        fontSize: TextSizesEnum.caption.value,
                                        color: ColorName.onSurfaceMuted,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      color: ColorName.outline.withValues(alpha: 0.85),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.15),
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
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
