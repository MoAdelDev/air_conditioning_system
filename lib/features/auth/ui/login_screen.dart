import 'package:air_conditioning_system/core/widgets/custom_button.dart';
import 'package:air_conditioning_system/core/widgets/custom_loading_indicator.dart';
import 'package:air_conditioning_system/core/widgets/custom_text_button.dart';
import 'package:air_conditioning_system/core/widgets/custom_text_field.dart';
import 'package:air_conditioning_system/features/auth/logic/cubit/auth_cubit.dart';
import 'package:air_conditioning_system/features/auth/logic/cubit/auth_state.dart';
import 'package:air_conditioning_system/features/auth/ui/register_screen.dart';
import 'package:air_conditioning_system/features/home/ui/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoginError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.error,
                style: const TextStyle(
                  fontSize: 20.0,
                ),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }

        if (state is AuthLoginSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'تم تسجيل الدخول بنجاح',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        AuthCubit cubit = context.read<AuthCubit>();
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('تسجيل الدخول'),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 50.0,
                    ),
                    Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Image.asset(
                            'assets/images/air-conditioner.png',
                            width: 200,
                            height: 200,
                          ),
                          const Positioned(
                            top: 0,
                            bottom: 0,
                            right: -30,
                            child: CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: 30,
                              child: Icon(
                                Icons.login,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: emailController,
                            hintText: 'البريد الالكتروني',
                            errorMsg: 'أدخل البريد الالكتروني',
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          CustomTextField(
                            controller: passwordController,
                            hintText: 'كلمة المرور',
                            errorMsg: 'أدخل كلمة المرور',
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.done,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: state is AuthLoginLoading
                                ? const Center(
                                    child: CustomLoadingIndicator(),
                                  )
                                : CustomButton(
                                    onPressed: () => cubit.login(
                                        email: emailController.text,
                                        password: passwordController.text),
                                    text: 'Login',
                                  ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'ليس لديك حساب؟',
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                              CustomTextButton(
                                onPressed: () => showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: double.infinity,
                                            child: CustomButton(
                                              onPressed: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const RegisterScreen(
                                                    isClient: false,
                                                  ),
                                                ),
                                              ),
                                              text: 'تسجيل الدخول كتاجر',
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 12.0,
                                          ),
                                          SizedBox(
                                            width: double.infinity,
                                            child: CustomButton(
                                              onPressed: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const RegisterScreen(
                                                    isClient: true,
                                                  ),
                                                ),
                                              ),
                                              text: 'تسجيل الدخول كعميل',
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                text: 'طلب تسجيل دخول',
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
