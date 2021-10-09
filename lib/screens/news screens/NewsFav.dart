import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:news_by_ck/Models/FavNewsModel.dart';
import 'package:news_by_ck/constants.dart';
import 'package:news_by_ck/screens/shared/Loading.dart';
import 'package:news_by_ck/widgets/FavNewsDetail.dart';
import 'package:news_by_ck/widgets/FavNewsShort.dart';
import 'package:news_by_ck/widgets/NewsDetail.dart';
import 'package:news_by_ck/widgets/NewsShort.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
class NewsFav extends StatefulWidget {
  @override
  _NewsFavState createState() => _NewsFavState();
}


class _NewsFavState extends State<NewsFav> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool _isUserLogin = false;
  bool _isLoading = false;
  bool _nothing_found = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  
  Future<List<FavNewsModel>> getFavNews() async{
    List<FavNewsModel> favNewsList = [] ;
    try{
      // https://news-by-ck-server.herokuapp.com/
      // Uri uri = Uri.parse('http://192.168.0.117:3000/favNews/getFavNews');
      Uri uri = Uri.parse('https://news-by-ck-server.herokuapp.com/favNews/getFavNews');
    var res = await http.post(
      uri,
      body:{
        "userId": auth.currentUser!.uid
      }
    );
    var jsonRes = jsonDecode(res.body);
    print(jsonRes);
    for (var item in jsonRes) {
        favNewsList.add(FavNewsModel.fromJson(item));
    }
    }catch(e){
      print(e);
    }
  return favNewsList ;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
    width: 100.w,
    height: 100.h,
    decoration: BoxDecoration(
      image: DecorationImage(image: AssetImage('assets/background.jpg'),fit: BoxFit.cover),
    ),
     child:Container(
       width: 100.w,
       height: 100.h,
       color: Colors.white.withOpacity(0.8),
       child: Center(child:auth.currentUser==null?notLoginWidget():_nothing_found?notFoundWidget():favNewsArea(),
       ),
     ),
  );
  }

  Container favNewsArea() => Container(
    child: FutureBuilder<List<FavNewsModel>>(
      future: getFavNews(),
      builder: (context,AsyncSnapshot snapshot){
        
        if(!snapshot.hasData) return Loading(); 
        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder:  (context, index) {
                        if(!snapshot.hasData){
                          setState(() {
                            _nothing_found = true;
                          });
                        }
                        // return ListTile(
                        //   title: Text(snapshot.data[index].title),
                        // );
                        return GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context)=>FavNewsDetail(snapshot.data[index]))
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FavNewsShort(snapshot.data[index]),
                          ),
                        );
                      });
      }),
  );

  Column notLoginWidget() {
    return Column(
       mainAxisAlignment: MainAxisAlignment.center,
       children: [
        Icon(Icons.person_off,size: 20.w,color: Constants.primary_color,),
        SizedBox(height: 2.h,),
        Text(
          'User is not login',
          style: GoogleFonts.ubuntu(
            textStyle:TextStyle(
              color: Constants.primary_color,
              fontSize: 20.sp,
              fontWeight: FontWeight.normal
            )
          ),
        )
       ],
     );
  }

  Column notFoundWidget() {
    return Column(
       mainAxisAlignment: MainAxisAlignment.center,
       children: [
        Icon(Icons.not_interested,size: 20.w,color: Constants.primary_color,),
        SizedBox(height: 2.h,),
        Text(
          'Nothing Found',
          style: GoogleFonts.ubuntu(
            textStyle:TextStyle(
              color: Constants.primary_color,
              fontSize: 20.sp,
              fontWeight: FontWeight.normal
            )
          ),
        )
       ],
     );
  }

}