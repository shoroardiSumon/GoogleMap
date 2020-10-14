import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterMap/pages/google_map_home.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(milliseconds: 3000),(){
        Navigator.of(context).pushReplacement(CupertinoPageRoute(builder:(context) => GoogleMapHome()));
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Center(
              child: Icon(Icons.location_on, size: 130, color: Colors.green,),
            )
          ),
          Positioned(
            bottom: kToolbarHeight * 2,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Align(
                alignment: Alignment.center,
                child: Text("Google", style: TextStyle(color: Colors.grey[100], fontSize: 45),),
              ),
            ),
          ),
        ],
      )
    );
  }
}
