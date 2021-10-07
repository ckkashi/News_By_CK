import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_by_ck/constants.dart';
import 'package:news_by_ck/screens/home.dart';
import 'package:news_by_ck/screens/shared/Loading.dart';
import 'package:news_by_ck/screens/splash.dart';
import 'package:news_by_ck/screens/user%20screens/login.dart';
import 'package:news_by_ck/screens/user%20screens/register.dart';
import 'package:news_by_ck/services/check_connectivity.dart';
import 'package:news_by_ck/services/fb_connectivity.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  // await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    String? app_name = Constants.app_name;
    return Sizer(

      builder: (context,orientation,deviceType){
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title:app_name!,
          theme: ThemeData(
            primarySwatch: Colors.red,
            iconTheme: IconThemeData(
              color: Colors.white
            )
          ),
          
          initialRoute: '/',
          routes: {
            '/':(context)=>Splash(),
            '/loading':(context)=>Loading(),
            '/chkconnectivity':(context)=>Check_connectivity(),
            '/home':(context)=>Home(),
            '/fbconnectivity':(context)=>Fb_connectivity(),
            '/login':(context)=>Login(),
            '/register':(context)=>Register(),
          },
        );
      },

    );
  }
}
