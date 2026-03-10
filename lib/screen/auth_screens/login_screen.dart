import 'package:contracting_management_dashbord/constant/app_key.dart';
import 'package:contracting_management_dashbord/constant/app_route.dart';
import 'package:contracting_management_dashbord/controller/auth_controller/auth_controller.dart';
import 'package:contracting_management_dashbord/services/local_storge.dart';
import 'package:contracting_management_dashbord/theme/app_colors.dart';
import 'package:contracting_management_dashbord/theme/app_image.dart';
import 'package:contracting_management_dashbord/widget/app_text_filed.dart';
import 'package:contracting_management_dashbord/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.width >= 800;

    return Scaffold(
      // backgroundColor: AppColors.lightBackground, // Removed strict light background
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: isDesktop
                ? _buildDesktopLayout(context, formKey)
                : _buildMobileLayout(context, formKey),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    GlobalKey<FormBuilderState> formKey,
  ) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        width: 900,
        height: 600,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(48.0),
                child: _buildLoginForm(context, formKey),
              ),
            ),
            // Left Side - Branding/Image
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    bottomLeft: Radius.circular(24),
                  ),
                  color: Theme.of(
                    context,
                  ).colorScheme.surfaceVariant, // Dynamic surface variant
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppImage.logoImage,
                      height: 180,
                    ).animate().fade().scale(),
                    const SizedBox(height: 20),
                    Text(
                      'نظام بورسيبا',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ).animate().fadeIn(delay: 200.ms),
                    const SizedBox(height: 10),
                    Text(
                      'إدارة متكاملة بلمسة عصرية',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Right Side - Login Form
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    GlobalKey<FormBuilderState> formKey,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(AppImage.logoImage, height: 120).animate().fade().scale(),
        const SizedBox(height: 20),
        Text(
          'أهلاً بك مجدداً',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        const SizedBox(height: 40),
        _buildLoginForm(context, formKey),
      ],
    );
  }

  Widget _buildLoginForm(
    BuildContext context,
    GlobalKey<FormBuilderState> formKey,
  ) {
    final loginController = Get.find<AuthController>();

    return FormBuilder(
      key: formKey,
      child:
          Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppTextFiled(
                    name: 'username',
                    labelText: 'اسم المستخدم',
                    icon: Icons.person_outline,
                    textInputAction: TextInputAction.next,
                    validator: [
                      FormBuilderValidators.required(
                        errorText: 'هذا الحقل مطلوب',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  AppTextFiled(
                    name: 'password',
                    labelText: 'كلمة المرور',
                    icon: Icons.lock_outline,
                    isPassword: true,
                    textInputAction: TextInputAction.done,

                    validator: [
                      FormBuilderValidators.required(
                        errorText: 'هذا الحقل مطلوب',
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  const SizedBox(height: 30),
                  CustomButton(
                    text: 'تسجيل الدخول',
                    onPressed: () async {
                      if (formKey.currentState?.saveAndValidate() ?? false) {
                        await loginController.login(
                          formKey.currentState?.instantValue ?? {},
                        );
                      }
                    },
                    width: double.infinity,
                    backgroundColor: AppColors.lightPrimary,
                  ),
                ],
              )
              .animate()
              .fadeIn(duration: 600.ms, delay: 200.ms)
              .slideY(begin: 0.1, end: 0),
    );
  }

  buildLoginForm2(BuildContext context, GlobalKey<FormBuilderState> formKey2) {
    return FormBuilder(
      key: formKey2,
      child: Column(
        children: [
          AppTextFiled(
            name: 'urlApp',
            labelText: 'رابط التطبيق',
            icon: Icons.link,
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: ' save  ',
            onPressed: () async {
              if (formKey2.currentState?.saveAndValidate() ?? false) {
                await LocalStorageService.saveString(
                  AppKeys.apiUrlString,
                  formKey2.currentState?.instantValue['urlApp'] ?? '',
                );
                Get.offAllNamed(AppRoute.splash);
              }
            },
          ),
        ],
      ),
    );
  }
}
