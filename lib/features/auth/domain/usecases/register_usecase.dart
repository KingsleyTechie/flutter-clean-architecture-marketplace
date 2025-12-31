import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;
  
  RegisterUseCase(this.repository);
  
  Future<Either<Failure, User>> call(
    String email,
    String password,
    String name,
  ) async {
    return await repository.register(email, password, name);
  }
}
