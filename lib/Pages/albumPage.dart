import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sfotify/BLoC/bloc.dart';
import 'package:sfotify/BLoC/blocEvents.dart';
import 'package:sfotify/SpotifyAPICalls/apiFuntions.dart';

class AlbumPage extends StatefulWidget {
  var albumId;
  AlbumPage({this.albumId});

  @override
  State<AlbumPage> createState() {
    return AlbumPageState();
  }
}

class AlbumPageState extends State<AlbumPage> {
  @override
  Widget build(BuildContext context) {
    print('We are at album page');

    return FutureBuilder(
      future: SpotifyApiServices().getAnAlbum(widget.albumId),
      builder: (context, snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
            color: Colors.green,
          ));
        } else if (snapShot.hasError) {
          print('something fishy');
        }
        print('the retrieved information of albums ${snapShot.data}');
        Map<dynamic, dynamic> albumInfo = snapShot.data as Map;
        return WillPopScope(
          child: Scaffold(
              appBar: AppBar(
                  automaticallyImplyLeading: false,
                  toolbarHeight: 220,
                  centerTitle: true,
                  title: Container(
                    padding: EdgeInsets.all(8),
                    height: 160,
                    width: 147,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            //image: AssetImage('assets/images/batman.jpg'),
                            image: NetworkImage(
                                albumInfo['album']['images'][0]['url']),
                            fit: BoxFit.cover)),
                  )),
              body: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      child: Text(
                    ' ${albumInfo['album']['name']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 2,
                  )),
                  SizedBox(
                    height: 7,
                  ),
                  Row(
                    children: [
                      FutureBuilder(
                        future: SpotifyApiServices()
                            .getArtist(albumInfo['album']['artists'][0]['id']),
                        builder: (context, artistSnapshot) {
                          Map<dynamic, dynamic> artistData =
                              artistSnapshot.data as Map;
                          print('the artistis profile is ${artistData}');
                          if (artistSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container(
                              height: 40,
                              width: 40,
                            );
                          } else if (artistSnapshot.hasError) {
                            print('something messy happened fetching artist');
                            return Container();
                          }
                          return Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: //AssetImage(
                                        //'assets/images/batman.jpg')
                                        NetworkImage(artistData['artist']
                                            ['images'][0]['url']))),
                          );
                        },
                      ),
                      /*
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            //shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage('assets/images/batman.jpg'))),
                      ),*/
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '${albumInfo['album']['artists'][0]['name']}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 7,
                  ),

                  Container(
                      height: (albumInfo['album']['total_tracks'] * 50) + 0.55,
                      //700, //count the number of items in an album then multiply it with the heigt of each track
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () async {
                                //await  AudioPlayer().play(albumInfo['album']['tracks']['items'][index]
                                //   ['preview_url']);
                              },
                              child: Container(
                                width: 170, // implement StatefulBuilder here
                                height: 50,
                                child: Row(children: [
                                  Text(
                                    albumInfo['album']['tracks']['items'][index]
                                        ['name'],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: Container(),
                                  ),
                                  Text(
                                    '${getTrackDuration(albumInfo['album']['tracks']['items'][index]['duration_ms'])}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ]),
                              ));
                        },
                        itemCount: albumInfo['album']['total_tracks'],
                        physics: NeverScrollableScrollPhysics(),
                      )),
                  // ]),
                  SizedBox(
                    height: 7,
                  ),
                  Container(
                      child: Text(
                    'You might also like ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 2,
                  )),
                  SizedBox(
                    height: 7,
                  ),

                  FutureBuilder(
                    future: SpotifyApiServices().getArtistsAlbums(
                        albumInfo['album']['artists'][0]['id']),
                    builder: (context, snapShot) {
                      if (snapShot.connectionState == ConnectionState.waiting) {
                        return Container(
                          height: 150,
                        );
                      } else if (snapShot.hasError) {
                        return Container(
                          height: 150,
                        );
                      } else {
                        Map<dynamic, dynamic> albums = snapShot.data as Map;
                        return Container(
                            height: 170,
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                    onTap: () {
                                      //THE FOLLOWING CODE WILL HELP YOU OPEN NEW SCREENS ONLY BASED ON THEIR TYPE SO CONSIDER CHECKING THE TYPE OF THE SCREEN WHICH YOU WANNA OPEN
                                      print('saying hellow from album page');
                                      context.read<PageLoaderBloc>().add(
                                          AlbumPageEvent(
                                              albumId: albums['artistsAlbums']
                                                  ['items'][index]['id']));
                                    },
                                    child: Container(
                                        width: 145,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 130,
                                              width: 140,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          albums['artistsAlbums']
                                                                      ['items'][
                                                                  index]['images']
                                                              [0]['url']))),
                                            ),
                                            SizedBox(height: 7),
                                            Container(
                                                width: 120,
                                                child: Text(
                                                  albums['artistsAlbums']
                                                      ['items'][index]['name'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ))
                                          ],
                                        )));
                              },
                              itemCount:
                                  albums['artistsAlbums']['items'].length,
                              scrollDirection: Axis.horizontal,
                            ));
                      }
                    },
                  ),

                  Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 7,
                          ),
                          Container(
                            child: Text(
                              albumInfo['album']['copyrights'][0]['text'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            albumInfo['album']['release_date'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Expanded(child: Container())
                        ]),
                    height: 120,
                  ),
                ],
              ))),
          onWillPop: () async {
            return true;
          },
        ); //wraphere
      },
    );

/*
    return WillPopScope(
      child: Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: 220,
              centerTitle: true,
              title: Container(
                padding: EdgeInsets.all(8),
                height: 160,
                width: 140,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: AssetImage('assets/images/batman.jpg'),
                        fit: BoxFit.cover)),
              )),
          body: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                  child: Text(
                'Name of the album ${widget.number}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 2,
              )),
              SizedBox(
                height: 7,
              ),
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        //shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage('assets/images/batman.jpg'))),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'name of the artist',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  )
                ],
              ),
              SizedBox(
                height: 7,
              ),

              Container(
                  height:
                      700, //count the number of items in an album the multiply it with the heigt of each track
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Container(
                        width: 170,
                        height: 70,
                        child: Text('item $index'),
                      );
                    },
                    itemCount: 10,
                    physics: NeverScrollableScrollPhysics(),
                  )),
              // ]),
              SizedBox(
                height: 7,
              ),
              Container(
                  child: Text(
                'You might also like ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 2,
              )),
              SizedBox(
                height: 7,
              ),

              Container(
                  height: 150,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Container(
                        height: 130,
                        width: 140,
                        // child: Card(child: Text('item $index')),
                        child: GestureDetector(
                          child: Card(
                            child: Text('item $index'),
                          ),
                          onTap: () {

                            //THE FOLLOWING CODE WILL HELP YOU OPEN NEW SCREENS ONLY BASED ON THEIR TYPE SO CONSIDER CHECKING THE TYPE OF THE SCREEN WHICH YOU WANNA OPEN  
                            print('saying hellow from album page');
                            context
                                .read<PageLoaderBloc>()
                                .add(AlbumPageEvent(number:15));
                          },
                        ),
                      );
                    },
                    scrollDirection: Axis.horizontal,
                  )),
              Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 7,
                      ),
                      Expanded(
                          child: Container(
                        child: Text(
                          ' 2023 Think Music',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )),
                      Text(
                        '                  ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ]),
                height: 120,
              )
            ],
          ))),
      onWillPop: () async {
        return true;
      },
    ); */
  }

  getTrackDuration(milliSeconds) {
    var remainingMins = 0.0;
    double doubleSec = milliSeconds / 1000;
    int sec = doubleSec.toInt();
    if (sec < 60) return '0:${sec.toString()}sec';
    var tempSec = sec % 60;
    var tempSec1 = sec - tempSec;
    if (tempSec1 >= 60) {
      var minutes = tempSec1 ~/ 60;
      if (minutes >= 60) {
        remainingMins = minutes % 60;
        var tempHour1 = minutes - remainingMins;
        var tempHour2 = tempHour1 / 60;
        return '${tempHour2.toString()}hr ${remainingMins.toString()}min ${tempSec.toString()}sec';
      } else {
        return '${minutes.toString()}min ${tempSec.toString()}sec';
      }
    }
  }
}
