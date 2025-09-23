import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:app_vendedores/core/errors/failures.dart';
import 'package:app_vendedores/features/auth/domain/entities/user.dart';
import 'package:app_vendedores/features/auth/domain/repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  Future<Either<Failure, User>> call(Params params) async {
    return await repository.login(params.identification, params.email, params.password);
  }
}

class Params extends Equatable {
  final String identification;
  final String email;
  final String password;

  const Params({required this.identification, required this.email, required this.password});

  @override
  List<Object> get props => [identification, email, password];
}
