import 'package:courseriver/API/Course.dart';
import 'package:flutter/material.dart';

class AdminProvider extends ChangeNotifier{
  CourseAPI courseAPI = CourseAPI();

  Future addCourse(String courseName,String courseDescription,String coursePic,String channelName,
  String courseUrl,String category)async{
    try{
    var response = courseAPI.addCourse(courseName, courseDescription, coursePic, channelName, courseUrl,category);
    return response;
    }catch(e){
      print(e.toString());
    }  
  }

}