import 'package:dotenv/dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sfotify/BLoC/bloc.dart';
import 'package:sfotify/BLoC/blocEvents.dart';
import 'package:sfotify/dataBase/dataBase.dart';
import 'package:sfotify/userAuth/logIn.dart';
import 'package:sfotify/Pages/premiumPage.dart';
import 'package:sfotify/Pages/searchPage.dart';
import 'package:sfotify/Pages/settings.dart';
import 'Pages/homePage.dart';
import 'Pages/libraryPage.dart';

void main(){
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  Future<bool> initializeTableStatus() async {
    bool tableStaus = false;
    int status = 0;
    HandlingLoggedInLoggedOut handling = HandlingLoggedInLoggedOut();
    tableStaus = await handling.queryingTableStatus();
    if (tableStaus) {
      List<Map<String, Object?>> row = await handling.queryingFromDatabase();
      Map map = row[0];
      status = map['loggedInOut'];
      if (status == 1) {
        return tableStaus = true;
      } else {
        return false;
      }
    }
    return tableStaus;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initializeTableStatus(),
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              strokeWidth: 4,
              color: Colors.green[600],
            ));
          } else if (snapShot.hasError) {
            return Text('Error: ${snapShot.error}');
          } else {
            bool logInOut = snapShot.data as bool;
            return 

        //THIS IS WHERE BLOC STARTS    
            BlocProvider<PageLoaderBloc>(

              create:(context) => PageLoaderBloc(),
              child:

            MaterialApp(
              themeMode: ThemeMode.dark,
              darkTheme: ThemeData.dark(),
              debugShowCheckedModeBanner: false,
              title: 'Sfotify',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              routes: <String, WidgetBuilder>{
                '/MyHomePage': (BuildContext context) => new MyHomePage(
                      title: 'Stofity',
                    ),
                '/LogIn': (BuildContext context) => new LogIn(),
                '/Settings': (BuildContext context) => new Settings(),
              },
               home: logInOut ? MyHomePage(title: 'Sfotify') : LogIn(),
              //home: MyHomePage(title: 'Sfotify'),
            )
            

            );



          }
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int bnbIndex = 0;
  var screen = [HomePage(), SearchPage(), PremiumPage(), LibraryPage()];

  @override
  void initState() {
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () async{
      return false;
    },child:Scaffold(
      body: Stack(
         
          children: [
            screen[bnbIndex],
            Positioned(
                top: 660,
                left: 7,
                right: 7,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[500],
                      borderRadius: BorderRadius.circular(7)),
                  padding: EdgeInsets.all(20),
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Container(
                        height: 70,
                        width: 40,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/batman.jpg'),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text('Currently Playing'),
                      Expanded(
                        child: Text(''),
                      ),
                      IconButton(onPressed: () {}, icon: Icon(Icons.play_arrow))
                    ],
                  ),
                )),
          ]),

      

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.library_books_outlined), label: 'Library'),
          BottomNavigationBarItem(
              icon: Icon(Icons.workspace_premium_outlined), label: 'Premium')
        ],
        onTap: (index) {
          setState(() {
            bnbIndex = index;
          });
        },
      ),
    ));
  }
}
