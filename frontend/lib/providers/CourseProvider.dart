import 'dart:convert';
import 'package:courseriver/API/Course.dart';
import 'package:courseriver/models/Category.dart';
import 'package:courseriver/models/Course.dart';
import 'package:flutter/cupertino.dart';

class CourseProvider extends ChangeNotifier {
  CourseAPI courseAPI = CourseAPI();

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
      return modelledData.data;
    } catch (e) {
      print(e.toString());
    }
  }

  Future fetchRecent() async {
    try {
      var response = await courseAPI.fetchRecent();
      var modelledData = Course.fromJson(jsonDecode(response));
      print(modelledData.data);
      return modelledData.data;
    } catch (e) {
      print(e.toString());
    }
  }

  Future fetchHighest() async {
    try {
      var response = await courseAPI.fetchHighest();
      var modelledData = Course.fromJson(jsonDecode(response));
      print(modelledData.data);
      return modelledData.data;
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
      String courseUrl,
      String category) async {
    try {
      var response = courseAPI.addCourseReq(courseName, courseDescription,
          coursePic, channelName, courseUrl, category);
      return response;
    } catch (e) {
      print(e.toString());
    }
  }

  Future getCategories() async {
    try {
      var response = await courseAPI.fetchCategories();
      var modelledData = Category.fromJson(jsonDecode(response));
      print(modelledData.data);
      return modelledData.data;
    } catch (e) {
      print(e.toString());
    }
  }

  Future rateCourse(String id, String newRatings) async {
    try {
      var response = await courseAPI.rateCourse(id, newRatings);
      return response;
    } catch (e) {
      print(e.toString());
    }
  }

  Future rateAgain(String id) async {
    try {
      var response = await courseAPI.rateAgain(id);
      return response;
    } catch (e) {
      print(e.toString());
    }
  }

  Future getCourseData(String id) async {
    try {
      var response = await courseAPI.getCourseData(id);
      var modelledData = Course.fromJson(jsonDecode(response));
      print(modelledData.data);
      return modelledData.data;
    } catch (e) {
      print(e.toString());
    }
  }
}
