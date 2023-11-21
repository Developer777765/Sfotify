

import 'package:sfotify/Pages/albumPage.dart';

class LoadPageStates{
  late var albumId;
  LoadPageStates(this.albumId);
}

class BlocInitialPage extends LoadPageStates{
  BlocInitialPage(super.albumId);
}

class BlocPodcastPageState extends LoadPageStates{
  BlocPodcastPageState(super.albumId);
}

class BlocAlbumPageState extends LoadPageStates{
  
  AlbumPage? updatedAlbumPage; 
  BlocAlbumPageState(AlbumPage? updatedAlbumPage, var albumId) : super(albumId);
}
