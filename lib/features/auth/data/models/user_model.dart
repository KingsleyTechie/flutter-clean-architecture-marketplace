import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

class UserModel extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? token;
  final String? refreshToken;
  
  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.token,
    this.refreshToken,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      token: json['token'],
      refreshToken: json['refresh_token'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'token': token,
      'refresh_token': refreshToken,
    };
  }
  
  User toEntity() {
    return User(
      id: id,
      email: email,
      name: name,
      token: token,
      refreshToken: refreshToken,
    );
  }
  
  @override
  List<Object?> get props => [id, email, name, token, refreshToken];
}
