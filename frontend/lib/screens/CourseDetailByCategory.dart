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
  const CourseDetailsCategory({Key key, this.category});


  @override
  _CourseDetailsCategoryState createState() => _CourseDetailsCategoryState();
}

class _CourseDetailsCategoryState extends State<CourseDetailsCategory> {
   var currentCourse;

    Future<void> getCourse() async {
    var response = await http.get(Uri.parse(
        "https://courseriver.herokuapp.com/getCourseByCat/${widget.category}"));
    print(response.body);
    setState(() {
      currentCourse = jsonDecode(response.body);
    });
  }

  @override
  void initState() {
    getCourse();
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
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => BottomNavigationBarExample()));
                },
              ),
              title: Text(
                widget.category + " Courses",
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
            ),
            body: Column(
              children: [
                FutureBuilder(
                    future: courseProvider(false).fetchCourseByCategory(widget.category),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CourseDetails(
                                              id:courseData.id)));
                                },
                                child:Expanded(
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 40.0,
                                      backgroundImage: NetworkImage(
                                         courseData.coursePic),
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
                    })
              ],
            ),
        );
  }
}





// Padding(
//             padding: const EdgeInsets.only(top:20.0),
//             child: CircleAvatar(
//               radius: 80.0,
//               backgroundImage: NetworkImage(currentCourse[1]['coursePic']),
//             ),
//           ),
//           // Ratings Bar
//           Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Text("Course Name :"+currentCourse[1]['courseName']),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Text("Course Description :"+currentCourse[1]['courseDescription']),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Text("Channel Name :"+currentCourse[1]['channelName']),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left:18.0,top:10.0,bottom: 10.0),
//             child: Text("Course URL :"+currentCourse[1]['courseUrl']),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Text("Ratings :" +currentCourse[1]['courseRatings']),
//           ),