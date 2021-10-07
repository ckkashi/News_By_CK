import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:news_by_ck/screens/user%20screens/UserHome.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../constants.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  final emailCon = TextEditingController();

  final passCon = TextEditingController();

  bool _isUserLogin = false;

  bool _isLoading = false;

  var icons = [Icons.email, Icons.password];
  String? app_name = Constants.app_name;
  FirebaseAuth auth = FirebaseAuth.instance;
  // Map<String, dynamic>? userInfo;
  // Future getUserData(String uId) async {
  //   Uri apiUrl = Uri.parse('http://192.168.0.117:3000/user/getUserInfo');
  //   var res = await http.post(apiUrl, body: {
  //     "userId": uId.toString()
  //   }, headers: {
  //     "Accept": "application/json",
  //     "Access_control_Allow_Origin": "*"
  //   });
  //   var jsonRes = jsonDecode(res.body);
  //   setState(() {
  //     userInfo = jsonRes[0];
  //   });
  // }

  Future chkUser() async {
    auth.idTokenChanges().listen((User? user) {
      if (user == null) {
        setState(() {
          _isUserLogin = false;
        });
      } else {
        setState(() {
          _isUserLogin = true;
        });
      }
    });
  }

  loginUser(String email, String pass) async {
    try {
      print(email + pass);
      UserCredential userData =
          await auth.signInWithEmailAndPassword(email: email, password: pass);
      User? user = auth.currentUser;
      if (auth.currentUser != null) {
        // await getUserData(userData.user!.uid);
        // print(userInfo);
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            content: Text('Login Successfully')));
        print({"userID": userData.user!.uid});
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red, content: Text('Login Error.')));
      }
      emailCon.text = '';
      passCon.text = '';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text('User not found for this email.')));
      } else if (e.code == 'wrong-password') {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red, content: Text('Incorrect password.')));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: chkUser(),
        builder: (context, snapshot) {
          return _isUserLogin
              ? UserHome()
              : Scaffold(
                  appBar: AppBar(
                    title: Text(
                      app_name!,
                      style: GoogleFonts.ubuntu(
                          textStyle: TextStyle(fontSize: 20.sp)),
                    ),
                    centerTitle: true,
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
                      child: Stack(
                        children: [
                          Positioned(
                              top: 0,
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                width: 100.w,
                                height: 100.h,
                                child: Form(
                                  key: _formKey,
                                  child: Center(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 5.w,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 6),
                                                child: Text(
                                                  'Login',
                                                  style: GoogleFonts.ubuntu(
                                                      textStyle: TextStyle(
                                                          fontSize: 38.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Constants
                                                              .primary_color!
                                                              .withOpacity(
                                                                  0.7))),
                                                ),
                                              )
                                            ],
                                          ),
                                          dataField(
                                            con: emailCon,
                                            obscure: false,
                                            fieldName: 'Email',
                                            icon: icons[0],
                                          ),
                                          dataField(
                                            con: passCon,
                                            obscure: true,
                                            fieldName: 'Password',
                                            icon: icons[1],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 0, horizontal: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        fixedSize:
                                                            Size(30.w, 7.h),
                                                        primary: Constants
                                                            .primary_color!
                                                        /*.withOpacity(
                                                                    0.7)*/
                                                        ),
                                                    onPressed: () {
                                                      String email = emailCon
                                                          .text
                                                          .toString();
                                                      String pass = passCon.text
                                                          .toString();
                                                      if (email == '') {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(SnackBar(
                                                                backgroundColor:
                                                                    Colors.red,
                                                                content: Text(
                                                                    'Fill all fields.')));
                                                      } else {
                                                        if (pass == '') {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(SnackBar(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  content: Text(
                                                                      'Fill all fields.')));
                                                        } else {
                                                          setState(() {
                                                            _isLoading = true;
                                                          });
                                                          loginUser(
                                                              email, pass);
                                                        }
                                                      }
                                                    },
                                                    child: _isLoading
                                                        ? Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          )
                                                        : Text(
                                                            'Login',
                                                            style: GoogleFonts.ubuntu(
                                                                textStyle: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        16.sp)),
                                                          ))
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                          Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                width: 100.w,
                                height: 8.h,
                                // color: Colors.black,
                                child: Column(
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, '/register');
                                        },
                                        child: Text(
                                          'Create Account?',
                                          style: GoogleFonts.ubuntu(
                                              textStyle: TextStyle(
                                            color: Constants.primary_color,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                          )),
                                        )),
                                  ],
                                ),
                              ))
                        ],
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
      required this.icon})
      : super(key: key);

  final TextEditingController con;
  final bool obscure;
  final String fieldName;
  final icon;

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
        style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 23.sp)),
        decoration: InputDecoration(
            suffixIcon: Icon(
              icon,
              color: Constants.primary_color!,
            ),
            contentPadding: EdgeInsets.all(15),
            labelText: 'Enter $fieldName',
            labelStyle:
                TextStyle(color: Constants.primary_color!, fontSize: 16.sp),
            border: outlineInputBorder2,
            focusedBorder: outlineInputBorder),
        obscureText: obscure,
      ),
    );
  }
}
