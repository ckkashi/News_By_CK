import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_by_ck/screens/shared/Loading.dart';
import 'package:news_by_ck/screens/user%20screens/login.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';

class UserHome extends StatefulWidget {
  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  String? app_name = Constants.app_name;

  FirebaseAuth auth = FirebaseAuth.instance;
  List resList = [];

  String chkFieldMsg = '';

  final _formKey = GlobalKey<FormState>();

  final usernameCon = TextEditingController();
  final userAddressCon = TextEditingController();
  final userContactCon = TextEditingController();
  final newUsernameCon = TextEditingController();
  final newUserAddressCon = TextEditingController();
  final newUserContactCon = TextEditingController();
  bool _loading = false;
  bool _fieldEnabled = true;
  String docId = '';
  bool _validate = false;

  Map<String, dynamic> userInfo = {};

  Future getUserData(String uId) async {
    Uri apiUrl = Uri.parse('https://news-by-ck-server.herokuapp.com/user/getUserInfo');
    var res = await http.post(apiUrl, body: {
      "userId": uId.toString()
    }, headers: {
      "Accept": "application/json",
      "Access_control_Allow_Origin": "*"
    });
    var jsonRes = jsonDecode(res.body);
    print(jsonRes);
    for (var item in jsonRes) {
      resList.add(item);
    }
    setState(() {
      userInfo = jsonRes[0];
      print(userInfo);
    });
    return resList;
  }

  Future updateUserData() async{
    Uri apiUrl = Uri.parse('https://news-by-ck-server.herokuapp.com/user/updateUserInfo');
    var res = await http.put(
      apiUrl,
      body: {
        "userId":auth.currentUser!.uid,
        "username":newUsernameCon.text,
        "userAddress":newUserAddressCon.text,
        "userContact":newUserContactCon.text
      },
      headers: {
        "Accept":"application/json",
        "Access_Control_Allow_Origin":"*"
      }
      );
      Navigator.pop(context);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.body.toString()),backgroundColor: Constants.primary_color,));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _loading = true;
    });
    getUserData(auth.currentUser!.uid);
    Timer(Duration(seconds: 5), () {
      setState(() {
        _loading = false;
      });
    });
  }

  // runMet() async{
  //   await getUserData(auth.currentUser!.uid);
  // }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Loading()
        : FutureBuilder(
            // future: getUserData(auth.currentUser!.uid),
            builder: (context, AsyncSnapshot snapshot) {
                usernameCon.text = userInfo["username"].toString();
              userContactCon.text = userInfo["userContact"].toString();
              userAddressCon.text = userInfo["userAddress"].toString();
              // print(userInfo["userContact"].toString());
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    "User - " + app_name!,
                    style: GoogleFonts.ubuntu(
                        textStyle: TextStyle(fontSize: 20.sp)),
                  ),
                  centerTitle: true,
                  actions: [
                    IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Logout'),
                                  content: Text('Are you sure?'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          auth.signOut();
                                          Navigator.pop(context);
                                        },
                                        child: Text('Yes')),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('No')),
                                  ],
                                );
                              });
                        },
                        icon: Icon(Icons.logout))
                  ],
                ),
                body: Container(
                  width: 100.w,
                  height: 100.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          'assets/background.jpg',
                        )),
                  ),
                  child: Container(
                    width: 100.w,
                    height: 100.h,
                    color: Colors.white.withOpacity(0.8),
                    child: Container(
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  foregroundImage:NetworkImage(userInfo
                                            ["userProfileUrl"]
                                        .toString()),
                                  backgroundImage:AssetImage('assets/not-found.png'),
                                  // (userInfo["userProfileUrl"]) != null ? DecorationImage(image: NetworkImage(data.urlToImage!.toString()),fit: BoxFit.cover):DecorationImage(image: AssetImage('assets/not-found.png'),fit: BoxFit.cover),
                                  
                                  radius: 12.h,
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              dataField(
                                  con: usernameCon,
                                  obscure: false,
                                  fieldName: 'Username',
                                  icon: Icons.person,
                                  enabled: _fieldEnabled,),
                              SizedBox(
                                height: 2.h,
                              ),
                              dataField(
                                  con: userContactCon,
                                  obscure: false,
                                  fieldName: 'User Contact',
                                  icon: Icons.phone,
                                  enabled: _fieldEnabled,),
                                  SizedBox(
                                height: 2.h,
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              dataField(
                                  con: userAddressCon,
                                  obscure: false,
                                  fieldName: 'User Contact',
                                  icon: Icons.home,
                                  enabled: _fieldEnabled,),
                              TextButton(onPressed: (){
                                showModalBottomSheet(context: context, 
                                isScrollControlled: true,
                                builder: (BuildContext context){
                                  return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child:   Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            SizedBox(height:5.h),
                                            Text('Edit Profile',style: GoogleFonts.ubuntu(
                                              textStyle:TextStyle(
                                                fontSize: 30.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Constants.primary_color,
                                              )
                                            ),),
                                            SizedBox(height:2.h),
                                            dataField1(con: newUsernameCon, obscure: false, fieldName: 'Enter new username', icon: Icons.person, enabled: _fieldEnabled,),
                                            dataField1(con: newUserContactCon, obscure: false, fieldName: 'Enter new contact no', icon: Icons.phone, enabled: _fieldEnabled,),
                                            dataField1(con: newUserAddressCon, obscure: false, fieldName: 'Enter new user address', icon: Icons.home, enabled: _fieldEnabled,),
                                            SizedBox(height: 1.h,),
                                            Text(chkFieldMsg),
                                            SizedBox(height:1.h),
                                            ElevatedButton(onPressed: (){
                                              if(newUsernameCon.text == ''){
                                                setState(() {
                                                  chkFieldMsg = 'Fill all fields' ;
                                                });
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all fields'),backgroundColor: Constants.primary_color,));
                                              }else{
                                                if(newUserAddressCon.text == ''){
                                                setState(() {
                                                  chkFieldMsg = 'Fill all fields' ;
                                                });
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all fields'),backgroundColor: Constants.primary_color,));
                                              }else{
                                                if(newUserContactCon.text == ''){
                                                  setState(() {
                                                  chkFieldMsg = 'Fill all fields' ;
                                                });
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all fields'),backgroundColor: Constants.primary_color,));
                                              }else{
                                                setState(() {
                                                  chkFieldMsg = '' ;
                                                });
                                                updateUserData();
                                              }
                                              }
                                              }
                                            }, child: Text(
                                              'Update Profile',
                                              style: GoogleFonts.ubuntu(
                                                textStyle: TextStyle(
                                                  fontSize: 16.sp
                                                )
                                              ),
                                              ))
                                          ],
                                        ),
                                      
                                    );
                                  
                                },);
                              }, child: Text('Edit Profile')),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            });
  }
}

class dataField extends StatelessWidget {
  const dataField(
      {Key? key,
      required this.con,
      required this.obscure,
      required this.fieldName,
      required this.icon,
      required this.enabled})
      : super(key: key);

  final TextEditingController con;
  final bool obscure;
  final String fieldName;
  final icon;
  final bool enabled;
  

  @override
  Widget build(BuildContext context) {
    var outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.0),
      borderSide: BorderSide(color: Constants.primary_color!, width: 2),
    );
    var outlineInputBorder2 = OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.0),
      borderSide: BorderSide(color: Constants.primary_color!, width: 1),
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        
        controller: con,
        cursorColor: Constants.primary_color!,
        enabled: true,
        style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 23.sp)),
        decoration: InputDecoration(
            // errorText: enabled?'Value Can\'t Be Empty' : null,
            suffixIcon: Icon(
              icon,
              color: Constants.primary_color!,
            ),
            contentPadding: EdgeInsets.all(15),
            labelText: '$fieldName',
            labelStyle:
                TextStyle(color: Constants.primary_color!, fontSize: 16.sp),
            border: outlineInputBorder2,
            focusedBorder: outlineInputBorder),
        obscureText: obscure,
      ),
    );
  }
}

class dataField1 extends StatelessWidget {
  const dataField1(      {Key? key,
      required this.con,
      required this.obscure,
      required this.fieldName,
      required this.icon,
      required this.enabled})
      : super(key: key);

  final TextEditingController con;
  final bool obscure;
  final String fieldName;
  final icon;
  final bool enabled;

  @override
  Widget build(BuildContext context) {

    var outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.0),
      borderSide: BorderSide(color: Constants.primary_color!, width: 2),
    );
    var outlineInputBorder2 = OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.0),
      borderSide: BorderSide(color: Constants.primary_color!, width: 1),
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: con,
        cursorColor: Constants.primary_color!,
        enabled: true,
        style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 23.sp)),
        decoration: InputDecoration(
            // errorText: fieldError?'Value Can\'t Be Empty' : null,
            suffixIcon: Icon(
              icon,
              color: Constants.primary_color!,
            ),
            contentPadding: EdgeInsets.all(15),
            labelText: '$fieldName',
            labelStyle:
                TextStyle(color: Constants.primary_color!, fontSize: 16.sp),
            border: outlineInputBorder2,
            focusedBorder: outlineInputBorder),
        obscureText: obscure,
      ),
    );
  }
}
