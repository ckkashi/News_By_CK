import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:news_by_ck/screens/home.dart';
import 'package:news_by_ck/screens/shared/Loading.dart';

class Fb_connectivity extends StatefulWidget {
  const Fb_connectivity({ Key? key }) : super(key: key);

  @override
  _Fb_connectivityState createState() => _Fb_connectivityState();
}

class _Fb_connectivityState extends State<Fb_connectivity> {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Center(child: Text('Some thing went wrong'),);
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return Home();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Loading();
      },
    );
  }
}