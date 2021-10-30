import 'package:courseriver/models/Course.dart';
import 'package:courseriver/providers/CourseProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AcceptCourse extends StatefulWidget {
  @override
  _AcceptCourseState createState() => _AcceptCourseState();
}

class _AcceptCourseState extends State<AcceptCourse> {
  
  _launchURL(String courseLink) async {
    String url = courseLink;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    CourseProvider courseProvider(bool renderUi) =>
        Provider.of<CourseProvider>(context, listen: renderUi);
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: FutureBuilder(
                future: courseProvider(true).fetchReqCourses(),
                builder: (context, snapshot) {
                  if (snapshot.data == ConnectionState.waiting &&
                      !snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Flexible(
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            CourseData courseData = snapshot.data[index];
                            return Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Expanded(
                                child: ListTile(
                                  onTap: (){
                                     launch(courseData.courseUrl);
                                  },
                                  leading: CircleAvatar(
                                    radius: 40.0,
                                    backgroundImage:
                                        NetworkImage(courseData.coursePic),
                                  ),
                                  title: Row(children: [
                                    Text(
                                      courseData.courseName,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          courseProvider(false)
                                              .acceptCourse(courseData.id)
                                              .whenComplete(  
                                                  () => {print("Done")});
                                        },
                                        icon: Icon(Icons.check)),
                                    IconButton(
                                        onPressed: () {
                                           courseProvider(false)
                                              .rejectCourse(courseData.id)
                                              .whenComplete(
                                                  () => {print("Done")});
                                        },
                                        icon: Icon(Icons.cancel)),
                                  ]),
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
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
