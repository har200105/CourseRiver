import 'dart:async';
import 'package:courseriver/screens/HomeScreen.dart';
import 'package:courseriver/widgets/BottomNavigator.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
    void initState() {
      Timer(Duration(seconds: 4), ()=>{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomNavigationBarExample()))
      });
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(left:2.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left:80.0),
                child: Text(
                  "Course River",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 40.0
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top:5.0,left: 80.0),
                child: Text(
                  "Now Learn The Best !!",
                  style: TextStyle(
                    color: Colors.teal,
                    fontSize: 15.0
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}