import 'package:courseriver/AdminPanel/Admin.dart';
import 'package:courseriver/Services/Cache.dart';
import 'package:courseriver/models/Category.dart';
import 'package:courseriver/models/Course.dart';
import 'package:courseriver/providers/CourseProvider.dart';
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
  String name = "";
  String image = "";
  bool isAdmin = false;
  final httpClient = http.Client();
  final Cache cache = Cache();

  Future setName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      image = prefs.getString("imaged");
      name = prefs.getString("name");
      isAdmin = prefs.getBool("admin");
      print(prefs.getBool("admin"));
    });
  }

  @override
  void initState() {
    Provider.of<CourseProvider>(context, listen: false).getCategories();
    Provider.of<CourseProvider>(context, listen: false).fetchRecent();
    Provider.of<CourseProvider>(context, listen: false).fetchHighest();
    Provider.of<CourseProvider>(context, listen: false).fetchTrending();
    super.initState();
    setName();
  }

  @override
  void dispose() {
    super.dispose();
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
                                  CircleAvatar(
                                    radius: 60.0,
                                    backgroundImage: NetworkImage(image),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, top: 20.0),
                                    child: Text(
                                      name ?? "",
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
                                  !isAdmin
                                      ? MaterialButton(
                                          onPressed: () {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Admin()));
                                          },
                                          child: Text("Admin",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        )
                                      : Container(height: 0, width: 0),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: MaterialButton(
                                      onPressed: () async {
                                        SharedPreferences preferences =
                                            await SharedPreferences
                                                .getInstance();
                                        await cache.removeCache(key: "jwt");
                                        await cache.removeCache(key: "name");
                                        await cache.removeCache(key: "imaged");
                                        await cache.removeCache(key: "id");
                                        await cache.removeCache(key: "admin");
                                        await preferences.clear();
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
                              child: Center(
                                child: Text(
                                  "Course River",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 40.0),
                                ),
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
                          child: Consumer<CourseProvider>(
                              builder: (context, category, snapshot) {
                            if (category.cd.length == 0) {
                              return Center(child: CircularProgressIndicator());
                            }
                            return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: category.cd.length,
                                itemBuilder: (context, index) {
                                  CategoryData categoryData =
                                      category.cd[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 3.0),
                                    child: Container(
                                      child: Row(children: [
                                        techCourses(
                                            context,
                                            categoryData.categoryPic,
                                            categoryData.categoryName,
                                            categoryData.id),
                                      ]),
                                    ),
                                  );
                                });
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
                        child: Consumer<CourseProvider>(
                            builder: (context, courses, snapshot) {
                          if (courses.recent.length == 0) {
                            return Center(child: CircularProgressIndicator());
                          }
                          return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: courses.recent.length,
                              itemBuilder: (context, index) {
                                CourseData courseData = courses.recent[index];
                                return Padding(
                                  padding: const EdgeInsets.only(left: 3.0),
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
                        child: Consumer<CourseProvider>(
                            builder: (context, courses, snapshot) {
                          if (courses.highest.length == 0) {
                            return Center(child: CircularProgressIndicator());
                          }
                          return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: courses.highest.length,
                              itemBuilder: (context, index) {
                                CourseData courseData = courses.highest[index];
                                return Padding(
                                  padding: const EdgeInsets.only(left: 3.0),
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
                        child: Consumer<CourseProvider>(
                            builder: (context, courses, snapshot) {
                          if (courses.trending.length == 0) {
                            return Center(child: CircularProgressIndicator());
                          }
                          return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: courses.trending.length,
                              itemBuilder: (context, index) {
                                CourseData courseData = courses.trending[index];
                                return Padding(
                                  padding: const EdgeInsets.only(left: 3.0),
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
                        })),
                  ])),
                ));
          }
        });
  }
}
