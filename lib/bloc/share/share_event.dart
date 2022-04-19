part of 'share_bloc.dart';

abstract class ShareEvent extends Equatable{
  const ShareEvent();

  @override
  List<Object> get props => [];
}

class LoadShare extends ShareEvent{}

class UpdateShare extends ShareEvent {
  final List<Share> share;

  UpdateShare(this.share);

  @override
  List<Object> get props => [share];
}