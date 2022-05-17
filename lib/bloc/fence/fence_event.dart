part of 'fence_bloc.dart';

abstract class FenceEvent extends Equatable{
  const FenceEvent();

  @override
  List<Object> get props => [];
}

class LoadFence extends FenceEvent{
  final String user;

  LoadFence(this.user);
}

class UpdateFence extends FenceEvent {
  final List<Fence> fence;

  UpdateFence(this.fence);

  @override
  List<Object> get props => [fence];
}

class AddFence extends FenceEvent {
  final Fence fence;

  const AddFence(this.fence);

  @override
  List<Object> get props => [Fence];

  @override
  String toString() => 'Add Fence { record: $fence }';
}