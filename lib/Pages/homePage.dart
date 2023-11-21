import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sfotify/BLoC/bloc.dart';
import 'package:sfotify/BLoC/blocEvents.dart';
import 'package:sfotify/BLoC/blocStates.dart';
import 'package:sfotify/SpotifyAPICalls/apiFuntions.dart';
import 'package:sfotify/Pages/artistPage.dart';
import 'package:sfotify/userAuth/logIn.dart';
import 'package:sfotify/Pages/settings.dart';
import 'albumPage.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  List<String> category = [
    'New releases',
    'Shows that you might like',
    'Recently played',
    'Trending tamil',
    'Listen to',
    'Finest of Hans Zimmer',
  ];

  bool closeApp = true;
  List<Widget> pages = [];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () async {
      if (pages.isNotEmpty) {
        // pages.remove(pages.length-1);

        if (pages.isNotEmpty) {
          // closeApp = false;
          //the following line of code opens screens according to what kind of screen the pages list has as its last item/previous screen.
          //so check the screen type before openning it.
          // context.read<PageLoaderBloc>().add(AlbumPageEvent(albumId:2));
        }
      } else {
        //  CREATE HOMEPAGEEVENT
        //context.read<PageLoaderBloc>().add(HomePageEvent());
      }

      return false;
    }, child: BlocBuilder<PageLoaderBloc, LoadPageStates>(
      builder: (context, state) {
        if (state is BlocInitialPage) {
          return Container(
              padding: EdgeInsets.only(top: 15),
              color: Colors.black,
              child: Scaffold(
                backgroundColor: Colors.black,
                body: FutureBuilder(
                    //future: SpotifyApiServices().getRecentlyPlayed(),
                    //future: SpotifyApiServices().getNewReleases(),
                    future: SpotifyApiServices().getHomePageContent(),
                    builder: (context, snapShot) {
                      //SpotifyApiServices().getSeveralShows();
                      if (snapShot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: CircularProgressIndicator(
                          color: Colors.green,
                        )); //WRAP THE FUTURE BUILDER FOR TESTING PURPOSES
                      } else if (snapShot.hasError) {
                        print('something fishy');
                      }
                      var homePageContent = snapShot.data as Map;
                      return CustomScrollView(
                        slivers: [
                          SliverAppBar(
                            title: Card(
                              child: InkWell(
                                child: Container(
                                  child: SizedBox(
                                    height: 20,
                                  ),
                                ),
                              ),
                            ),
                            backgroundColor: Colors.black,
                            pinned: true,
                            floating: true,
                            expandedHeight: 140,
                            flexibleSpace: FlexibleSpaceBar(
                              centerTitle: true,
                              title: Row(children: [
                                Card(
                                  color: Colors.grey[900],
                                  child: InkWell(
                                    onTap: () {
                                      print('under development');
                                    },
                                    child: Container(
                                      width: 50,
                                      height: 23,
                                      child: Center(
                                          child: Text(
                                        'Music',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                                SizedBox(
                                  width: 1,
                                ),
                                Card(
                                  color: Colors.grey[900],
                                  child: InkWell(
                                    onTap: () {
                                      print('under development');
                                    },
                                    child: Container(
                                      width: 125,
                                      height: 23,
                                      child: Center(
                                          child: Text(
                                        'Podcasts & Shows',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                )
                              ]),
                              background: Row(
                                children: [
                                  SizedBox(
                                    width: 7,
                                  ),
                                  Text(
                                    'Good morning',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25),
                                  ),
                                  Spacer(),
                                  IconButton(
                                      iconSize: 35,
                                      onPressed: null,
                                      icon: Icon(
                                        Icons.notifications_outlined,
                                        color: Colors.white,
                                      )),
                                  IconButton(
                                      iconSize: 35,
                                      onPressed: null,
                                      icon: Icon(
                                        Icons.watch_later_outlined,
                                        color: Colors.white,
                                      )),
                                  IconButton(
                                      iconSize: 35,
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    Settings())));
                                        //print('under implementation');
                                      },
                                      icon: Icon(
                                        Icons.settings_outlined,
                                        color: Colors.white,
                                      ))
                                ],
                              ),
                            ),
                            centerTitle: false,
                          ),

                          //FOLLOWING SECTION "RECENT" IS A TYPE OF GRID WHICH FALLS RIGHT UNDER OUR APPBAR

                          //RECENTS
                          SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 5,
                                    crossAxisSpacing: 5,
                                    childAspectRatio: 2.5),
                            delegate:
                                SliverChildBuilderDelegate((context, index) {
                              return GestureDetector(
                                onTap: () {
                                  //print(recentlyPlayed['items'][1]['track']['album']['release_date']);
                                  // print(recentlyPlayed['items'][index]['track']
                                  //    ['album']['images'][0]['url']);
                                },
                                //child: Container(
                                //color: Colors.grey,
                                child: Card(
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 70,
                                        width: 70,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    homePageContent['recentlyPlayed']
                                                                ['items'][index]
                                                            ['track']['album']
                                                        ['images'][0]['url']),

                                                // AssetImage(
                                                //     'assets/images/batman.jpg'),
                                                fit: BoxFit.cover),
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8.0),
                                                bottomLeft:
                                                    Radius.circular(8.0))),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Expanded(
                                          child: Center(
                                              child: Text(
                                        //'item $index',
                                        homePageContent['recentlyPlayed']
                                                ['items'][index]['track']
                                            ['album']['name'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      )))
                                    ],
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0))),
                                ),
                                // )
                              );
                            }, childCount: 6),
                          ),

                          //RECENTS -->GRID VIEW ENDS HERE

                          SliverToBoxAdapter(
                            child: SizedBox(
                              height: 20,
                            ),
                          ),

                          SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  (context, index) => switchingCategories(
                                      index, homePageContent),
                                  //switchingCategories(index),
                                  childCount: category.length))
                        ],
                      );
                    }),
              ));
        } else {
          var id = state.albumId;
          return AlbumPage(
            albumId: id,
          ); // pass the number here
        }
      },
    ));
  }

  Widget switchingCategories(indexes, Map<dynamic, dynamic> contentOfHomePage) {
    //Widget switchingCategories(indexes) {
    late Widget item;
    switch (indexes) {
      case 0:
        {
          item = Container(
            height: 180,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                '  ${category[indexes]}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                height: 150,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () {
                          //THE FOLLOWING CODE OPENS SPECIFIC SCREENS BASED ON THE TYPE OF THAT PARTICULAR SCREEN. SO CHECK THE ITEM'S TYPE BEFORE OPENING THE RESPECTIVE SCREEN
                          context.read<PageLoaderBloc>().add(AlbumPageEvent(
                              albumId: contentOfHomePage['newReleases']
                                  ['albums']['items'][index]['id']));
                        },
                        child: Container(
                            width: 140,
                            child: Column(
                              children: [
                                Container(
                                  width: 130,
                                  height: 110,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          image: //AssetImage(
                                              //   'assets/images/batman.jpg'),

                                              NetworkImage(contentOfHomePage[
                                                          'newReleases']
                                                      ['albums']['items'][index]
                                                  ['images'][0]['url']),
                                          fit: BoxFit.cover)),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  child: Text(
                                    contentOfHomePage['newReleases']['albums']
                                        ['items'][index]['name'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),

                                  //  child: Text('item $index'),
                                  width: 120,
                                )
                              ],
                            )));
                  },
                  scrollDirection: Axis.horizontal,
                  itemCount: contentOfHomePage['newReleases']['albums']['items']
                      .length,
                ),
              )
            ]),
          );
        }

        break;

      case 1:
        {
          item = Container(
            height: 200,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                '  ${category[indexes]}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                height: 150,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () {
                          print('index is $index');
                          print(
                              'shows from api :  ${contentOfHomePage['shows']['shows']['shows']['items'][index]['name']}');
                        },
                        child: Container(
                            width: 140,
                            child: Column(children: [
                              Container(
                                width: 130,
                                height: 125,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            contentOfHomePage['shows']['shows']
                                                    ['shows']['items'][index]
                                                ['images'][0]['url']))),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                  width: 120,
                                  child: Text(
                                    contentOfHomePage['shows']['shows']['shows']
                                        ['items'][index]['name'],
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                  ))
                            ])));
                  },
                  scrollDirection: Axis.horizontal,
                  itemCount: contentOfHomePage['shows']['shows']['shows']
                          ['items']
                      .length,
                ),
              )
            ]),
          );
        }
        break;
      case 2:
        {
          item = Container(
            height: 180,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                '  ${category[indexes]}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                height: 150,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () {
                          print('index is $index');
                          print(
                              'shows from api :  ${contentOfHomePage['recentlyPlayed']}');
                        },
                        child: Container(
                            width: 140,
                            child: Column(children: [
                              Container(
                                width: 130,
                                height: 110,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            contentOfHomePage['recentlyPlayed']
                                                        ['items'][index]
                                                    ['track']['album']['images']
                                                [0]['url']))),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                  width: 120,
                                  child: Text(
                                    contentOfHomePage['recentlyPlayed']['items']
                                        [index]['track']['album']['name'],
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                  ))
                            ])));
                  },
                  scrollDirection: Axis.horizontal,
                  itemCount:
                      contentOfHomePage['recentlyPlayed']['items'].length,
                ),
              )
            ]),
          );
        }
        break;
      case 3:
        {
          item = Container(
            height: 200,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                '  ${category[indexes]}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                height: 150,
                child: ListView.builder(
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () {
                            print('index is $index');
                            print(
                                'tracks from api :  ${contentOfHomePage['severalTracks']['tracks']['tracks']['items'][index]['track']['album']['name']}');
                          },
                          child: Container(
                              width: 140,
                              child: Column(children: [
                                Container(
                                  width: 130,
                                  height: 125,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              contentOfHomePage['severalTracks']
                                                                  ['tracks']
                                                              ['tracks']
                                                          ['items'][index]
                                                      ['track']['album']
                                                  ['images'][0]['url']))),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                    width: 120,
                                    child: Text(
                                      contentOfHomePage['severalTracks']
                                              ['tracks']['tracks']['items']
                                          [index]['track']['album']['name'],
                                      style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                    ))
                              ])));
                    },
                    scrollDirection: Axis.horizontal,
                    itemCount: contentOfHomePage['severalTracks']['tracks']
                            ['tracks']['items']
                        .length
                    //    contentOfHomePage['recentlyPlayed']['items'].length,
                    ),
              )
            ]),
          );
        }
        break;
      case 4:
        {
          item = Container(
            height: 180,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                '  ${category[indexes]}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                height: 150,
                child: ListView.builder(
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () { SpotifyApiServices().getArtistsTopTracks(contentOfHomePage['topArtists']['topArtists']['artists'][index]['id'])  ;
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ArtistPage(
                                artistId: contentOfHomePage['topArtists']['topArtists']['artists'][index]['id'],
                              );
                            }));
                          //print(contentOfHomePage['topArtists']['topArtists']['artists'][index]['id']);
                          },
                          child: Container(
                              width: 140,
                              child: Column(children: [
                                Container(
                                    width: 130,
                                    height: 110,
                                    child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            contentOfHomePage['topArtists']
                                                        ['topArtists']
                                                    ['artists'][index]['images']
                                                [0]['url'])) //),
                                    ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                    width: 120,
                                    child: Center(
                                        child: Text(
                                      contentOfHomePage['topArtists']
                                              ['topArtists']['artists'][index]
                                          ['name'],
                                      style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                    )))
                              ])));
                    },
                    scrollDirection: Axis.horizontal,
                    itemCount: contentOfHomePage['topArtists']['topArtists']
                            ['artists']
                        .length
                    //    contentOfHomePage['recentlyPlayed']['items'].length,
                    ),
              )
            ]),
          );
        }
        break;
      case 5:
        {
          item = Container(
            height: 260,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                '  ${category[indexes]}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                height: 170,
                child: ListView.builder(
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () {
                            print('index is $index');
                            print(
                                'tracks from api :  ${contentOfHomePage['severalTracks']['tracks']['tracks']['items'][index]['track']['album']['name']}');
                          },
                          child: Container(
                              width: 140,
                              child: Column(children: [
                                Container(
                                  width: 130,
                                  height: 125,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              contentOfHomePage['artistsAlbums']
                                                          ['artistsAlbums']
                                                      ['items'][index]['images']
                                                  [0]['url']))),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                    width: 120,
                                    child: Text(
                                      //'',
                                      contentOfHomePage['artistsAlbums']
                                              ['artistsAlbums']['items'][index]
                                          ['name'],
                                      style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                    ))
                              ])));
                    },
                    scrollDirection: Axis.horizontal,
                    itemCount: contentOfHomePage['artistsAlbums']
                            ['artistsAlbums']['items']
                        .length
                    //    contentOfHomePage['recentlyPlayed']['items'].length,
                    ),
              )
            ]),
          );
        }
    }

    return item;
  }
}
