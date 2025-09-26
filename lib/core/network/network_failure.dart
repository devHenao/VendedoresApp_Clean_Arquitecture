import 'package:equatable/equatable.dart';

class NetworkFailure with EquatableMixin implements Exception {
  final String message;
  final int? statusCode;

  const NetworkFailure({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => 'NetworkFailure(message: $message, statusCode: $statusCode)';

  @override
  List<Object?> get props => [message, statusCode];
}
