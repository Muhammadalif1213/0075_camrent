import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paml_camrent/data/presentation/auth/login/login_bloc.dart';
import 'package:paml_camrent/data/presentation/auth/login_screen.dart';
import 'package:paml_camrent/data/presentation/auth/register/register_bloc.dart';
import 'package:paml_camrent/data/presentation/product/product_bloc.dart';
import 'package:paml_camrent/repository/auth_repository.dart';
import 'package:paml_camrent/repository/product_repository.dart';
import 'package:paml_camrent/services/services_http_client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RegisterBloc(
            authRepository: AuthRepository(ServicesHttpClient()),
          ),
        ),
        BlocProvider(
          create: (context) =>
              LoginBloc(authRepository: AuthRepository(ServicesHttpClient())),
        ),
        BlocProvider(
          create: (context) => ProductBloc(
            productRepository: ProductRepository(ServicesHttpClient()),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
