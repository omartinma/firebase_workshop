import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_workshop/catalog/catalog.dart';
import 'package:firebase_workshop/login/bloc/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(FirebaseAuth.instance),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.of(context).pushReplacement(CatalogPage.route());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to my wine shop'),
        ),
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Image.asset(
                'assets/images/cellar.jpg',
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 60),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {
                  context.read<LoginBloc>().add(const LoginRequested());
                },
                child: const Text('Sign In'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
