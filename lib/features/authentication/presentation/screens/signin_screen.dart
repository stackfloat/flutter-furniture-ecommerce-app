import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_ecommerce_app/core/common/widgets/elevated_button_widget.dart';
import 'package:furniture_ecommerce_app/core/common/widgets/text_field_widget.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/auth/auth_bloc.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/auth/auth_event.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/signin/signin_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return BlocConsumer<SigninBloc, SigninState>(
              listener: (context, state) {
                if (state.status == SigninStatus.success) {
                  context.read<AuthBloc>().add(
                      LoggedIn(state.user!),
                  );
                } else if (state.status == SigninStatus.failure) {
                  // Show error message if needed
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Login failed. Please check your credentials.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 32,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 40),

                          // Title
                          Text(
                            "Let's Sign You In.",
                            style: textTheme.headlineLarge,
                          ),
                          const SizedBox(height: 8),

                          // Subtitle
                          Text(
                            "To Continue, first Verify that it's You.",
                            style: textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 32),

                          // Email field
                          Text("Email", style: textTheme.labelLarge),
                          const SizedBox(height: 8),
                          TextFieldWidget(
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) => context.read<SigninBloc>().add(EmailChanged(value)),
                            errorMessage: state.formSubmitted ? state.errors['email'] : null,
                          ),
                          const SizedBox(height: 20),

                          // Password field
                          Text("Password", style: textTheme.labelLarge),
                          const SizedBox(height: 8),
                          TextFieldWidget(
                            keyboardType: TextInputType.visiblePassword,
                            isPassword: true,
                            revealPassword: state.revealPassword,
                            onRevealPassword: () => context.read<SigninBloc>().add(RevealPassword(!state.revealPassword)),
                            onChanged: (value) => context.read<SigninBloc>().add(PasswordChanged(value)),
                            errorMessage: state.formSubmitted ? state.errors['password'] : null,
                          ),
                          const SizedBox(height: 32),

                          // Login button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButtonWidget(
                              buttonLabel: 'Sign In',
                              onPressEvent: () {
                                context.read<SigninBloc>().add(SigninSubmitted());
                              },
                            ),
                          ),

                          const SizedBox(height: 22),
                          const Spacer(), // ✅ Now works with IntrinsicHeight
                          // Sign up link at bottom
                          Center(
                            child: GestureDetector(
                              onTap: () => context.pushNamed('signup'),
                              child: Text.rich(
                                TextSpan(
                                  style: textTheme.bodyMedium,
                                  children: [
                                    TextSpan(text: "Don't have an account? ", style: TextStyle(
                                      color: Colors.black,
                                    )),
                                    TextSpan(
                                      text: "Sign Up",
                                      style: textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
