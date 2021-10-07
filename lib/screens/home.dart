import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_by_ck/constants.dart';
import 'package:news_by_ck/screens/news%20screens/NewsFav.dart';
import 'package:news_by_ck/screens/news%20screens/NewsHome.dart';
import 'package:news_by_ck/screens/news%20screens/NewsSearch.dart';
import 'package:sizer/sizer.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? app_name = Constants.app_name;

  int _currentIndex = 0;

  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: app_appbar(),
      bottomNavigationBar: app_navbar(),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index){
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          NewsHome(),
          NewsSearch(),
          NewsFav()
        ],
      ),
      
    );
  }




  //navbar
  BottomNavyBar app_navbar() {
    return BottomNavyBar(
      backgroundColor: Colors.white,
      selectedIndex: _currentIndex,
      onItemSelected: (index){
        setState(() {
          _currentIndex = index;
          _pageController!.jumpToPage(index);
        });
      },
      items: [
        BottomNavyBarItem(
          activeColor: Constants.primary_color!,
          title: Text('Home'),
          icon: Icon(Icons.home_outlined)
        ),
        BottomNavyBarItem(
          activeColor: Constants.primary_color!,
          title: Text('Search'),
          icon: Icon(Icons.search_outlined)
        ),
        BottomNavyBarItem(
          activeColor: Constants.primary_color!,
          title: Text('Favourite'),
          icon: Icon(Icons.favorite_outline)
        ),
      ],
      );
  }

  AppBar app_appbar() {
    return AppBar(
      title: Text(
        app_name!,
        style: GoogleFonts.ubuntu(
          textStyle:TextStyle(
            fontSize: 20.sp
          )
        ),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            Navigator.pushNamed(context, '/login');
          }, icon: Icon(Icons.person_pin,size: 9.w,)),
          SizedBox(width: 1.w,)
        ],
    );
  }
}