import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_ecommerce_app/core/services/dependency_injection/injection_container.dart';
import 'package:furniture_ecommerce_app/core/services/storage/secure_storage_service.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/signin/signin_bloc.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/signup/signup_bloc.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/screens/signin_screen.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/screens/signup_screen.dart';
import 'package:furniture_ecommerce_app/features/home/presentation/screens/home_screen.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/signin',
  redirect: (context, state) async {
    final secureStorage = sl<SecureStorageService>();
    final isAuthenticated = await secureStorage.isAuthenticated();
    
    final isGoingToSignin = state.matchedLocation == '/signin';
    final isGoingToSignup = state.matchedLocation == '/signup';
    final isGoingToHome = state.matchedLocation == '/';
    
    // If user is authenticated and trying to access signin/signup, redirect to home
    if (isAuthenticated && (isGoingToSignin || isGoingToSignup)) {
      return '/';
    }
    
    // If user is not authenticated and trying to access home, redirect to signin
    if (!isAuthenticated && isGoingToHome) {
      return '/signin';
    }
    
    // No redirect needed
    return null;
  },
  routes: [
    GoRoute(
      path: '/signin',
      name: 'signin',
      builder: (context, state) => BlocProvider(
        create: (context) => sl<SigninBloc>(),
        child: const LoginScreen(),
      ),
    ),
    GoRoute(
      path: '/signup',
      name: 'signup',
      builder: (context, state) => BlocProvider(
        create: (context) => sl<SignupBloc>(),
        child: const SignupScreen(),
      ),
    ),
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
