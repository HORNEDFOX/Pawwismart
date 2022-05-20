import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../data/model/user.dart';
import '../../data/repositories/user_repository.dart';

part 'user_state.dart';

part 'user_event.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;
  StreamSubscription? _userSubscription;

  UserBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(UserNoLoading()) {
    on<LoadUser>(_onLoadUser);
    on<NoLoadUser>(_onNoLoadUser);
    on<UpdateUser>(_onUpdateUser);
  }

  void _onLoadUser(LoadUser event, Emitter<UserState> emit) {
      _userSubscription?.cancel();
      _userSubscription = _userRepository.getUserShare(event.email).listen(
              (user) => add(UpdateUser(user)));
  }

  void _onUpdateUser(UpdateUser event, Emitter<UserState> emit) {
    debugPrint("${event.user}");
    emit(UserLoaded(user: event.user));
  }

  void _onNoLoadUser(NoLoadUser event, Emitter<UserState> emit) {
    emit(UserNoLoading());
  }

}
