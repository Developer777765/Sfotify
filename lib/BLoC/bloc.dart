import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sfotify/BLoC/blocEvents.dart';
import 'package:sfotify/BLoC/blocStates.dart';
import 'package:sfotify/Pages/albumPage.dart';

class PageLoaderBloc extends Bloc<LoadPageEvents, LoadPageStates> {
  AlbumPage? albumPageState;
  PageLoaderBloc() : super(BlocInitialPage(0)) {
    on<AlbumPageEvent>(loadAlbumPage);
  }
  void loadAlbumPage(
      AlbumPageEvent event, Emitter<LoadPageStates> emit) async {
        albumPageState = AlbumPage(albumId:event.albumId);
        print('The even number is ${event.albumId}');
        emit(BlocAlbumPageState(albumPageState,event.albumId));
      }
}
