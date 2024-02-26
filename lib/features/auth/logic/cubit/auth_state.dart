abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoginLoading extends AuthState {}

class AuthLoginSuccess extends AuthState {}

class AuthLoginError extends AuthState {
  final String error;
  AuthLoginError(this.error);
}

class AuthRegisterSuccess extends AuthState {}

class AuthRegisterError extends AuthState {
  final String error;
  AuthRegisterError(this.error);
}

class AuthRegisterLoading extends AuthState {}

class UploadImage extends AuthState {}
