import 'package:courseriver/screens/CourseDetailByCategory.dart';
import 'package:flutter/material.dart';

Widget techCourses(BuildContext context,String image,String category) {
  return Padding(
    padding: const EdgeInsets.only(top: 5.0, left: 8.0),
    child: GestureDetector(
      onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CourseDetailsCategory(category:category)));
      },
      child: Container(
        width: 150,
        height: 150,
        child: CircleAvatar(radius: 60.0, backgroundImage: NetworkImage(image))),
    ),
  );
}

Widget techTextCourse(String name) {
  return Padding(
    padding: EdgeInsets.only(top: 10.0),
    child: Text(name,style: TextStyle(color: Colors.black),
    ),
  );
}
