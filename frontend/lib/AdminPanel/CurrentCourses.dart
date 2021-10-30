import 'package:courseriver/models/Course.dart';
import 'package:courseriver/providers/CourseProvider.dart';
import 'package:courseriver/screens/CourseDetail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrentCourses extends StatefulWidget {
  @override
  _CurrentCoursesState createState() => _CurrentCoursesState();
}

class _CurrentCoursesState extends State<CurrentCourses> {
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
                future:courseProvider(true).fetchCourse() ,
                builder: (context,snapshot){
                  if(snapshot.data==ConnectionState.waiting && !snapshot.hasData){
                    return Center(child: CircularProgressIndicator());
                  }
                  else if(!snapshot.hasData){
                    return Center(child: CircularProgressIndicator());
                  }
                  else{
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
                                        context,MaterialPageRoute(
                                          builder: (context) => CourseDetails(id:courseData.id)));
                                    },
                                    child:Expanded(
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 40.0,
                                          backgroundImage: NetworkImage(
                                             courseData.coursePic
                                             ),
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