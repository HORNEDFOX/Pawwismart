import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'nav_event.dart';
part 'nav_state.dart';

class ButtonBloc extends Bloc<ButtonEvent, ButtonState> {
  ButtonBloc(ButtonState initialState) : super(NoPressAuthButton()){

    on<LogInForm>((event, emit) async {
      emit(PressLogInButton());
    });

    on<SignUpForm>((event, emit) async {
      emit(PressSignUpButton());
    });

    on<PSmartForm>((event, emit) async {
      emit(NoPressAuthButton());
    });
  }
}