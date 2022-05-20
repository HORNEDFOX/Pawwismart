part of 'user_bloc.dart';

abstract class UserEvent extends Equatable{
  const UserEvent();

  @override
  List<Object> get props => [];
}

class NoLoadUser extends UserEvent{}

class LoadUser extends UserEvent{
  final String email;

  LoadUser(this.email);
}

class UpdateUser extends UserEvent{
  final User user;

  UpdateUser(this.user);

  @override
  List<Object> get props => [user];
}