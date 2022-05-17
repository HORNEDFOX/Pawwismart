part of 'fence_bloc.dart';

abstract class FenceState extends Equatable{
  const FenceState();

  @override
  List<Object> get props => [];
}

class FenceLoading extends FenceState{}

class FenceLoaded extends FenceState{
  final List<Fence> fence;

  const FenceLoaded({this.fence = const <Fence>[]});

  @override
  List<Object> get props => [fence];
}