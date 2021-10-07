import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:news_by_ck/constants.dart';

class Check_connectivity extends StatefulWidget {

  @override
  _Check_connectivityState createState() => _Check_connectivityState();
}

class _Check_connectivityState extends State<Check_connectivity> {
  bool _isConnection = false;

  chkConnection()async{
    var connectivity_result = await (Connectivity().checkConnectivity());
    if(connectivity_result == ConnectivityResult.none){
      setState(() {
        _isConnection = false;
      });
    }else{
      setState(() {
        _isConnection = true;
      });
      Navigator.pushReplacementNamed(context, '/fbconnectivity');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chkConnection();
  }

  @override
  Widget build(BuildContext context) {
    // if(_isConnection ==true){
    //   Navigator.pushReplacementNamed(context, '/home');
    // }
    return Scaffold(
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('No network found.'),
          ElevatedButton(onPressed: (){
            Navigator.pushReplacementNamed(context, '/chkconnectivity');
          },
          style: ElevatedButton.styleFrom(
            primary: Constants.primary_color
          ),
          child: Text('Retry'))
        ],
      )),
    );
  }
}