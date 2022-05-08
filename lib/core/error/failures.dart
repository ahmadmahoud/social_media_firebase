import 'package:equatable/equatable.dart';
import 'package:social_firebase/core/constants.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

// General failures
class ServerFailure extends Failure {
  final String error;
  final int code;

  ServerFailure({
    required this.error,
    required this.code,
  });
}

class CacheFailure extends Failure {}

String mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return (failure as ServerFailure).error.toString();
    case CacheFailure:
      return cacheFailureMessage;
    default:
      return 'Unexpected error';
  }
}

int mapFailureToCode(Failure failure) => (failure as ServerFailure).code;
