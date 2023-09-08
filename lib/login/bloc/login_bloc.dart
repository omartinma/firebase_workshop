import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._firebaseAuth) : super(LoginInitial()) {
    on<LoginRequested>(_requested);
  }

  final FirebaseAuth _firebaseAuth;

  Future<FutureOr<void>> _requested(
    LoginRequested event,
    Emitter<LoginState> emit,
  ) async {
    final userCredential = await _firebaseAuth.signInAnonymously();
    emit(LoginSuccess(userCredential));
  }
}
