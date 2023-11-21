import 'package:flutter/material.dart';

//under implementation
class CustomNavBar extends StatelessWidget {
  CustomNavBar(int index, Function onItemSelected);
  @override
  Widget build(BuildContext context) {
    return Container(
      
      width: MediaQuery.of(context).size.width,
      height: 120,
    );
  }
}


/*
 Container(
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    children: [
                      Container(
                          padding: EdgeInsets.only(left: 7),
                          height: 40,
                          width: 30,
                          child: Image(
                            image: AssetImage('assets/images/batman.jpg'),
                            fit: BoxFit.cover,
                          )),
                      Expanded(
                          child: Center(
                              child: Text(
                        'Data of current song',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))),
                      IconButton(
                          onPressed: () {
                            print('under progress');
                          },
                          icon: Icon(Icons.speaker_group)),
                      IconButton(
                          onPressed: () {
                            print('under implementation');
                          },
                          icon: Icon(Icons.play_arrow))
                    ],
                  )),
              //width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
             // height: 80,
            ),
            SizedBox(
              height: 5,
            ),
*/