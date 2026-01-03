import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/auth/auth_bloc.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/auth/auth_event.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Welcome", style: Theme.of(context).textTheme.headlineLarge,),      

            TextButton(onPressed: () {
              context.read<AuthBloc>().add(LoggedOut());
            }, child: Text("Logout"))      

            //https://chatgpt.com/s/t_69580d4f2c5481919e9267bc0475463a
          ],
        )
      ),
    );
  }
}