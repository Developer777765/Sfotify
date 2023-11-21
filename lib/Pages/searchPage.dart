import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sfotify/SpotifyAPICalls/apiFuntions.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() {
    return SearchPageState();
  }
}

class SearchPageState extends State<SearchPage> {
  List<Color> colors = [
    Colors.pink,
    Colors.teal,
    Colors.orange,
    Colors.red,
    Colors.green,
    Colors.grey,
    Colors.blue,
    Colors.indigo,
    Colors.amberAccent,
    Colors.brown
  ];

  List<String> categories = [
    'Podcasts',
    'New Releases',
    'Hindi',
    'Punjabi',
    'Tamil',
    'Telugu',
    'Pop',
    'Trending',
    'Malayalam',
    'Love',
    'Workout',
    'Hip-Hop',
    'Party',
    'Chil',
    'Sleep'
  ];

  @override //WE HAVE TO IMPLEMENT BLOC HERE
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(top: 10),
        child: Scaffold(
            body: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              automaticallyImplyLeading: false,
              pinned: true,
              snap: false,
              bottom: AppBar(
                title: Container(
                  height: 45,
                  child: TextField(
                    onSubmitted: (value) {
                      //implement the serach mechanism here
                      //SpotifyApiServices().search(query);
                      //if we get hands on the content then implement bloc like 'context.read<PageLoaderBloc>().add(ResultEvent(query));
                      //if api returns nothing then update like 'no results found' with bloc
                    },
                    decoration: InputDecoration(hintText: 'Search for music'),
                  ),
                  color: Colors.white,
                ),
              ),
            ),
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return GestureDetector(
                    onTap: () {
                      print('Implementation under process');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      color: colors[Random().nextInt(colors.length)],
                      width: double.infinity - 10,
                      height: 80,
                      child: Center(
                          child: Text(
                        '${categories[index]}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )),
                    ),
                  );
                },
                childCount: 15,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                childAspectRatio: 2.5,
              ),
            )
          ],
        )));
  }
}
