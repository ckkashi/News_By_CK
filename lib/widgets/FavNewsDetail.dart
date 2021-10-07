import 'dart:io';

import 'package:flutter/material.dart';
import 'package:news_by_ck/Models/FavNewsModel.dart';
import 'package:news_by_ck/Models/News.dart';
import 'package:news_by_ck/Models/NewsModel.dart';
import 'package:news_by_ck/constants.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class FavNewsDetail extends StatelessWidget {
  FavNewsModel data;
  FavNewsDetail(this.data);

  String? app_name = Constants.app_name;
  final auth = FirebaseAuth.instance;

  Future delFavNews(BuildContext context) async {
    Uri uri = Uri.parse('https://news-by-ck-server.herokuapp.com/favNews/deleteFavNews');
    var res = await http.post(uri, body: {
      
        "docId":data.docId.toString()
      
    }, headers: {
      "Accept": "application/json",
      "Access_Control_Allow_Origin": "*"
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text(res.body.toString())));
  }

  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  var titleStyle = GoogleFonts.lato(
      textStyle: TextStyle(
    fontSize: 17.sp,
    fontWeight: FontWeight.bold,
  ));

  var h2style = GoogleFonts.lato(
      textStyle: TextStyle(
    fontSize: 15.sp,
    color: Constants.primary_color,
    fontWeight: FontWeight.bold,
  ));

  var h3style = GoogleFonts.lato(
      textStyle: TextStyle(
    fontSize: 11.sp,
    color: Constants.primary_color,
    fontWeight: FontWeight.bold,
  ));

  var otherTextStyle = GoogleFonts.lato(
      textStyle:
          TextStyle(color: Colors.black.withOpacity(0.8), fontSize: 14.sp));

  @override
  Widget build(BuildContext context) {
    String? date = data.publishedAt!.toString();
    DateTime formatDate = dateFormat.parse(date);
    return Scaffold(
      appBar: detail_appbar(context),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
        child: Container(
          width: 100.w,
          height: 100.h,
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.5),
              image: DecorationImage(
                  image: AssetImage('assets/background.jpg'),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5.0),
                topRight: Radius.circular(5.0),
              )),
          child: Container(
            width: 100.w,
            height: 100.h,
            color: Colors.white.withOpacity(0.8),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 40.h,
                      decoration: BoxDecoration(
                          image: (data.urlToImage) != null
                              ? DecorationImage(
                                  image:
                                      NetworkImage(data.urlToImage!.toString()),
                                  fit: BoxFit.cover)
                              : DecorationImage(
                                  image: AssetImage('assets/not-found.png'),
                                  fit: BoxFit.cover),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ))),
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 2.h,
                        ),
                        Text(
                          data.title!.isNotEmpty
                              ? data.title!.toString()
                              : 'not found',
                          style: titleStyle,
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Text(
                          'News Content',
                          style: h2style,
                        ),
                        Text(
                          data.content!.isNotEmpty
                              ? data.content!.toString()
                              : 'not found',
                          style: otherTextStyle,
                          textAlign: TextAlign.left,
                          maxLines: 10,
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Text(
                          'News Description',
                          style: h2style,
                        ),
                        Text(
                          data.description!.isNotEmpty
                              ? data.description!.toString()
                              : 'not found',
                          style: otherTextStyle,
                          textAlign: TextAlign.left,
                          maxLines: 10,
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Text(
                          'Published at ',
                          style: h3style,
                        ),
                        Text(
                          data.publishedAt!.isNotEmpty
                              ? formatDate.toString()
                              : 'not found',
                          style: otherTextStyle,
                          textAlign: TextAlign.right,
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Text(
                          'Author ',
                          style: h3style,
                        ),
                        Text(
                          (data.author) != null
                              ? data.author!.toString()
                              : 'Author : not found',
                          style: otherTextStyle,
                          textAlign: TextAlign.left,
                          maxLines: 10,
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Text(
                          'News Refrence url ',
                          style: h3style,
                        ),
                        Text(
                          (data.url) != null
                              ? data.url!.toString()
                              : 'News Refrence url : not found',
                          style: otherTextStyle,
                          textAlign: TextAlign.left,
                          maxLines: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar detail_appbar(BuildContext context) {
    return AppBar(
      title: Text(
        app_name!,
        style: GoogleFonts.ubuntu(textStyle: TextStyle(fontSize: 20.sp)),
      ),
      centerTitle: true,
      actions: [
        // IconButton(onPressed: () {
    
        //     // delFavNews(context);
         
        // }, icon: Icon(Icons.favorite))
      ],
    );
  }
}
