import 'package:dartz/dartz.dart';
import 'package:app_vendedores/features/auth/domain/entities/user.dart';
import 'package:app_vendedores/core/errors/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String identification, String email, String password);
  Future<Either<Failure, User>> getCurrentUser();
}
