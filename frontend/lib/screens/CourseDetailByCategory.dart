import 'dart:convert';
import 'package:courseriver/models/Course.dart';
import 'package:courseriver/providers/CourseProvider.dart';
import 'package:courseriver/screens/CourseDetail.dart';
import 'package:courseriver/widgets/BottomNavigator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class CourseDetailsCategory extends StatefulWidget {
  final String category;
  final String name;
  const CourseDetailsCategory({Key key, this.category, this.name});

  @override
  _CourseDetailsCategoryState createState() => _CourseDetailsCategoryState();
}

class _CourseDetailsCategoryState extends State<CourseDetailsCategory> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CourseProvider courseProvider(bool renderUi) =>
        Provider.of<CourseProvider>(context, listen: renderUi);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_sharp),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => BottomNavigationBarExample()));
          },
        ),
        title: Text(
          widget.name + " Courses",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          FutureBuilder(
              future:
                  courseProvider(false).fetchCourseByCategory(widget.category),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.data.length == 0) {
                  return Center(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      "No ${widget.name} Courses Available",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ));
                } else {
                  return Flexible(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          CourseData courseData = snapshot.data[index];
                          return Padding(
                            padding: EdgeInsets.all(10.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CourseDetails(id: courseData.id)));
                              },
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 40.0,
                                  backgroundImage:
                                      NetworkImage(courseData.coursePic),
                                ),
                                title: Text(
                                  courseData.courseName,
                                  style: TextStyle(color: Colors.black),
                                ),
                                subtitle: Text(
                                  courseData.channelName,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          );
                        }),
                  );
                }
              })
        ],
      ),
    );
  }
}
