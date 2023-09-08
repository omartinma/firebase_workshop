part of 'login_bloc.dart';

@immutable
sealed class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginRequested extends LoginEvent {
  const LoginRequested();

  @override
  List<Object> get props => [];
}
