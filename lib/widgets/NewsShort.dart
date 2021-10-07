import 'package:flutter/material.dart';
import 'package:news_by_ck/Models/News.dart';
import 'package:news_by_ck/Models/NewsModel.dart';
import 'package:news_by_ck/constants.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class NewsShort extends StatelessWidget {

  News data;
  NewsShort(this.data);
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");  
  var titleStyle = GoogleFonts.lato(
    textStyle:TextStyle(
      fontSize:14.sp,
      fontWeight: FontWeight.bold,
    )
  );

  var otherTextStyle = GoogleFonts.lato(
    textStyle:TextStyle(
      color: Constants.primary_color
    )
  );

  @override
  Widget build(BuildContext context) {
    print(data.toJson());
    String? date = data.publishedAt!.toString();
    DateTime formatDate = dateFormat.parse(date);
    return Container(
      width: 95.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.5),blurRadius: 2,spreadRadius: 1)
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0),bottomLeft: Radius.circular(5.0),),
                image:(data.urlToImage) != null ? DecorationImage(image: NetworkImage(data.urlToImage!.toString()),fit: BoxFit.cover):DecorationImage(image: AssetImage('assets/not-found.png'),fit: BoxFit.cover),
              ),
              height:15.h,
              // child: (data.image) == null ?Center(child: Text('No\nImage\nFound',textAlign: TextAlign.center,)):Image(image: NetworkImage(data.image!.toString()),fit: BoxFit.cover,),
            ) 
            ),
            Expanded(
            flex: 2,
            child: Container(
              decoration:BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(5.0),bottomRight: Radius.circular(5.0)),
                color: Colors.white,
              ),
              height: 15.h,
              
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 2 ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.title!.isNotEmpty?data.title!.toString():'not found',style: titleStyle,textAlign: TextAlign.left,maxLines: 3,),
                    // Text(data.source!.isNotEmpty?'Country : '+data.country!.toString():'not found',textAlign: TextAlign.left,style: otherTextStyle),
                    Text(data.publishedAt!.isNotEmpty?"Published : "+formatDate.toString():'not found',style: otherTextStyle),

                  ],
                ),
              ),
            )
            ),
        ],
      ),
    );
  }
}