import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:crypto/src/sha256.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:sfotify/SpotifyAPICalls/apiFuntions.dart';
import 'package:sfotify/dataBase/dataBase.dart';
import 'package:sfotify/Pages/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class LogIn extends StatelessWidget {
  static final clientId = "0c0e6ba13321413da5b3e9a6769c1bd5";
  static final clientSecretId = "c87f06a7d2eb4569bb91c697e2837bb0";

  static var cont;
  @override
  Widget build(BuildContext context) {
    cont = context;
    return Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            SizedBox(
              height: 120,
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                          // shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/images/sfotify.png'))),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Sfotify',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
                    )
                  ],
                )),
            Spacer(),
            Center(
              child: Text('Millions of songs.',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
            ),
            Center(
              child: Text('Free on Sfotify.',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
            ),
            Spacer(),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: InkWell(
                onTap: null,
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 50,
                  child: Center(
                    child: Text(
                      'Sign Up Free',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: InkWell(
                onTap: null,
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 50,
                  child: Center(
                    child: Text(
                      'Continue with Google',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              color: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: InkWell(
                onTap: authenticatingUser,
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 50,
                  child: Center(
                    child: Text(
                      'Log In',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }

  Future<void> authenticatingUser() async {
    try {
      var client_id = clientId;
      var redirectUri = 'sfotify:/';
      var state = generatingRandomString(32);
      List<String> scopes = [
        'user-read-private',
        'user-read-email',
        'playlist-read-private',
        'user-modify-playback-state',
        'user-read-playback-state',
        'playlist-read-collaborative',
        'user-top-read',
        'user-follow-read',
        'user-read-recently-played'
      ];

      var url = Uri(
          scheme: 'HTTPS',
          host: 'accounts.spotify.com',
          path: '/authorize',
          queryParameters: {
            'client_id': client_id,
            'redirect_uri': redirectUri,
            'scope': scopes,
            'response_type': 'code',
            'state': state,
          });

      final result = await FlutterWebAuth.authenticate(
          url: url.toString(), callbackUrlScheme: 'sfotify');

      var resultState = Uri.parse(result).queryParameters['state'];
      if (state != resultState) throw HttpException('invalid access,we failed');

      var code = Uri.parse(result).queryParameters['code'];
      await getAuthTokens(code, redirectUri);

      print(code);
    } on Exception catch (e) {
      print(e);
    }
  }

  String generatingRandomString(int len) {
    var possible =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    Random random = Random();
    return String.fromCharCodes(Iterable.generate(
        len, (_) => possible.codeUnitAt(random.nextInt(possible.length))));
  }

  getAuthTokens(String? code, String redirectUri) async {
    final base64Credential =
        utf8.fuse(base64).encode('$clientId:$clientSecretId');
    String accessTokenEndPoint = "https://accounts.spotify.com/api/token";
    final response = await http.post(
      Uri.parse(accessTokenEndPoint),
      body: {
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': redirectUri
      },
      headers: {
        //HttpHeaders.authorizationHeader: 'Basic $base64Credential'
        'Authorization': 'Basic $base64Credential',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final accessToken = responseBody['access_token'];
      final refreshTkn = responseBody['refresh_token'];
      print('Token from Spotify is $accessToken');

      HandlingLoggedInLoggedOut handlingLoggedInLoggedOut =
          HandlingLoggedInLoggedOut();
      await handlingLoggedInLoggedOut.updatingLoggedInOut(1);
      await handlingLoggedInLoggedOut.updatingToken(accessToken);
      await handlingLoggedInLoggedOut.updatingRefreshToken(refreshTkn);

      //getting refresh token after 50 minutes
      Future.delayed(Duration(minutes: 50), () async {
        print('updating refresh token ');
        await SpotifyApiServices()
            .requestRefreshToken(responseBody['refresh_token'], clientId, base64Credential);
      });

      Navigator.popAndPushNamed(cont, '/MyHomePage');
      //return accessToken;
    } else {
      throw Exception();
    }
  }
}



// response code 401 indicates that the token has expired hence we've to get a new token from the API.






