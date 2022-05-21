part of 'share_bloc.dart';

abstract class ShareEvent extends Equatable{
  const ShareEvent();

  @override
  List<Object> get props => [];
}

class LoadShare extends ShareEvent{
  final String pet;

  LoadShare(this.pet);
}

class UpdateShare extends ShareEvent {
  final List<Share> share;

  UpdateShare(this.share);

  @override
  List<Object> get props => [share];
}

class AddShare extends ShareEvent {
  final Share share;

  const AddShare(this.share);

  @override
  List<Object> get props => [share];
}

class DeleteShareFriend extends ShareEvent {
  final String pet;

  const DeleteShareFriend(this.pet);

  @override
  List<Object> get props => [pet];
}

class DeleteShare extends ShareEvent {
  final Share share;

  const DeleteShare(this.share);

  @override
  List<Object> get props => [share];
}