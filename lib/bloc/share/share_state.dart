part of 'share_bloc.dart';

abstract class ShareState extends Equatable{
  const ShareState();

  @override
  List<Object> get props => [];
}

class ShareLoading extends ShareState{}

class ShareLoaded extends ShareState{
  final List<Share> share;

  const ShareLoaded({this.share = const <Share>[]});

  @override
  List<Object> get props => [share];
}