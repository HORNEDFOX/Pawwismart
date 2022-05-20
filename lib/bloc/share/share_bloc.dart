import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/model/share.dart';
import '../../data/repositories/share_repository.dart';

part 'share_state.dart';
part 'share_event.dart';

class ShareBloc extends Bloc<ShareEvent, ShareState> {
  final ShareRepository _shareRepository;
  StreamSubscription? _shareSubscription;

  ShareBloc({required ShareRepository shareRepository})
      : _shareRepository = shareRepository,
        super(ShareLoading()) {
    on<LoadShare>(_onLoadShare);
    on<UpdateShare>(_onUpdateShare);
    on<AddShare>(_onAddShare);
    on<DeleteShareFriend>(_onDeleteShareFriend);
  }

  void _onLoadShare(LoadShare event, Emitter<ShareState> emit) {
    _shareSubscription?.cancel();
    _shareSubscription = _shareRepository.getAllSharePet(event.pet).listen(
          (share) => add(UpdateShare(share),
      ),
    );
  }

  void _onUpdateShare(UpdateShare event, Emitter<ShareState> emit) {
    emit(ShareLoaded(share: event.share));
  }

  void _onAddShare(AddShare event, Emitter<ShareState> emit)  {
    _shareRepository.createShare(event.share);
  }

  void _onDeleteShareFriend(DeleteShareFriend event, Emitter<ShareState> emit)  {
    _shareRepository.deleteShareFriend(event.pet);
  }
}