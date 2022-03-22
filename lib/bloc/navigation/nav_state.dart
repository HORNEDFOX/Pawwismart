part of 'nav_bloc.dart';

@immutable
abstract class ButtonState extends Equatable {}

class PressSignUpButton extends ButtonState {

  @override
  List<Object?> get props => [1];
}

class PressLogInButton extends ButtonState {

  @override
  List<Object?> get props => [2];
}

class NoPressAuthButton extends ButtonState {

  @override
  List<Object?> get props => [3];
}