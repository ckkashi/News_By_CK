import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Loading extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        color: Colors.white.withOpacity(0.8),
        child:Center(child: CircularProgressIndicator(),),
        ),
      ),
      
    );
  }
}