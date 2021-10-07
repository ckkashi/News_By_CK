import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_by_ck/constants.dart';
import 'package:sizer/sizer.dart';

class Splash extends StatefulWidget {
  const Splash({ Key? key }) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
 
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3), ()=>Navigator.pushReplacementNamed(context, '/chkconnectivity'));
  }
 
  @override
  Widget build(BuildContext context) {
    String? app_name = Constants.app_name!; 
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: 100.w,
          height: 100.h,
          decoration: BoxDecoration(
            image: DecorationImage(fit: BoxFit.cover,image: AssetImage(
              'assets/background.jpg',
              
              )),
          ),
          child:Container(
          width: 100.w,
          height: 100.h,
          color: Colors.white.withOpacity(0.75),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.home_work_outlined,
                  color: Colors.red[700],
                  size: 18.h,
                ),
                Text(
                  'NEWS\nBY CK',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      color: Colors.red[700],
                      fontSize: Constants.b_heading_size!,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3.sp
                    )
                  ),
                ),
                SizedBox(height: 4.h,),
                Container(
                  width: 12.h,
                  height: 12.h,
                  // color: Colors.white,
                  child: SpinKitFoldingCube(
                    color: Constants.primary_color,
                    size: 8.h,
                  ),
                )
              ],
            ),
          ),
          ),
        ),
      ),
    );
  }
}