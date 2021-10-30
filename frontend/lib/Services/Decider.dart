import 'package:courseriver/Services/Cache.dart';
import 'package:courseriver/screens/SplashScreen.dart';
import 'package:courseriver/widgets/BottomNavigator.dart';
import 'package:flutter/material.dart';

class Decider extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final Cache cache = Cache();
    return FutureBuilder(
      future: cache.readCache("jwt"),
       builder:(context,snapshot){
         if(snapshot.connectionState==ConnectionState.waiting){
           return SplashScreen();
         }else{
           if(snapshot.hasData){
             return BottomNavigationBarExample();
           }else{
             return BottomNavigationBarExample();
           }
         }

       } ,
    );
  }
}