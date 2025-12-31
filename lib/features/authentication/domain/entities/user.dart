import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String email;
  final String name;

  const User({required this.email, required this.name});

  @override
  List<Object?> get props => [email, name];
}