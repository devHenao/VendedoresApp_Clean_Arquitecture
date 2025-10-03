import '../repositories/recovery_password_repository.dart';

class ResetPassword {
  ResetPassword(this.repository);

  final RecoveryPasswordRepository repository;

  Future<void> call({required String nit, required String email}) async {
    return repository.resetPassword(nit: nit, email: email);
  }
}
