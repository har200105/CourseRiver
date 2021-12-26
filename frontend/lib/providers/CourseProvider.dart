import 'dart:convert';
import 'package:courseriver/API/Course.dart';
import 'package:courseriver/models/Category.dart';
import 'package:courseriver/models/Course.dart';
import 'package:courseriver/models/IndvCourseData.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseProvider extends ChangeNotifier {
  CourseAPI courseAPI = CourseAPI();
  
  List<CategoryData> cd = [];
  List<CourseData> recent=[];
  List<CourseData> highest=[];
  List<CourseData> trending=[];
  CourseData courseData=CourseData();
  List<CourseData> userRatedCourse = [];



  Future fetchCourse() async {
    try {
      var response = await courseAPI.fetchAllCourse();
      var modelledData = Course.fromJson(jsonDecode(response));
      print(modelledData.data);
      return modelledData.data;
    } catch (e) {
      print(e.toString());
    }
  }

  Future fetchTrending() async {
    try {
      var response = await courseAPI.fetchTrending();
      var modelledData = Course.fromJson(jsonDecode(response));
      print(modelledData.data);
      trending = modelledData.data;
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  Future fetchRecent() async {
    try {
      var response = await courseAPI.fetchRecent();
      var modelledData = Course.fromJson(jsonDecode(response));
      print(modelledData.data);
      recent =  modelledData.data;
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  Future fetchHighest() async {
    try {
      var response = await courseAPI.fetchHighest();
      var modelledData = Course.fromJson(jsonDecode(response));
      print(modelledData.data);
      highest = modelledData.data;
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  Future fetchCourseByCategory(String category) async {
    try {
      print(category);
      var response = await courseAPI.fetchCourseByCategory(category);
      var modelledData = Course.fromJson(jsonDecode(response));
      print(modelledData.data);
      return modelledData.data;
    } catch (e) {
      print(e.toString());
    }
  }

  Future getSearchedCourses(String text) async {
    try {
      var response = await courseAPI.getSearchedCourses(text);
    } catch (e) {
      print(e.toString());
    }
  }

  Future fetchReqCourses() async {
    try {
      var response = await courseAPI.fetchReqCourses();
      var modelledData = Course.fromJson(jsonDecode(response));
      print(modelledData.data);
      return modelledData.data;
    } catch (e) {
      print(e.toString());
    }
  }

  Future acceptCourse(String id) async {
    try {
      var response = await courseAPI.acceptCourse(id);
      if (response) {
        return 1;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future rejectCourse(String id) async {
    try {
      var response = await courseAPI.rejectCourse(id);
    } catch (e) {
      print(e.toString());
    }
  }

  Future addCourseReq(
      String courseName,
      String courseDescription,
      String coursePic,
      String channelName,
      String courseUrl,String category) async {
    try {
      var response = courseAPI.addCourseReq(courseName, courseDescription,
          coursePic, channelName, courseUrl,category);
      return response;
    } catch (e) {
      print(e.toString());
    }
  }

  Future getCategories() async {
    try {
      var response = await courseAPI.fetchCategories();
      var modelledData = Category.fromJson(jsonDecode(response));
      // print(modelledData.data);
      cd =  modelledData.data;
      notifyListeners();
      print("CD");
      print(cd[0].categoryName);
    } catch (e) {
      print(e.toString());
    }
  }

  Future rateCourse(String id, String newRatings) async {
    try {
      var response = await courseAPI.rateCourse(id, newRatings).then((value) =>{
      getCourseData(id)
      });
      return response;
    } catch (e) {
      print(e.toString());
    }
  }

  Future rateAgain(String id) async {
    try {
      var response = await courseAPI.rateAgain(id).then((value) => {
       getCourseData(id)
      });
      return response;
    } catch (e) {
      print(e.toString());
    }
  }

  Future getCourseData(String id) async {
    try {
      var response = await courseAPI.getCourseData(id);
      print("Response :");
      print(response);
      var modelledData = CourseData.fromJson(jsonDecode(response));
      courseData = modelledData;
      notifyListeners();
      print(modelledData.courseName);
      return modelledData;
    } catch (e) {
      print(e.toString());
    }
  }

  Future commentCourse(String commentText,String courseId) async {
    try {
      var response = await courseAPI.commentCourse(commentText, courseId).then((value) => {
        getCourseData(courseId)
      });
      return response;
    } catch (e) {
      print(e.toString());
    }
  }

  Future userRatedCourses()async{
   try {
      // var response = await courseAPI.commentCourse(commentText, courseId);
      // return response;
      var response = await courseAPI.getUserCourse();
      print("Response :" + response);
      var modelledData = Course.fromJson(jsonDecode(response));
      print("efrwv");
      // print(modelledData.data[0].category);
      userRatedCourse = modelledData.data;
      notifyListeners();
      // return response;
    } catch (e) {
      print(e.toString());
    } 
  }
}
