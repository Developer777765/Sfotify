import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:sfotify/dataBase/dataBase.dart';

class SpotifyApiServices {
  //THE FOLLOWING CODE FETCHES ACCESS TOKEN FROM SPOTIFY
  requestRefreshToken(
      String refreshToken, String clientId, base64Credential) async {
    final clientSecretId = "c87f06a7d2eb4569bb91c697e2837bb0";
    var base64Cred = utf8.fuse(base64).encode('$clientId:$clientSecretId');
    print('we are inside the function and the refresh token is $refreshToken');
    String requestTokenEndPoint = 'https://accounts.spotify.com/api/token';

    var response = await http.post(Uri.parse(requestTokenEndPoint), body: {
      'grant_type': 'refresh_token',
      'refresh_token': refreshToken,
    }, headers: {
      'content-type': 'application/x-www-form-urlencoded',
      'Authorization': 'Basic $base64Credential'
    });

    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);
      if (responseBody['access_token'] == null) {
        print('Failed to get refresh token');
      } else {
        HandlingLoggedInLoggedOut handling = HandlingLoggedInLoggedOut();
        await handling.updatingToken(responseBody['access_token']);
        Future.delayed(Duration(minutes: 50), () async {
          await requestRefreshToken(refreshToken, clientId, base64Cred);
        });
        print('the refresh token is ${responseBody}');
      }
    } else {
      print('something went wrong ${response.statusCode}');
    }
  }

//THE FOLLOWING CODE FETCHES USER PROFILE FROM SPOTIFY
  getUserProfile() async {
    HandlingLoggedInLoggedOut handling = HandlingLoggedInLoggedOut();
    var queryingFromDataBase = await handling.queryingFromDatabase();
    var accessToken = queryingFromDataBase[0]['token'];
    var response = await http.get(Uri.parse('https://api.spotify.com/v1/me'),
        headers: {'Authorization': 'Bearer $accessToken'});
    if (response.statusCode == 200) {
      var userProfile = json.decode(response.body);
      Map<String, dynamic> userData = {
        'userName': userProfile['display_name'],
        'profilePicture': userProfile['images'][0]['url']
      };
      return userData;
    }
    return null;
  }

  /*

  //THE FOLLOWING CODE FETCHES RECENTLY PLAYED FROM SPOTIFY

  getRecentlyPlayed({accessTkn}) async {
    try {
      HandlingLoggedInLoggedOut handling = HandlingLoggedInLoggedOut();
      var queryingTokenFromDB = await handling.queryingFromDatabase();
      var accessToken = queryingTokenFromDB[0]['token'];

      var response = await http.get(
          Uri.parse('https://api.spotify.com/v1/me/player/recently-played'),
          headers: {'Authorization': 'Bearer $accessToken'});

      if (response.statusCode == 200) {
        var recentlyPlayed = json.decode(response.body);
        var recentlyPlayedTracks = recentlyPlayed;  
        Map<String, dynamic> userTracks = {
          'items': recentlyPlayedTracks['items'] 
        };
        return userTracks;
      } else {
        //throw Exception('We failed to retrieve recommended tracks');
        print('well, something went wrong ${response.statusCode}');
      }
    } catch (exception) {
      print('The exception is $exception');
    }
  }



//THE FOLLOWING CODE FETCHES NEW ALBUMS RELEASED ON SPOTIFY
  getNewReleases({accessTkn}) async {
    try {
      HandlingLoggedInLoggedOut handling = HandlingLoggedInLoggedOut();
      var queryingTokenFromDB = await handling.queryingFromDatabase();
      var accessToken = queryingTokenFromDB[0]['token'];

      var response = await http.get(
          Uri.parse('https://api.spotify.com/v1/browse/new-releases'),
          headers: {'Authorization': 'Bearer $accessToken'});

      if (response.statusCode == 200) {
        var newReleases = json.decode(response.body);
        var newlyReleasedAlbums = newReleases;
        //Map<String, dynamic> newAlbums = {'items': newlyReleasedAlbums['albums']['items']};
        Map<String, dynamic> newAlbums = {
          'albums': newlyReleasedAlbums['albums']
        };
        print('New albums from Spotify are $newAlbums');
        return newAlbums;
      } else {
        print('something went wrong ${response.statusCode}');
      }
    } catch (exception) {
      print('The exception is $exception');
    }
  }

//THE FOLLOWING CODE FETCHES A PARTICULAR ALBUM BASED ON THE ID PROVIDED
  getAnAlbum(String albumId) async {
    try {
      HandlingLoggedInLoggedOut handling = HandlingLoggedInLoggedOut();
      var queryingTokenFromDB = await handling.queryingFromDatabase();
      var accessToken = queryingTokenFromDB[0]['token'];

      var response = await http.get(
          Uri.parse('https://api.spotify.com/v1/albums/$albumId'),
          headers: {'Authorization': 'Bearer $accessToken'});

      if (response.statusCode == 200) {
        Map<String, dynamic> fetchedAlbum = await json.decode(response.body);
        var album = {'album': fetchedAlbum};
        return album;
      } else {
        print(
            'something went wrong fetching albums details ${response.statusCode}');
      }
    } catch (exception) {
      print('The exception is $exception');
    }
  }

  //THE FOLLOWING CODE FETCHES A PARTICULAR ARTIST BASED ON THE ID PROVIDED

  getArtist(artistId) async {
    try {
      HandlingLoggedInLoggedOut handling = HandlingLoggedInLoggedOut();
      var queryingTokenFromDB = await handling.queryingFromDatabase();
      var accessToken = queryingTokenFromDB[0]['token'];

      var response = await http.get(
          Uri.parse('https://api.spotify.com/v1/artists/$artistId'),
          headers: {'Authorization': 'Bearer $accessToken'});

      if (response.statusCode == 200) {
        Map<String, dynamic> fetchedAlbum = await json.decode(response.body);
        var artist = {'artist': fetchedAlbum};
        return artist;
      } else {
        print(
            'something went wrong fetching albums details ${response.statusCode}');
      }
    } catch (exception) {
      print('The exception is $exception');
    }
  }

//FOLLOWING CODE FETCHES ALBUMS OF A PARTICULAR ARTIST
  getArtistsAlbums(artistId) async {
    try {
      HandlingLoggedInLoggedOut handling = HandlingLoggedInLoggedOut();
      var queryingTokenFromDB = await handling.queryingFromDatabase();
      var accessToken = queryingTokenFromDB[0]['token'];

      var response = await http.get(
          Uri.parse('https://api.spotify.com/v1/artists/$artistId/albums'),
          headers: {'Authorization': 'Bearer $accessToken'});

      if (response.statusCode == 200) {
        Map<String, dynamic> fetchedAlbum = await json.decode(response.body);
        var artistsAlbums = {'artistsAlbums': fetchedAlbum};
        return artistsAlbums;
      } else {
        print(
            'something went wrong fetching albums details ${response.statusCode}');
      }
    } catch (exception) {
      print('The exception is $exception');
    }
  }

//FOLLOWING CODE FETCHES SEVERAL PODCAST SHOW
  getSeveralShows({accessTkn}) async {
    try {
      HandlingLoggedInLoggedOut handling = HandlingLoggedInLoggedOut();
      var queryingTokenFromDB = await handling.queryingFromDatabase();
      var accessToken = queryingTokenFromDB[0]['token'];

      var response = await http.get(
          Uri.parse('https://api.spotify.com/v1/shows'),
          headers: {'Authorization': 'Bearer $accessToken'});

      if (response.statusCode == 200) {
        Map<String, dynamic> fetchedShow = await json.decode(response.body);
        var shows = {'shows': fetchedShow};
        print('the fetched shows are ${shows}');
        return shows;
      } else {
        print(
            'something went wrong fetching albums details ${response.statusCode}');
      }
    } catch (exception) {
      print('The exception is $exception');
    }
  }

  //FOLLOWING CODE FETCHES SEVERAL TRACKS

  getSeveralTracks({accessTkn}) async {
    try {
      HandlingLoggedInLoggedOut handling = HandlingLoggedInLoggedOut();
      var queryingTokenFromDB = await handling.queryingFromDatabase();
      var accessToken = queryingTokenFromDB[0]['token'];

      var response = await http.get(
          Uri.parse('https://api.spotify.com/v1/shows'),
          headers: {'Authorization': 'Bearer $accessToken'});

      if (response.statusCode == 200) {
        Map<String, dynamic> fetchedTracks = await json.decode(response.body);
        var tracks = {'fetchedTracks': fetchedTracks};
        print('the fetched tracks are ${tracks}');
        return tracks;
      } else {
        print(
            'something went wrong fetching albums details ${response.statusCode}');
        return null;
      }
    } catch (exception) {
      print('The exception is $exception');
    }
  }



    */

  getRecentlyPlayed({accessTkn}) async {
    try {
      var response = await http.get(
          Uri.parse('https://api.spotify.com/v1/me/player/recently-played'),
          headers: {'Authorization': 'Bearer $accessTkn'});

      if (response.statusCode == 200) {
        var recentlyPlayed = json.decode(response.body);
        var recentlyPlayedTracks = recentlyPlayed;
        Map<String, dynamic> userTracks = {
          'items': recentlyPlayedTracks['items']
        };
        return userTracks;
      } else {
        //throw Exception('We failed to retrieve recommended tracks');
        print('well, something went wrong ${response.statusCode}');
      }
    } catch (exception) {
      print('The exception is $exception');
    }
  }

//THE FOLLOWING CODE FETCHES NEW ALBUMS RELEASED ON SPOTIFY
  getNewReleases({accessTkn}) async {
    try {
      var response = await http.get(
          Uri.parse('https://api.spotify.com/v1/browse/new-releases'),
          headers: {'Authorization': 'Bearer $accessTkn'});

      if (response.statusCode == 200) {
        var newReleases = json.decode(response.body);
        var newlyReleasedAlbums = newReleases;
        Map<String, dynamic> newAlbums = {
          'albums': newlyReleasedAlbums['albums']
        };
        print('New albums from Spotify are $newAlbums');
        return newAlbums;
      } else {
        print('something went wrong ${response.statusCode}');
      }
    } catch (exception) {
      print('The exception is $exception');
    }
  }

//THE FOLLOWING CODE FETCHES A PARTICULAR ALBUM BASED ON THE ID PROVIDED
  getAnAlbum(String albumId) async {
    try {
      HandlingLoggedInLoggedOut handling = HandlingLoggedInLoggedOut();
      var queryingTokenFromDB = await handling.queryingFromDatabase();
      var accessToken = queryingTokenFromDB[0]['token'];

      var response = await http.get(
          Uri.parse('https://api.spotify.com/v1/albums/$albumId'),
          headers: {'Authorization': 'Bearer $accessToken'});

      if (response.statusCode == 200) {
        Map<String, dynamic> fetchedAlbum = await json.decode(response.body);
        var album = {'album': fetchedAlbum};
        return album;
      } else {
        print(
            'something went wrong fetching albums details ${response.statusCode}');
      }
    } catch (exception) {
      print('The exception is $exception');
    }
  }

  //THE FOLLOWING CODE FETCHES A PARTICULAR ARTIST BASED ON THE ID PROVIDED

  getArtist(artistId) async {
    try {
      HandlingLoggedInLoggedOut handling = HandlingLoggedInLoggedOut();
      var queryingTokenFromDB = await handling.queryingFromDatabase();
      var accessToken = queryingTokenFromDB[0]['token'];

      var response = await http.get(
          Uri.parse('https://api.spotify.com/v1/artists/$artistId'),
          headers: {'Authorization': 'Bearer $accessToken'});

      if (response.statusCode == 200) {
        Map<String, dynamic> fetchedAlbum = await json.decode(response.body);
        var artist = {'artist': fetchedAlbum};
        return artist;
      } else {
        print(
            'something went wrong fetching artist details ${response.statusCode}');
      }
    } catch (exception) {
      print('The exception is $exception');
    }
  }

//FOLLOWING CODE FETCHES ALBUMS OF A PARTICULAR ARTIST
  getArtistsAlbums(artistId) async {
    try {
      HandlingLoggedInLoggedOut handling = HandlingLoggedInLoggedOut();
      var queryingTokenFromDB = await handling.queryingFromDatabase();
      var accessToken = queryingTokenFromDB[0]['token'];

      var response = await http.get(
          Uri.parse('https://api.spotify.com/v1/artists/$artistId/albums'),
          headers: {'Authorization': 'Bearer $accessToken'});

      if (response.statusCode == 200) {
        Map<String, dynamic> fetchedAlbum = await json.decode(response.body);
        var artistsAlbums = {'artistsAlbums': fetchedAlbum};
        return artistsAlbums;
      } else {
        print(
            'something went wrong fetching artist albums details ${response.statusCode}');
      }
    } catch (exception) {
      print('The exception is $exception');
    }
  }

  getArtistsTopTracks(artistId) async {
    try {
      HandlingLoggedInLoggedOut handling = HandlingLoggedInLoggedOut();
      var queryingTokenFromDB = await handling.queryingFromDatabase();
      var accessToken = queryingTokenFromDB[0]['token'];
      print('access token isn $accessToken');
      print('artist id is $artistId');

      var response = await http.get(
          //https://api.spotify.com/v1/artists/{id}/top-tracks
          Uri.parse(
              'https://api.spotify.com/v1/artists/$artistId/top-tracks?country=IN'),
          // Uri.parse('https://api.spotify.com/v1/artists/$artistId/albums'),
          headers: {'Authorization': 'Bearer $accessToken'});

      if (response.statusCode == 200) {
        Map<String, dynamic> fetchedTracks = await json.decode(response.body);
        var artistTopTracks = {
          'artistsTopTracks': fetchedTracks,
          'artistProfile': await getArtist(artistId)
        };
        print(artistTopTracks);
        return artistTopTracks;
      } else {
        print(
            'something went wrong fetching artist tracks details ${response.statusCode}');
      }
    } catch (exception) {
      print('The exception is $exception');
    }
  }

//FOLLOWING CODE FETCHES SEVERAL PODCAST SHOW
  getSeveralShows({accessTkn}) async {
    try {
      var response = await http.get(
          Uri.parse('https://api.spotify.com/v1/search?q=podcast&type=show'),
          headers: {'Authorization': 'Bearer $accessTkn'});

      if (response.statusCode == 200) {
        Map<String, dynamic> fetchedShow = await json.decode(response.body);
        var shows = {'shows': fetchedShow};
        print('the fetched shows are ${shows}');
        return shows;
      } else {
        print(
            'something went wrong fetching shows details ${response.statusCode}');
      }
    } catch (exception) {
      print('The exception is $exception');
    }
  }

  //FOLLOWING CODE FETCHES SEVERAL TRACKS

  getSeveralTracks({accessTkn}) async {
    var tamilTrendingId = '37i9dQZF1DX4Im4BTs2WMg';
    try {
      var response = await http.get(
          Uri.parse('https://api.spotify.com/v1/playlists/${tamilTrendingId}'),
          headers: {'Authorization': 'Bearer $accessTkn'});

      if (response.statusCode == 200) {
        Map<String, dynamic> fetchedTracks = await json.decode(response.body);
        var tracks = {'tracks': fetchedTracks};
        print('the fetched tracks are ${tracks}');
        return tracks;
      } else {
        print(
            'something went wrong fetching tracks details ${response.statusCode}');
        return null;
      }
    } catch (exception) {
      print('The exception is $exception');
    }
  }

  getTopArtists({accessTkn}) async {
    var id = '4zCH9qm4R2DADamUHMCa6O';
    try {
      var response = await http.get(
          Uri.parse(
              'https://api.spotify.com/v1/artists/$id/related-artists'), //https://api.spotify.com/v1/artists/{id}/related-artists
          headers: {'Authorization': 'Bearer $accessTkn'});

      if (response.statusCode == 200) {
        Map<String, dynamic> topArtists = await json.decode(response.body);
        var artists = {'topArtists': topArtists};
        print('the fetched tracks are ${artists}');
        return artists;
      } else {
        print(
            'something went wrong fetching top Artists ${response.statusCode}');
        return null;
      }
    } catch (exception) {
      print('The exception is $exception');
    }
  }

  getRelatedArtists({artistId}) async {
    try {
      var id = artistId;
      var token = await HandlingLoggedInLoggedOut().queryingFromDatabase();
      var accessTkn = token[0]['token'];
      var response = await http.get(
          Uri.parse(
              'https://api.spotify.com/v1/artists/$id/related-artists'), //https://api.spotify.com/v1/artists/{id}/related-artists
          headers: {'Authorization': 'Bearer $accessTkn'});

      if (response.statusCode == 200) {
        Map<String, dynamic> topArtists = await json.decode(response.body);
        var artists = {'relatedArtists': topArtists};
        print('the fetched artists are ${artists}');
        return artists;
      } else {
        print(
            'something went wrong fetching top Artists ${response.statusCode}');
        return null;
      }
    } catch (exception) {
      print('The exception is $exception');
    }
  }



  getHomePageContent() async {
    try {
      final clientId = "0c0e6ba13321413da5b3e9a6769c1bd5";
      final clientSecretId = "c87f06a7d2eb4569bb91c697e2837bb0";
      var base64Cred = utf8.fuse(base64).encode('$clientId:$clientSecretId');
      HandlingLoggedInLoggedOut handling = HandlingLoggedInLoggedOut();
      var queryingFromDataBase = await handling.queryingFromDatabase();
      var accessToken = queryingFromDataBase[0]['token'];
      String refresh_token = queryingFromDataBase[0]['refreshToken'] as String;

      await requestRefreshToken(refresh_token, clientId, base64Cred);

      Map<dynamic, dynamic> homePageContent = {
        'recentlyPlayed': await getRecentlyPlayed(accessTkn: accessToken),
        'newReleases': await getNewReleases(accessTkn: accessToken),
        'shows': await getSeveralShows(accessTkn: accessToken),
        'severalTracks': await getSeveralTracks(accessTkn: accessToken),
        'artistsAlbums': await getArtistsAlbums(
            '0YC192cP3KPCRWx8zr8MfZ'), //0YC192cP3KPCRWx8zr8MfZ  of Hans Zimmer    0YC192cP3KPCRWx8zr8MfZ
        'topArtists': await getTopArtists(accessTkn: accessToken)
      };
      return homePageContent;
    } catch (exp) {
      print('something went wrong with home page content $exp');
    }
  }
}
//anirudh:4zCH9qm4R2DADamUHMCa6O
        //    'artistAlbum': getArtistsAlbums('artistId')