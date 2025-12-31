import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? token;
  final String? refreshToken;
  
  const User({
    required this.id,
    required this.email,
    required this.name,
    this.token,
    this.refreshToken,
  });
  
  @override
  List<Object?> get props => [id, email, name, token, refreshToken];
  
  User copyWith({
    String? id,
    String? email,
    String? name,
    String? token,
    String? refreshToken,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}
