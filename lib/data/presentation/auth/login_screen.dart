import 'package:paml_camrent/core/core.dart';
import 'package:paml_camrent/data/models/request/auth/login_request_model.dart';
import 'package:paml_camrent/data/presentation/auth/login/login_bloc.dart';
import 'package:paml_camrent/data/presentation/auth/register_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paml_camrent/screens/admin/admin_confirm_screen.dart';
import 'package:paml_camrent/screens/customer/customer_confirm_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final GlobalKey<FormState> _key;
  bool isShowPassword = false;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    _key = GlobalKey<FormState>();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    // No need to dispose the key's current state like this.
    // _key.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // == HEADER BIRU ==
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              decoration: const BoxDecoration(
                color: AppColors
                    .primary, // Menggunakan warna primary dari konstanta Anda
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  // Ganti 'assets/images/camera.png' dengan path aset gambar Anda
                  Image.asset(
                    'assets/images/camera.png',
                    width: 10,
                    height: 10,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Welcome to!',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // == FORM LOGIN ==
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _key,
                child: Column(
                  children: [
                    const Text(
                      'CamRENT',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SpaceHeight(20),
                    const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SpaceHeight(30),
                    CustomTextField(
                      controller: emailController,
                      label: 'Email',
                      validator: 'Email tidak boleh kosong',
                    ),
                    const SpaceHeight(20),
                    CustomTextField(
                      controller: passwordController,
                      label: 'Password',
                      obscureText: !isShowPassword,
                      validator: 'Password tidak boleh kosong',
                      suffixIcon: IconButton(
                        icon: Icon(
                          isShowPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            isShowPassword = !isShowPassword;
                          });
                        },
                      ),
                    ),
                    const SpaceHeight(40),
                    BlocConsumer<LoginBloc, LoginState>(
                      listener: (context, state) {
                        if (state is LoginFailure) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(state.error)));
                        } else if (state is LoginSuccess) {
                          final role = state.responseModel.user?.role
                              ?.toLowerCase();
                          if (role == 'admin') {
                            context.pushAndRemoveUntil(
                              const AdminConfirmScreen(),
                              (route) => false,
                            );
                          } else if (role == 'customer') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.responseModel.message!),
                              ),
                            );
                            context.pushAndRemoveUntil(
                              const CustomerConfirmScreen(),
                              (route) => false,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Role tidak dikenali'),
                              ),
                            );
                          }
                        }
                      },
                      builder: (context, state) {
                        return Button.filled(
                          onPressed: state is LoginLoading
                              ? null
                              : () {
                                  if (_key.currentState!.validate()) {
                                    final request = LoginRequestModel(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    );
                                    context.read<LoginBloc>().add(
                                      LoginRequested(requestModel: request),
                                    );
                                  }
                                },
                          label: state is LoginLoading ? 'Memuat...' : 'Login',
                        );
                      },
                    ),
                    const SpaceHeight(30),
                    Text.rich(
                      TextSpan(
                        text: 'Belum punya akun? ',
                        children: [
                          TextSpan(
                            text: 'Registrasi sekarang',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.push(const RegisterScreen());
                              },
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
