import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sfotify/BLoC/bloc.dart';
import 'package:sfotify/BLoC/blocEvents.dart';
import 'package:sfotify/SpotifyAPICalls/apiFuntions.dart';

class ArtistPage extends StatefulWidget {
  var artistId;
  ArtistPage({this.artistId});

  @override
  State<ArtistPage> createState() {
    return ArtistPageState();
  }
}

class ArtistPageState extends State<ArtistPage> {
  @override
  Widget build(BuildContext context) {
    print('We are at Artist page');

    return FutureBuilder(
      future: SpotifyApiServices().getArtistsTopTracks(widget.artistId),
      builder: (context, snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
            color: Colors.green,
          ));
        } else if (snapShot.hasError) {
          print('something fishy');
          return Container(
            child: Center(
              child: IconButton(
                  onPressed: () {
                    setState(() {});
                  },
                  icon: Icon(Icons.replay)),
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          );
        }

        Map<dynamic, dynamic> artistTrackInfo = snapShot.data as Map;
        return WillPopScope(
          child: Scaffold(
              /*appBar:  //appBar(artistTrackInfo['artistProfile']['artist']
                       // ['images'][0]['url'], artistTrackInfo['artistProfile']['artist']['name'])
                      CustomAppBar(imgUrl:artistTrackInfo['artistProfile']['artist']
                        ['images'][0]['url'], artistName:artistTrackInfo['artistProfile']['artist']['name'])              
              ,
              /*  */
               AppBar(
                  automaticallyImplyLeading: false,
                  toolbarHeight: 220,
                  centerTitle: true,
                  title: Stack(children: [
                    /*
                    Container(
                      //padding: EdgeInsets.all(8),
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              //image: AssetImage('assets/images/batman.jpg'),
                              image: NetworkImage(
                                  artistTrackInfo['artistProfile']['artist']
                                      ['images'][0]['url']),
                              fit: BoxFit.cover)),
                    ),*/

                    Image.network(artistTrackInfo['artistProfile']['artist']
                        ['images'][0]['url'],width: MediaQuery.of(context).size.width,height: kToolbarHeight,fit: BoxFit.cover,),
                    Positioned(
                        child: Container(
                      child: Text(
                        artistTrackInfo['artistProfile']['artist']['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                      padding: EdgeInsets.all(7),
                    )),
                  ])),*/
              body: CustomScrollView(slivers:[SliverToBoxAdapter(child:SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  SizedBox(
                    height: 7,
                  ),

                  Container(
                      height: (artistTrackInfo['artistsTopTracks']['tracks']
                                  .length *
                              50) +
                          0.55,
                      width: MediaQuery.of(context).size.width,
                      //700, //count the number of items in an album then multiply it with the heigt of each track
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () async {
                                //await  AudioPlayer().play(albumInfo['album']['tracks']['items'][index]
                                //   ['preview_url']);
                              },
                              child: Container(
                                width: double
                                    .infinity, // implement StatefulBuilder here
                                height: 50,
                                child: Row(children: [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(artistTrackInfo[
                                                        'artistsTopTracks']
                                                    ['tracks'][index]['album']
                                                ['images'][0]['url']))),
                                  ),
                                  SizedBox(
                                    width: 7,
                                  ),
                                  Container(
                                      child: Text(
                                    artistTrackInfo['artistsTopTracks']
                                        ['tracks'][index]['name'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis),
                                    maxLines: 1,
                                  )),
                                  Expanded(
                                    child: Container(),
                                  ),
                                  Text(
                                    '${getTrackDuration(artistTrackInfo['artistsTopTracks']['tracks'][index]['duration_ms'])}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  )
                                ]),
                              ));
                        },
                        itemCount: artistTrackInfo['artistsTopTracks']['tracks']
                            .length,
                        physics: NeverScrollableScrollPhysics(),
                      )),
                  // ]),
                  SizedBox(
                    height: 7,
                  ),
                  Container(
                      child: Text(
                    'Related artists ',
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
                    future: SpotifyApiServices().getRelatedArtists(
                        artistId: artistTrackInfo['artistsTopTracks']['tracks']
                            [0]['artists'][0]['id']),
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
                        Map<dynamic, dynamic> relatedArtists =
                            snapShot.data as Map;
                        return Container(
                            height: 170,
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                    onTap: () {
                                      //THE FOLLOWING CODE WILL HELP YOU OPEN NEW SCREENS ONLY BASED ON THEIR TYPE SO CONSIDER CHECKING THE TYPE OF THE SCREEN WHICH YOU WANNA OPEN
                                      print('saying hellow from album page');
                                      // context.read<PageLoaderBloc>().add(
                                      //  AlbumPageEvent(
                                      //      albumId: relatedArtists['relatedArtists']
                                      //             ['artists'][index]['id']));
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
                                              child: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    relatedArtists[
                                                                'relatedArtists']
                                                            ['artists'][index]
                                                        ['images'][0]['url']),
                                              ),
                                            ),
                                            SizedBox(height: 7),
                                            Container(
                                                width: 120,
                                                child: Text(
                                                  relatedArtists[
                                                              'relatedArtists']
                                                          ['artists'][index]
                                                      ['name'],
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
                              itemCount: relatedArtists['relatedArtists']
                                      ['artists']
                                  .length,
                              scrollDirection: Axis.horizontal,
                            ));
                      }
                    },
                  ),

                  Container(
                    
                    height: 120,
                  ),
                ],
              )))])),
          onWillPop: () async {
            return true;
          },
        ); //wraphere
      },
    );


  }

  getTrackDuration(milliSeconds) {
    var remainingMins = 0.0;
    double doubleSec = milliSeconds / 1000;
    int sec = doubleSec.toInt();
    if (sec < 60) return '0:${sec.toString()}';
    var tempSec = sec % 60;
    var tempSec1 = sec - tempSec;
    if (tempSec1 >= 60) {
      var minutes = tempSec1 ~/ 60;
      if (minutes >= 60) {
        remainingMins = minutes % 60;
        var tempHour1 = minutes - remainingMins;
        var tempHour2 = tempHour1 / 60;
        return '${tempHour2.toString()}:${remainingMins.toString()}:${tempSec.toString()}';
      } else {
        return '${minutes.toString()}:${tempSec.toString()}';
      }
    }
  }

  appBar(imgUrl,artistName){
    return Stack(children: [
                    /*
                    Container(
                      //padding: EdgeInsets.all(8),
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              //image: AssetImage('assets/images/batman.jpg'),
                              image: NetworkImage(
                                  artistTrackInfo['artistProfile']['artist']
                                      ['images'][0]['url']),
                              fit: BoxFit.cover)),
                    ),*/

                    Image.network(imgUrl,width: MediaQuery.of(context).size.width,height: kToolbarHeight,fit: BoxFit.cover,),
                    Positioned(
                        child: Container(
                      child: Text(
                        artistName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                      padding: EdgeInsets.all(7),
                    )),
                  ]);
  }

}

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  late var imgUrl,artistName;
  CustomAppBar({this.imgUrl,this.artistName});
  @override
  Widget build(context){
    return Stack(children: [
                    /*
                    Container(
                      //padding: EdgeInsets.all(8),
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              //image: AssetImage('assets/images/batman.jpg'),
                              image: NetworkImage(
                                  artistTrackInfo['artistProfile']['artist']
                                      ['images'][0]['url']),
                              fit: BoxFit.cover)),
                    ),*/

                    Image.network(imgUrl,width: MediaQuery.of(context).size.width,height: 400,fit: BoxFit.cover,),
                    Positioned(
                        child: Container(
                      child: Text(
                        artistName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                      padding: EdgeInsets.all(7),
                    )),
                    
                  ]);
  }
  
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

}
