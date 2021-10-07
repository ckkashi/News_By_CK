import 'dart:io';
import 'package:flutter/material.dart';
import 'package:news_by_ck/screens/user%20screens/UserHome.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();

  final emailCon = TextEditingController();
  final passCon = TextEditingController();
  final usernameCon = TextEditingController();
  final userAddressCon = TextEditingController();
  final userContactCon = TextEditingController();

  bool _ep = false;

  bool _isLoading = false;

  String _imageName = 'no image selected';
  String path = '';

  var icons = [Icons.email, Icons.password];
  String? app_name = Constants.app_name;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future userInfoAdd(Map<String, dynamic> data,BuildContext context) async {
    Uri apiUrl = Uri.parse('https://news-by-ck-server.herokuapp.com/user/addUserInfo');
    var response = await http.post(apiUrl, 
    body: data, 
    headers: {
      "Accept": "application/json",
      "Access_Control_Allow_Origin": "*"
    });
    print({"status code":response.statusCode});
    print({"response body":response.body});
    auth.signOut();
    Navigator.pop(context);
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(""+response.body)));
  }

  RegisterUser(Map<String, dynamic> data, BuildContext context) async {
    try {
      print(data["email"] + data["password"]);
      UserCredential userData = await auth.createUserWithEmailAndPassword(
          email: data["email"], password: data["password"]);
      data["userId"] = userData.user!.uid.toString();
      firebase_storage.FirebaseStorage storage =
          firebase_storage.FirebaseStorage.instance;
      firebase_storage.Reference ref = storage.ref('/$_imageName');
      File file = File(path);
      await ref.putFile(file);
      String imgUrl = await ref.getDownloadURL();
      print(imgUrl);
      data["userProfileUrl"] = imgUrl;
      userInfoAdd(data,context);
      User? user = auth.currentUser;
      if (auth.currentUser != null) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            content: Text('Register Successfully')));
        print({"userID": userData.user!.uid});
        Navigator.pop(context);
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red, content: Text('Register Error.')));
      }

      setState(() {
        emailCon.text = '';
        passCon.text = '';
        usernameCon.text = '';
        userAddressCon.text = '';
        userContactCon.text = '';
        _imageName = '';
        path = '' ;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        
      });
      if (e.code == 'email-already-in-use') {
        setState(() {
        _ep = false;
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text('User already registered for this email.')));
      } else if (e.code == 'weak-password') {
        setState(() {
          _ep = false;
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red, content: Text('Password is weak.')));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        // future: chkUser(),
        builder: (context, snapshot) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            app_name!,
            style: GoogleFonts.ubuntu(textStyle: TextStyle(fontSize: 20.sp)),
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
                            child: Visibility(
                              child: _ep
                                  ? otherInfoFields(context)
                                  : epFields(context),
                            ),
                          ),
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ),
      );
    });
  }

  Column epFields(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 5.w,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 6),
              child: Text(
                'Register',
                style: GoogleFonts.ubuntu(
                    textStyle: TextStyle(
                        fontSize: 38.sp,
                        fontWeight: FontWeight.bold,
                        color: Constants.primary_color!.withOpacity(0.7))),
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
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(30.w, 7.h),
                      primary: Constants.primary_color!
                      /*.withOpacity(
                                                                    0.7)*/
                      ),
                  onPressed: () {
                    String email = emailCon.text.toString();
                    String pass = passCon.text.toString();
                    if (email == '') {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Fill all fields.')));
                    } else {
                      if (pass == '') {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                            content: Text('Fill all fields.')));
                      } else {
                        setState(() {
                          // _isLoading = true;
                          _ep = true;
                        });
                        // RegisterUser(email, pass);

                      }
                    }
                  },
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : Icon(Icons.arrow_forward_ios))
            ],
          ),
        )
      ],
    );
  }

  Column otherInfoFields(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 2.w,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2),
              child: Text(
                'Other Information',
                style: GoogleFonts.ubuntu(
                    textStyle: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.bold,
                        color: Constants.primary_color!.withOpacity(0.7))),
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  flex: 2,
                  child: Text(
                    _imageName,
                    style: TextStyle(fontSize: 15.sp),
                  )),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                    onPressed: () async {
                      var img =
                          await _picker.pickImage(source: ImageSource.gallery);
                      setState(() {
                        path = img!.path.toString();
                        _imageName = basename(path);
                      });
                    },
                    child: Text('choose image')),
              )
            ],
          ),
        ),
        dataField(
          con: usernameCon,
          obscure: false,
          fieldName: 'Username',
          icon: Icons.person,
        ),
        dataField(
          con: userAddressCon,
          obscure: false,
          fieldName: 'User Address',
          icon: Icons.place,
        ),
        dataField(
          con: userContactCon,
          obscure: false,
          fieldName: 'User Contact',
          icon: Icons.phone,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(30.w, 7.h),
                      primary: Constants.primary_color!
                      /*.withOpacity(
                                                                    0.7)*/
                      ),
                  onPressed: () {
                    if (_imageName == 'no image selected') {
                      print('pls select image');
                    } else {
                      if (_imageName == '') {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                            content: Text('Please Select Image')));
                      } else {
                        // setState(() {
                        //     _isLoading = true;
                        //   });
                        //   RegisterUser(emailCon.text, passCon.text,context);
                        String username = usernameCon.text.toString();
                        String address = userAddressCon.text.toString();
                        String contact = userContactCon.text.toString();
                        if (username == '') {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.red,
                              content: Text('Fill all fields.')));
                        } else {
                          if (address == '') {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.red,
                                content: Text('Fill all fields.')));
                          } else {
                            if (contact == '') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text('Fill all fields.')));
                            } else {
                              setState(() {
                                _isLoading = true;
                              });
                              Map<String, dynamic> data = {
                                "email": emailCon.text.toString(),
                                "password": passCon.text.toString(),
                                "userId": "",
                                "username": usernameCon.text.toString(),
                                "userContact": userContactCon.text.toString(),
                                "userAddress": userAddressCon.text.toString(),
                                "userProfileUrl": "",
                                "userPaymentDetail": ""
                              };
                              RegisterUser(data, context);
                            }
                          }
                        }
                      }
                    }
                  },
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Register',
                          style: GoogleFonts.ubuntu(
                              textStyle: TextStyle(
                                  color: Colors.white, fontSize: 16.sp)),
                        ))
            ],
          ),
        )
      ],
    );
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
