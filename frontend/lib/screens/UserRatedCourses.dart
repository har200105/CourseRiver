import 'dart:convert';
import 'package:courseriver/Services/Cache.dart';
import 'package:courseriver/providers/CourseProvider.dart';
import 'package:courseriver/screens/CourseDetail.dart';
import 'package:courseriver/widgets/BottomNavigator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRated extends StatefulWidget {
  @override
  _UserRatedState createState() => _UserRatedState();
}

class _UserRatedState extends State<UserRated> {
  @override
  void initState() {
    Provider.of<CourseProvider>(context, listen: false).userRatedCourses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CourseProvider courseProvider(bool renderUi) =>
        Provider.of<CourseProvider>(context, listen: renderUi);
    final cache = Cache();
    return FutureBuilder(
      future: cache.readCache("jwt"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData) {
          return Center(
              child: Text("Please Login To See The Courses You Have Rated "));
        } else
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black,
                title: Text("Courses Rated By You Recently"),
                centerTitle: true,
                leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  BottomNavigationBarExample()));
                    }),
              ),
              body: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Consumer<CourseProvider>(
                      builder: (context, course, snapshot) {
                      if(course.userRatedCourse.length == 0){
                        return Center(child: Text("You Have Not Rated Any Courses Yet"));
                      }  
                        return Expanded(
                          child: ListView.builder(
                            itemCount: course.userRatedCourse.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.all(10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => CourseDetails(
                                                id: course
                                                    .userRatedCourse[index]
                                                    .id)));
                                  },
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 40.0,
                                      backgroundImage: NetworkImage(course
                                          .userRatedCourse[index].coursePic),
                                    ),
                                    title: Text(
                                      course.userRatedCourse[index].courseName,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    subtitle: Text(
                                      course.userRatedCourse[index].channelName,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    )
                  ],
                ),
              ));
      },
    );
  }
}
