import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:news_by_ck/Models/News.dart';
import 'package:news_by_ck/widgets/NewsDetail.dart';
import 'package:news_by_ck/widgets/NewsShort.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';

class NewsSearch extends StatefulWidget {

  @override
  _NewsSearchState createState() => _NewsSearchState();
}

class _NewsSearchState extends State<NewsSearch> {
  final searchController = TextEditingController();

  DateTime? date;

  String dd = '';

  bool _loading = false;
  String? _keyword = '';
  var _apiKey = Constants.apiKey;

  Future<List<News>> getData(String _kword) async {
    List<News> lst = [];

    try {
      // var _keyword = _kword;
      // var _apiKey = Constants.apiKey;
      // Uri url = Uri.parse('https://newsapi.org/v2/everything?q=keyword&apiKey=a349274279c14e95b0db61535a938c20');
      Uri url = Uri.parse(_kword);
      var response = await http.get(url);
      var jsonRes = jsonDecode(response.body);
      // print(response);
      // print(jsonRes);
      for (var item in jsonRes['articles']) {
        lst.add(News.fromJson(item));
      }
    } catch (e) {
      print(e);
    }
    return lst;
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
         child: Padding(
           padding: const EdgeInsets.only(left: 8,right: 8,top: 10,bottom: 0),
           child: Stack(
             children: [
               Positioned(
                 top: 1.h,
                 left: 0,
                 right: 0,
                 child: Container(
                   padding:EdgeInsets.symmetric(horizontal: 2.0,vertical: 4),
                   width: 100.w,
                   height: 7.5.h,
                   decoration:BoxDecoration(
                     borderRadius: BorderRadius.circular(5.0),
                     boxShadow: [
                       BoxShadow(
                         color: Colors.grey,
                         blurRadius:2,
                         spreadRadius: 1
                       )
                     ],
                     color: Colors.white
                   ),
                   child:TextField(
                     controller: searchController,
                     style: GoogleFonts.lato(
                       textStyle:TextStyle(
                         fontSize: 15.sp,
                       ),
                     ),
                     decoration: InputDecoration(
                       border: InputBorder.none,
                       hintText:'Search',
                       prefixIcon: IconButton(onPressed: (){
                         print('date btn');
                         DatePicker.showDatePicker(
                           context,
                           showTitleActions: true,
                          //  minTime: DateTime(DateTime.now().year),
                          //  maxTime: DateTime(1-01-2021),
                          //  theme: DatePickerTheme(),
                           onConfirm: (date){
                            this.dd = date.year.toString()+"-"+date.month.toString()+"-"+date.day.toString();
                            print(this.dd.toString());
                           }
                         );
                       }, icon: Icon(Icons.date_range_outlined)),
                      suffixIcon: IconButton(onPressed: (){
                         print('search btn');
                         setState(() {
                           _loading = true ;
                         });
                         Timer(Duration(seconds:1), (){
                           setState(() {
                             _loading = false;
                           });
                         });
                         if(this.dd.isEmpty){
                           if(searchController.text.isNotEmpty){
                             setState(() {
                               String _search_kword = searchController.text;
                               _keyword = 'https://newsapi.org/v2/everything?q=$_search_kword&sortBy=publishedAt&apiKey=$_apiKey';
                             });
                           }
                         }else{
                           print(this.dd.toString());
                           if(searchController.text.isNotEmpty){
                             setState(() {
                               String _search_date = this.dd.toString();
                               String _search_kword = searchController.text;
                               _keyword = 'https://newsapi.org/v2/everything?q=$_search_kword&from=$_search_date&sortBy=publishedAt&apiKey=$_apiKey';
                             });
                           }
                         }
                       }, icon: Icon(Icons.search)),
                     ),
                   ),
                 ),
                 ),
                Positioned(
                 top: 9.h,
                 left: 0,
                 right: 0,
                 bottom: 0,
                 child: Container(
                   width: 100.w,
                  //  height: 8.h,
                   color: Colors.transparent,
                   child:_loading? Center(child: CircularProgressIndicator(),) :FutureBuilder<List<News>>(
                future: getData(_keyword!),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Something went wrong'),
                    );
                  }
                  print({'length': snapshot.data.length});
                  return 
                  ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        // return ListTile(
                        //   title: Text(snapshot.data[index].title),
                        // );
                        return GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context)=>NewsDetail(snapshot.data[index]))
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: NewsShort(snapshot.data[index]),
                          ),
                        );
                      });
                }),
                 ),
                 ),
             ],
           ),
         ),
       ),
    );
  }
}