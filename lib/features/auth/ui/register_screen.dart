import 'package:air_conditioning_system/core/widgets/custom_button.dart';
import 'package:air_conditioning_system/core/widgets/custom_loading_indicator.dart';
import 'package:air_conditioning_system/core/widgets/custom_text_field.dart';
import 'package:air_conditioning_system/features/auth/logic/cubit/auth_cubit.dart';
import 'package:air_conditioning_system/features/auth/logic/cubit/auth_state.dart';
import 'package:air_conditioning_system/features/home/ui/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatefulWidget {
  final bool isClient;
  const RegisterScreen({super.key, required this.isClient});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthRegisterError) {
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
        } else if (state is AuthRegisterSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'تم تسجيل الحساب بنجاح',
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
              title: Text(
                  'طلب تسجيل الدخول ${widget.isClient ? 'كعميل' : 'كتاجر'}'),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 30.0,
                    ),
                    Center(
                      child: InkWell(
                        onTap: () => cubit.uploadImage(),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.blue,
                          backgroundImage: cubit.imageFile == null
                              ? null
                              : FileImage(cubit.imageFile!),
                          child: cubit.imageFile == null
                              ? const Icon(
                                  Icons.camera_alt,
                                  size: 50,
                                )
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    widget.isClient ? buildClientForm() : buildStoreForm(),
                    const SizedBox(
                      height: 20.0,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: state is AuthRegisterLoading
                          ? const Center(child: CustomLoadingIndicator())
                          : CustomButton(
                              text: 'طلب تسجيل الدخول',
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  if (!widget.isClient) {
                                    cubit.storeRegister(
                                      email: emailController.text,
                                      password: passwordController.text,
                                      name: nameController.text,
                                      address: addressController.text,
                                      phone: phoneController.text,
                                    );
                                  } else {
                                    cubit.userRegister(
                                      email: emailController.text,
                                      password: passwordController.text,
                                      name: nameController.text,
                                      phone: phoneController.text,
                                    );
                                  }
                                }
                              },
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

  Widget buildStoreForm() => Form(
        key: formKey,
        child: Column(
          children: [
            CustomTextField(
              controller: nameController,
              hintText: 'إسم المتجر',
              errorMsg: 'أدخل اسم المتجر',
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(
              height: 10.0,
            ),
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
              controller: phoneController,
              hintText: 'رقم الهاتف',
              errorMsg: 'أدخل رقم الهاتف',
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(
              height: 10.0,
            ),
            CustomTextField(
              controller: addressController,
              hintText: 'عنوان المتجر',
              errorMsg: 'أدخل عنوان المتجر',
              keyboardType: TextInputType.text,
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
          ],
        ),
      );

  Widget buildClientForm() => Form(
        key: formKey,
        child: Column(
          children: [
            CustomTextField(
              controller: nameController,
              hintText: 'إسمك',
              errorMsg: 'أدخل اسمك',
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(
              height: 10.0,
            ),
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
              controller: phoneController,
              hintText: 'رقم الهاتف',
              errorMsg: 'أدخل رقم الهاتف',
              keyboardType: TextInputType.phone,
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
          ],
        ),
      );
}
