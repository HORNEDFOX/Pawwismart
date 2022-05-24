part of 'fence_bloc.dart';

abstract class FenceEvent extends Equatable{
  const FenceEvent();

  @override
  List<Object> get props => [];
}

class LoadFence extends FenceEvent{
  final String user;
  final String pet;

  LoadFence(this.user, this.pet);
}

class LoadFences extends FenceEvent{
  final String user;

  LoadFences(this.user);
}

class UpdateFence extends FenceEvent {
  final List<Fence> fence;

  UpdateFence(this.fence);

  @override
  List<Object> get props => [fence];
}

class AddFence extends FenceEvent {
  final Fence fence;
  final List<dynamic> pet;

  const AddFence(this.fence, this.pet);

  @override
  List<Object> get props => [fence, pet];

  @override
  String toString() => 'Add Fence { record: $fence }';
}

class AddPetsFence extends FenceEvent {
  final Fence fence;
  final List<dynamic> pet;

  const AddPetsFence(this.fence, this.pet);

  @override
  List<Object> get props => [fence, pet];
}

class DeletePetsFence extends FenceEvent {
  final Fence fence;
  final List<dynamic> pet;

  const DeletePetsFence(this.fence, this.pet);

  @override
  List<Object> get props => [fence, pet];
}

class DeleteFence extends FenceEvent{
  final Fence fence;

  DeleteFence(this.fence);

  @override
  List<Object> get props => [fence];
}

class DeleteFenceWithDeletePet extends FenceEvent{
  final String pet;

  DeleteFenceWithDeletePet(this.pet);

  @override
  List<Object> get props => [pet];
}

class DeleteFenceNull extends FenceEvent{
}

class EditFence extends FenceEvent{
  final Fence fence;
  final String id;

  EditFence(this.fence, this.id);

  @override
  List<Object> get props => [fence, id];
}