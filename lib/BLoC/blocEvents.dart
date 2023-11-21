class LoadPageEvents{}

class AlbumPageEvent extends LoadPageEvents{
  var albumId;
  AlbumPageEvent({required this.albumId});
}
class PodcastPageEvent extends LoadPageEvents{}