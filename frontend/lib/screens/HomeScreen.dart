import 'package:courseriver/AdminPanel/Admin.dart';
import 'package:courseriver/Services/Cache.dart';
import 'package:courseriver/models/Category.dart';
import 'package:courseriver/models/Course.dart';
import 'package:courseriver/providers/CourseProvider.dart';
import 'package:courseriver/providers/UserProvider.dart';
import 'package:courseriver/screens/LoginScreen.dart';
import 'package:courseriver/screens/ProfileScreen.dart';
import 'package:courseriver/screens/RequestACourse.dart';
import 'package:courseriver/screens/SignupScreen.dart';
import 'package:courseriver/widgets/HighestRatedCourses.dart';
import 'package:courseriver/widgets/RecentlyAddedCourses.dart';
import 'package:courseriver/widgets/TechCourses.dart';
import 'package:courseriver/widgets/TrendingCourses.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name;

  final httpClient = http.Client();
  final Cache cache = Cache();

  Future setName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("named");
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CourseProvider courseProvider(bool renderUi) =>
        Provider.of<CourseProvider>(context, listen: renderUi);
    return FutureBuilder(
        future: cache.readCache("jwt"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Scaffold(
                drawer: Drawer(
                    child: snapshot.hasData
                        ? Container(
                            color: Colors.black,
                            child: Padding(
                              padding: EdgeInsets.only(top: 100.0),
                              child: Column(
                                children: [
                                  Text(
                                    "Course River",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 40.0),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, top: 20.0),
                                    child: Text(
                                      Provider.of<AuthenticationProvider>(
                                                  context,
                                                  listen: true)
                                              .getName ??
                                          name,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RequestACourse()));
                                    },
                                    child: Text(
                                      "Request a Course to Add",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0),
                                    ),
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Admin()));
                                    },
                                    child: Text("Admin",
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: MaterialButton(
                                      onPressed: () async {
                                        await cache.removeCache(key: "jwt");
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SignUp()));
                                      },
                                      child: Text(
                                        "Logout",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.black,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 100.0, left: 15.0),
                              child: Text(
                                "Course River",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 40.0),
                              ),
                            ))),
                appBar: AppBar(
                  centerTitle: true,
                  title: Text(
                    "Course River",
                    style: TextStyle(color: Colors.white),
                  ),
                  actions: [
                    !snapshot.hasData
                        ? MaterialButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()));
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: IconButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Profile()));
                              },
                              icon: Icon(Icons.account_circle),
                              splashColor: Colors.teal,
                            ),
                          )
                  ],
                  backgroundColor: Colors.black,
                ),
                body: SingleChildScrollView(
                  child: Container(
                      child: Column(children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10.0, left: 5.0),
                      child: Text(
                        "Courses By Tech Stacks",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, left: 0.0),
                      child: SizedBox(
                          height: 180.0,
                          child: FutureBuilder(
                              future: courseProvider(false).getCategories(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (!snapshot.hasData) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else {
                                  return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (context, index) {
                                        CategoryData categoryData =
                                            snapshot.data[index];
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(left: 3.0),
                                          child: Container(
                                            child: Row(children: [
                                              techCourses(
                                                  context,
                                                  categoryData.categoryPic,
                                                  categoryData.categoryName),
                                            ]),
                                          ),
                                        );
                                      });
                                }
                              })),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.0, left: 5.0),
                      child: Text(
                        "Recently Added Courses",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                    ),
                    SizedBox(
                        height: 180.0,
                        child: FutureBuilder(
                            future: courseProvider(false).fetchRecent(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                return ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, index) {
                                      CourseData courseData =
                                          snapshot.data[index];
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(left: 3.0),
                                        child: Container(
                                          child: Row(children: [
                                            recentlyAddedCourse(
                                                context,
                                                courseData.coursePic,
                                                courseData.courseName,
                                                courseData.channelName,
                                                courseData.id,
                                                courseData.courseRatings,
                                                courseData.courseUrl,
                                                courseData.courseDescription,
                                                courseData.ratedBy),
                                          ]),
                                        ),
                                      );
                                    });
                              }
                            })),
                    Padding(
                      padding: EdgeInsets.only(top: 15.0, left: 5.0),
                      child: Text(
                        "Highest Rated Courses",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                    ),
                    SizedBox(
                        height: 180.0,
                        child: FutureBuilder(
                            future: courseProvider(false).fetchHighest(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                return ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, index) {
                                      CourseData courseData =
                                          snapshot.data[index];
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(left: 3.0),
                                        child: Container(
                                          child: Row(children: [
                                            highestRatedCourses(
                                                context,
                                                courseData.coursePic,
                                                courseData.courseName,
                                                courseData.channelName,
                                                courseData.id),
                                          ]),
                                        ),
                                      );
                                    });
                              }
                            })),
                    Padding(
                      padding: EdgeInsets.only(top: 15.0, left: 5.0),
                      child: Text(
                        "Trending Courses",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                    ),
                    SizedBox(
                        height: 180.0,
                        child: FutureBuilder(
                            future: courseProvider(false).fetchTrending(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                return ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, index) {
                                      CourseData courseData =
                                          snapshot.data[index];
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(left: 3.0),
                                        child: Container(
                                          child: Row(children: [
                                            trendingCourses(
                                                context,
                                                courseData.coursePic,
                                                courseData.courseName,
                                                courseData.channelName,
                                                courseData.id),
                                          ]),
                                        ),
                                      );
                                    });
                              }
                            })),
                  ])),
                ));
          }
        });
  }
}
