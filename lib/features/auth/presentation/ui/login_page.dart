import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../presentation/pages/home_page.dart';
import '../bloc/auth_bloc.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Samir Academy')),
      body: Center(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) =>  HomePage()),
              );
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  duration: const Duration(seconds: 4),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.red.shade700,
                  action: SnackBarAction(
                    label: 'Dismiss',
                    textColor: Colors.white,
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const CircularProgressIndicator();
            }
            return ElevatedButton.icon(
              onPressed: () {
                context.read<AuthBloc>().add(SignInWithGoogleEvent());
              },
              icon: const Icon(Icons.login),
              label: const Text('Sign In with Google'),
            );
          },
        ),
      ),
    );
  }
}