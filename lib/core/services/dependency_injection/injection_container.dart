import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:furniture_ecommerce_app/core/services/logging/app_logger.dart';
import 'package:furniture_ecommerce_app/core/services/storage/secure_storage_service.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/signin/signin_bloc.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/signup/signup_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service Locator for Dependency Injection
final sl = GetIt.instance;

/// Initialize all dependencies
/// 
/// Call this once at app startup in main.dart:
/// ```dart
/// await initDependencies();
/// ```
Future<void> initDependencies() async {
  // ---------------------------------------------------------------------------
  // External Dependencies (Third-party packages)
  // ---------------------------------------------------------------------------
  
  // SharedPreferences - Must be initialized asynchronously
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // FlutterSecureStorage
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(
      aOptions: AndroidOptions(
        
      ),
    ),
  );

  // Logger
  sl.registerLazySingleton<Logger>(() => Logger());

  // Firebase Crashlytics
  sl.registerLazySingleton<FirebaseCrashlytics>(
    () => FirebaseCrashlytics.instance,
  );

  // ---------------------------------------------------------------------------
  // Core Services
  // ---------------------------------------------------------------------------

  // App Logger
  sl.registerLazySingleton<AppLogger>(
    () => AppLogger(
      logger: sl<Logger>(),
      crashlytics: sl<FirebaseCrashlytics>(),
    ),
  );

  // Secure Storage Service
  sl.registerLazySingleton<SecureStorageService>(
    () => SecureStorageServiceImpl(
      sl<FlutterSecureStorage>(),
      sl<SharedPreferences>(),
    ),
  );

  // Initialize SecureStorageService
  await sl<SecureStorageService>().init();

  // ---------------------------------------------------------------------------
  // Features - Authentication
  // ---------------------------------------------------------------------------

  // ✅ Blocs
  sl.registerFactory<SigninBloc>(
    () => SigninBloc(),
    // TODO: Inject use case when implemented
    // () => SigninBloc(signinUseCase: sl<SigninUseCase>()),
  );

  sl.registerFactory<SignupBloc>(
    () => SignupBloc(),
    // TODO: Inject use case when implemented
    // () => SignupBloc(signupUseCase: sl<SignupUseCase>()),
  );

  // ⏳ Use Cases (TODO: Uncomment when repository is implemented)
  // sl.registerLazySingleton<SigninUseCase>(
  //   () => SigninUseCase(sl<AuthRepository>()),
  // );
  
  // sl.registerLazySingleton<SignupUseCase>(
  //   () => SignupUseCase(sl<AuthRepository>()),
  // );
  
  // sl.registerLazySingleton<LogoutUseCase>(
  //   () => LogoutUseCase(sl<AuthRepository>()),
  // );

  // ⏳ Repository (TODO: Uncomment when data layer is implemented)
  // sl.registerLazySingleton<AuthRepository>(
  //   () => AuthRepositoryImpl(
  //     remoteDataSource: sl<AuthRemoteDataSource>(),
  //     localDataSource: sl<AuthLocalDataSource>(),
  //     networkInfo: sl<NetworkInfo>(),
  //   ),
  // );

  // ⏳ Data Sources (TODO: Implement and uncomment)
  // sl.registerLazySingleton<AuthRemoteDataSource>(
  //   () => AuthRemoteDataSourceImpl(
  //     client: sl<http.Client>(),
  //   ),
  // );
  
  // sl.registerLazySingleton<AuthLocalDataSource>(
  //   () => AuthLocalDataSourceImpl(
  //     secureStorage: sl<SecureStorageService>(),
  //   ),
  // );

  // ⏳ Network (TODO: Add if needed)
  // sl.registerLazySingleton<NetworkInfo>(
  //   () => NetworkInfoImpl(sl<InternetConnectionChecker>()),
  // );
  
  // sl.registerLazySingleton<http.Client>(() => http.Client());

  // ---------------------------------------------------------------------------
  // Features - Other Features (Add as needed)
  // ---------------------------------------------------------------------------

  // TODO: Add more features here as they're implemented
}

/// Clean up dependencies (useful for testing)
Future<void> resetDependencies() async {
  await sl.reset();
}
