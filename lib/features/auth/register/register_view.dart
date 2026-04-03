import 'package:bitirme_mobile/core/enums/error_strings_enum.dart';
import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/enums/strings_enum.dart';
import 'package:bitirme_mobile/core/mixins/scaffold_message_mixin.dart';
import 'package:bitirme_mobile/core/navigation/app_paths.dart';
import 'package:bitirme_mobile/core/widgets/button/app_primary_button.dart';
import 'package:bitirme_mobile/core/widgets/button/google_sign_in_outline_button.dart';
import 'package:bitirme_mobile/core/widgets/input/app_text_field.dart';
import 'package:bitirme_mobile/features/auth/provider/auth_provider.dart';
import 'package:bitirme_mobile/features/auth/register/view_model/register_view_model.dart';
import 'package:bitirme_mobile/features/auth/sub_view/auth_gradient_hero.dart';
import 'package:bitirme_mobile/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Kayıt arayüzü — giriş ile aynı modern iskelet.
class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  ConsumerState<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> with ScaffoldMessageMixin {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool _googleLoading = false;

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
    final String? error = await vm.submit(
      name: _name.text,
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
              flex: WidgetSizesEnum.authRegisterHeroFlexTop.value.toInt(),
              child: const AuthGradientHero(),
            ),
            Expanded(
              flex: WidgetSizesEnum.authRegisterHeroFlexBottom.value.toInt(),
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
                          WidgetSizesEnum.cardRadius.value * 1.1,
                          hPad,
                          WidgetSizesEnum.cardRadius.value * 1.5,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  IconButton(
                                    onPressed: () => context.pop(),
                                    style: IconButton.styleFrom(
                                      backgroundColor:
                                          ColorName.primaryLight.withValues(alpha: 0.55),
                                      foregroundColor: ColorName.primaryDark,
                                    ),
                                    icon: Icon(
                                      Icons.arrow_back_rounded,
                                      size: IconSizesEnum.large.value,
                                    ),
                                  ),
                                  SizedBox(width: WidgetSizesEnum.cardRadius.value * 0.65),
                                  Expanded(
                                    child: Text(
                                      StringsEnum.registerTitle.value,
                                      style: tt.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.w800,
                                        color: ColorName.onSurface,
                                        letterSpacing: -0.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.85),
                              Text(
                                StringsEnum.registerSubtitle.value,
                                style: tt.bodyLarge?.copyWith(
                                  color: ColorName.onSurfaceMuted,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.2),
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
                              SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.35),
                              AppPrimaryButton(
                                label: StringsEnum.registerCta.value,
                                isLoading: _loading,
                                onPressed: _onSubmit,
                              ),
                              SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.15),
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
                              SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.1),
                              GoogleSignInOutlineButton(
                                isLoading: _googleLoading,
                                onPressed: _onGoogleSignIn,
                              ),
                              SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.65),
                              TextButton(
                                onPressed: () => context.pop(),
                                child: Text(StringsEnum.goLogin.value),
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
