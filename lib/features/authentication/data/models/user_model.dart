import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String name;
  final String email;
  final String token;

  const UserModel({
    required this.name,
    required this.email,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'token': token};
  }

  @override
  List<Object?> get props => [name, email, token];
}
