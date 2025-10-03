abstract class RecoveryPasswordRepository {
  Future<void> resetPassword({required String nit, required String email});
}
