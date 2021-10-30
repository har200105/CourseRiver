import 'package:courseriver/screens/CourseDetail.dart';
import 'package:flutter/material.dart';

Widget trendingCourses(BuildContext context , String image,String name,String channelName,String id){
  return Padding(
    padding: EdgeInsets.all(5.0),
    child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
    padding: const EdgeInsets.only(top: 2.0, left: 8.0),
    child: GestureDetector(
      onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CourseDetails(id: id,)));
      },
      child: CircleAvatar(radius: 55.0, backgroundImage: NetworkImage(image)),
    ),
  ),
  Padding(
    padding: EdgeInsets.only(top: 10.0),
    child: Text(
      name,
      style: TextStyle(color: Colors.black),
    ),
  ),

   Padding(
    padding: EdgeInsets.only(top: 3.0),
    child: Text(
      channelName,
      style: TextStyle(color: Colors.black),
    ),
  )
        ],
      ),
    ),
  );
}