import 'dart:async';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_by_ck/screens/shared/Loading.dart';
import 'package:news_by_ck/widgets/NewsDetail.dart';
import 'package:news_by_ck/widgets/NewsShort.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_by_ck/Models/News.dart';
import 'package:news_by_ck/Models/NewsModel.dart';
import 'package:news_by_ck/constants.dart';

class NewsHome extends StatefulWidget {
  const NewsHome({Key? key}) : super(key: key);

  @override
  _NewsHomeState createState() => _NewsHomeState();
}

class _NewsHomeState extends State<NewsHome> {
  List tab_colors = [Colors.white, Colors.yellowAccent];
  bool _popular_tab = false;
  bool _top_stories_tab = false;
  bool _sports_tab = false;
  bool _headlines_tab = false;
  bool _health_tab = false;
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
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _popular_tab = true;
      _keyword = 'https://newsapi.org/v2/everything?q=popular%language=en&sortBy=publishedAt&apiKey=$_apiKey';
    });
  }

  // News inst = News();

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
        top: 0,
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/background.jpg'),fit: BoxFit.cover)
          ),
          child:Container(
            width: 100.w,
            height: 100.h,
            color: Colors.white.withOpacity(0.8),
          )
        )
        ),
      Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 6.h,
            child: Container(
              width: 100.w,
              color: Constants.primary_color,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 4.w,
                    ),
                    TextButton(
                      child: Text(
                        'Popular',
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: _popular_tab ? tab_colors[0] : tab_colors[1],
                        )),
                      ),
                      onPressed: () {
                        setState(() {
                          _popular_tab = true;
                          _top_stories_tab = false;
                          _sports_tab = false;
                          _headlines_tab = false;
                          _health_tab = false;
                          // _keyword =
                          //     'http://api.mediastack.com/v1/news?access_key=$_apiKey&keywords=popular&languages=en';
                          _keyword = 'https://newsapi.org/v2/everything?q=popular%language=en&sortBy=publishedAt&apiKey=$_apiKey' ;
                          _loading = true;
                        });
                        Timer(Duration(seconds: 1), () {
                          setState(() {
                            _loading = false;
                          });
                        });
                      },
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    TextButton(
                      child: Text(
                        'Sports',
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: _sports_tab ? tab_colors[0] : tab_colors[1],
                        )),
                      ),
                      onPressed: () {
                        setState(() {
                          _popular_tab = false;
                          _top_stories_tab = false;
                          _sports_tab = true;
                          _headlines_tab = false;
                          _health_tab = false;
                          _keyword =
                              'https://newsapi.org/v2/everything?q=Sports%language=en&sortBy=publishedAt&apiKey=$_apiKey';
                          _loading = true;
                        });
                        Timer(Duration(seconds: 1), () {
                          setState(() {
                            _loading = false;
                          });
                        });
                      },
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    TextButton(
                      child: Text(
                        'Headlines',
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: _headlines_tab ? tab_colors[0] : tab_colors[1],
                        )),
                      ),
                      onPressed: () {
                        setState(() {
                          _popular_tab = false;
                          _top_stories_tab = false;
                          _sports_tab = false;
                          _headlines_tab = true;
                          _health_tab = false;
                          _keyword =
                              'https://newsapi.org/v2/top-headlines?language=en&apiKey=$_apiKey';
                          _loading = true;
                          //
                        });
                        Timer(Duration(seconds: 1), () {
                          setState(() {
                            _loading = false;
                          });
                        });
                      },
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    TextButton(
                      child: Text(
                        'Top Stories',
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color:
                              _top_stories_tab ? tab_colors[0] : tab_colors[1],
                        )),
                      ),
                      onPressed: () {
                        setState(() {
                          _popular_tab = false;
                          _top_stories_tab = true;
                          _sports_tab = false;
                          _headlines_tab = false;
                          _health_tab = false;
                          _keyword =
                              'https://newsapi.org/v2/everything?q=top-stories%language=en&sortBy=publishedAt&apiKey=$_apiKey';
                          _loading = true;
                        });
                        Timer(Duration(seconds: 1), () {
                          setState(() {
                            _loading = false;
                          });
                        });
                      },
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    TextButton(
                      child: Text(
                        'Health',
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: _health_tab ? tab_colors[0] : tab_colors[1],
                        )),
                      ),
                      onPressed: () {
                        setState(() {
                          _popular_tab = false;
                          _top_stories_tab = false;
                          _sports_tab = false;
                          _headlines_tab = false;
                          _health_tab = true;
                          _keyword =
                              'https://newsapi.org/v2/everything?q=health&sortBy=publishedAt&apiKey=$_apiKey';
                          _loading = true;
                        });
                        Timer(Duration(seconds: 1), () {
                          setState(() {
                            _loading = false;
                          });
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          )),
      Positioned(
        top: 6.h,
        left: 0,
        right: 0,
        bottom: 0,
        child: _loading
            ? Loading()
            : FutureBuilder<List<News>>(
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
    ]);
  }
}
