import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sfotify/SpotifyAPICalls/apiFuntions.dart';
import 'package:sfotify/dataBase/dataBase.dart';

class Settings extends StatefulWidget {
  @override
  State<Settings> createState() {
    return SettingsState();
  }
}

class SettingsState extends State<Settings> {
  String? userProfileName;
  String? userProfileEmail;
  var userProfilePicture;

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                FutureBuilder(
                    future: SpotifyApiServices().getUserProfile(),
                    builder: (context, snapShot) {
                      if (snapShot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: CircularProgressIndicator(
                          strokeWidth: 4,
                          color: Colors.green[600],
                        ));
                      } else if (snapShot.hasError) {
                        return Text('Something went wrong');
                      } else {
                        var userProf = snapShot.data as Map;
                        return GestureDetector(
                            child: Row(
                              children: [
                                ClipOval(
                                  child: userProf['ProfilePicture'] == null
                                      ? Image.network(
                                          userProf['profilePicture'],
                                          fit: BoxFit.fill,
                                          width: 50,
                                          height: 50,
                                        )
                                      : Icon(
                                          Icons.account_circle_outlined,
                                          weight: 50,
                                        ),
                                ),
                                SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      //this.userProfileName ?? 'dummyName',
                                      '${userProf['userName']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25),
                                    ),
                                    Container(
                                        child: Text(
                                      'View Profile',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ))
                                  ],
                                ),
                                Spacer(),
                                Text(
                                  '>',
                                  style: TextStyle(fontSize: 25),
                                ),
                                SizedBox(
                                  width: 15,
                                )
                              ],
                            ),
                            onTap: () {
                              print('To be implemented very soon');
                            });
                      }
                    }),
                SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Data Saver',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Audio Quality',
                      style: TextStyle(fontSize: 13),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          'Sets your audio quality to low (equailent to 24kbi/s) and disables artis canvases.',
                          overflow: TextOverflow.clip,
                          style: TextStyle(fontSize: 11),
                        )),
                        Switch(
                          value: false,
                          onChanged: null,
                          inactiveThumbColor: Colors.grey[100],
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Video Podcasts',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Download audio only',
                      style: TextStyle(fontSize: 13),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          'Save video podcasts as audio only',
                          overflow: TextOverflow.clip,
                          style: TextStyle(fontSize: 11),
                        )),
                        Spacer(),
                        Switch(
                          value: false,
                          onChanged: null,
                          inactiveThumbColor: Colors.grey[100],
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Playback',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Crossfade',
                      style: TextStyle(fontSize: 13),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          'Allows you to crossfade you between songs.',
                          overflow: TextOverflow.clip,
                          style: TextStyle(fontSize: 11),
                        )),
                        Switch(
                          value: false,
                          onChanged: null,
                          inactiveThumbColor: Colors.grey[100],
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Languages',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Languages for music',
                      style: TextStyle(fontSize: 13),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          'Choose your preferred languages for music.',
                          overflow: TextOverflow.clip,
                          style: TextStyle(fontSize: 11),
                        )),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Devices',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Show local devices only',
                      style: TextStyle(fontSize: 13),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          'Only show devices on your local WIFI or ethernet in the devices menu.',
                          overflow: TextOverflow.clip,
                          style: TextStyle(fontSize: 11),
                        )),
                        Switch(
                          value: false,
                          onChanged: null,
                          inactiveThumbColor: Colors.grey[100],
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Voice Assistants & Apps',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Navigation & Other Apps',
                      style: TextStyle(fontSize: 13),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          'Connect with navigation and other apps to enhance your listening experience.',
                          overflow: TextOverflow.clip,
                          style: TextStyle(fontSize: 11),
                        )),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Social',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Private session',
                      style: TextStyle(fontSize: 13),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          'Start a private session to listen anonymously',
                          overflow: TextOverflow.clip,
                          style: TextStyle(fontSize: 11),
                        )),
                        Switch(
                          value: false,
                          onChanged: null,
                          inactiveThumbColor: Colors.grey[100],
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Local Files',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Show audio files from this device',
                      style: TextStyle(fontSize: 13),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          'Add tracks from this device into your library',
                          overflow: TextOverflow.clip,
                          style: TextStyle(fontSize: 11),
                        )),
                        Switch(
                          value: false,
                          onChanged: null,
                          inactiveThumbColor: Colors.grey[100],
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Other',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Log out',
                      style: TextStyle(fontSize: 13),
                    ),
                    GestureDetector(
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            'Logs you out of this account',
                            overflow: TextOverflow.clip,
                            style: TextStyle(fontSize: 11),
                          )),
                        ],
                      ),
                      onTap: () {
                        print('to be implemented very soon');
                      },
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }
}
