import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_ecommerce_app/core/common/widgets/elevated_button_widget.dart';
import 'package:furniture_ecommerce_app/core/common/widgets/error_text_widget.dart';
import 'package:furniture_ecommerce_app/core/common/widgets/text_field_widget.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/auth/auth_bloc.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/auth/auth_event.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/signup/signup_bloc.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/signup/signup_event.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/signup/signup_state.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return BlocConsumer<SignupBloc, SignupState>(
              listener: (context, state) {
                if (state.status == SignupStatus.success) {
                   context.read<AuthBloc>().add(
                      LoggedIn(state.user!),
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
                            "Create an Account",
                            style: textTheme.headlineLarge,
                          ),
                          const SizedBox(height: 8),

                          // Subtitle
                          Text(
                            "Enter your details to register",
                            style: textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 32),

                          // Name field
                          Text("Name", style: textTheme.labelLarge),
                          const SizedBox(height: 8),
                          TextFieldWidget(
                            keyboardType: TextInputType.name,
                            onChanged: (value) => context
                                .read<SignupBloc>()
                                .add(NameChanged(value)),
                            errorMessage: state.formSubmitted
                                ? state.errors.name
                                : null,
                          ),
                          const SizedBox(height: 20),

                          // Email field
                          Text("Email Address", style: textTheme.labelLarge),
                          const SizedBox(height: 8),
                          TextFieldWidget(
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) => context
                                .read<SignupBloc>()
                                .add(EmailChanged(value)),
                            errorMessage: state.formSubmitted
                                ? state.errors.email
                                : null,
                          ),
                          const SizedBox(height: 20),

                          // Password field
                          Text("Password", style: textTheme.labelLarge),
                          const SizedBox(height: 8),
                          TextFieldWidget(
                            keyboardType: TextInputType.visiblePassword,
                            isPassword: true,
                            onRevealPassword: () => context
                                .read<SignupBloc>()
                                .add(RevealPassword(!state.revealPassword)),
                            revealPassword: state.revealPassword,
                            onChanged: (value) => context
                                .read<SignupBloc>()
                                .add(PasswordChanged(value)),
                            errorMessage: state.formSubmitted
                                ? state.errors.password
                                : null,
                          ),
                          const SizedBox(height: 32),

                          // Password field
                          Text("Confirm Password", style: textTheme.labelLarge),
                          const SizedBox(height: 8),
                          TextFieldWidget(
                            keyboardType: TextInputType.visiblePassword,
                            revealPassword: state.revealConfirmPassword,
                            onRevealPassword: () =>
                                context.read<SignupBloc>().add(
                                  RevealConfirmPassword(
                                    !state.revealConfirmPassword,
                                  ),
                                ),
                            isPassword: true,
                            onChanged: (value) => context
                                .read<SignupBloc>()
                                .add(ConfirmPasswordChanged(value)),
                            errorMessage: state.formSubmitted
                                ? state.errors.confirmPassword
                                : null,
                          ),
                          const SizedBox(height: 32),

                          if (state.serverError != null)
                            ErrorTextWidget(errorMessage: state.serverError!),

                          // Login button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButtonWidget(
                              buttonLabel: 'Sign Up',
                              isLoading: state.status == SignupStatus.loading,
                              onPressEvent: () {
                                context.read<SignupBloc>().add(
                                  SignupSubmitted(),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 22),
                          const Spacer(), // ✅ Now works with IntrinsicHeight
                          // Sign up link at bottom
                          Center(
                            child: GestureDetector(
                              onTap: () => context.pushNamed('signin'),
                              child: Text.rich(
                                TextSpan(
                                  style: textTheme.bodyMedium,
                                  children: [
                                    TextSpan(
                                      text: "Already have an account? ",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    TextSpan(
                                      text: "Sign In",
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
