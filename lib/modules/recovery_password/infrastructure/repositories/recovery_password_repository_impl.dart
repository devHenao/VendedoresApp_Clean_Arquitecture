import '../../domain/repositories/recovery_password_repository.dart';
import '../datasources/recovery_password_datasource.dart';

class RecoveryPasswordRepositoryImpl implements RecoveryPasswordRepository {
  RecoveryPasswordRepositoryImpl(this.datasource);

  final RecoveryPasswordDatasource datasource;

  @override
  Future<void> resetPassword({required String nit, required String email}) {
    return datasource.resetPassword(nit: nit, email: email);
  }
}
