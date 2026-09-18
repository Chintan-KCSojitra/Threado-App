abstract class LoginState {}

class LoginInitialState extends LoginState {}

class LoadingState extends LoginState {}

class SuccessState extends LoginState {
  SuccessState();
}

class ErrorState extends LoginState {
  ErrorState({required this.message});

  final String message;
}
