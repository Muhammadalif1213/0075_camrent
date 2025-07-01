
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paml_camrent/core/components/custom_text_field.dart';
import 'package:paml_camrent/core/components/spaces.dart';
import 'package:paml_camrent/core/constants/colors.dart';
import 'package:paml_camrent/core/core.dart';
import 'package:paml_camrent/data/models/request/auth/register_request_model.dart';
import 'package:paml_camrent/data/presentation/auth/login_screen.dart';
import 'package:paml_camrent/data/presentation/auth/register/register_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final TextEditingController namaController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final GlobalKey<FormState> _key;
  bool isShowPassword = false;

  @override
  void initState() {
    namaController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    _key = GlobalKey<FormState>();
    super.initState();
  }

  @override
  void dispose() {
    namaController.dispose();
    emailController.dispose();
    passwordController.dispose();
    _key.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SpaceHeight(100),
                Text(
                  'Daftar Akun Baru',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SpaceHeight(30),
                CustomTextField(
                  controller: namaController,
                  label: 'Username',
                  validator: 'Username tidak boleh kosong',
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.person),
                  ),
                ),
                const SpaceHeight(25),
                CustomTextField(
                  controller: emailController,
                  label: 'Email',
                  validator: 'Email tidak boleh kosong',
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.email),
                  ),
                ),
                const SpaceHeight(25),
                Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: passwordController,
                        label: 'Password',
                        obscureText: !isShowPassword,
                        validator: 'Password tidak boleh kosong',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.lock),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isShowPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              isShowPassword = !isShowPassword;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SpaceHeight(50),
                BlocConsumer<RegisterBloc, RegisterState>(
                  listener: (context, state) {
                    if (state is RegisterFailure) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.error)));
                    } else if (state is RegisterSuccess) {
                      context.pushAndRemoveUntil(
                        const LoginScreen(),
                        (route) => false,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                    } else if (state is RegisterFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.error),
                          backgroundColor: AppColors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return Button.filled(
                      onPressed:
                          state is RegisterLoading
                              ? null
                              : () {
                                if (_key.currentState!.validate()) {
                                  final request = RegisterRequestModel(
                                    username: namaController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                  context.read<RegisterBloc>().add(
                                    RegisterRequested(requestModel: request),
                                  );
                                }
                              },
                      label: state is RegisterLoading ? 'memuat...' : 'Daftar',
                    );
                  },
                ),

                const SpaceHeight(20),
                Text.rich(
                  TextSpan(
                    text: 'Sudah memiliki akun? Silahkan',
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                    ),
                    children: [
                      TextSpan(
                        text: 'Login Disini!',
                        style: TextStyle(color: AppColors.primary),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                context.pushAndRemoveUntil(
                                  const LoginScreen(),
                                  (route) => false,
                                );
                              },
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
  }
}