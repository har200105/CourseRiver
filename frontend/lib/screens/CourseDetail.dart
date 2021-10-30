import 'dart:convert';
import 'package:courseriver/widgets/BottomNavigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:socket_io_client/socket_io_client.dart';

class CourseDetails extends StatefulWidget {
  final String id;
  const CourseDetails({Key key, this.id});
  @override
  _CourseDetailsState createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isShow = false;
  double newRating = 0;
  bool isLoggedIn = false;
  bool isAlreadyRated = false;
  String name;
  bool isLoadingRatingbar = false;
  var currentCourse;
  var courseComments;
  TextEditingController commentController = TextEditingController();

  _launchURL(String courseLink) async {
    String url = courseLink;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> commentCourse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var comment = await http.post(
        Uri.parse("https://courseriver.herokuapp.com/addComment/${widget.id}"),
        body: {
          'commentedText': commentController.text,
        },
        headers: {
          'Authorization': prefs.getString("jwt")
        });

    if (comment.statusCode == 201) {
      getCourse();
      setState(() {});
      print(comment);
    }

    setState(() {
      commentController.clear();
    });
  }

  Future<void> rateCourse() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var rate = await http
        .put(Uri.parse("https://courseriver.herokuapp.com/ratecourse"), body: {
      'courseId': currentCourse[0]['_id'],
      'newRatings':
          ((double.parse(currentCourse[0]['courseRatings']) + newRating) / 2)
              .toString(),
    }, headers: {
      "Authorization": preferences.getString("jwt")
    });
    if (rate.body != null) {
      print(rate.body);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Course Rated Successfully"),
              content: MaterialButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BottomNavigationBarExample()));
                },
                child: Text("Ok"),
              ),
            );
          });
    }
  }

  var comments;
  Future getComments() async {}

  Future<void> getCourse() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var id = preferences.getString("id");
    setState(() {
      name = preferences.getString("name");
    });
    var response = await http.get(
        Uri.parse("https://courseriver.herokuapp.com/getCourse/${widget.id}"));
    setState(() {
      currentCourse = jsonDecode(response.body);
      courseComments = currentCourse[0]['comments'];
      print(courseComments);
      if (currentCourse[0]['ratedBy'].contains(id)) {
        setState(() {
          isAlreadyRated = true;
        });
      }
      if (id != null) {
        isLoggedIn = true;
      }
    });
  }

  Future<void> rateAgain() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var ids = preferences.getString("id");
    var response = await http.put(
        Uri.parse(
            "https://courseriver.herokuapp.com/removeRating/${widget.id}"),
        body: {'userId': ids});
    setState(() {
      isAlreadyRated = false;
    });
    setState(() {});
  }

  @override
  void initState() {
    getCourse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return currentCourse != null
        ? Scaffold(
            key: _scaffoldKey,
            resizeToAvoidBottomInset: true,
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
                currentCourse[0]['courseName'],
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: CircleAvatar(
                      radius: 80.0,
                      backgroundImage:
                          NetworkImage(currentCourse[0]['coursePic']),
                    ),
                  ),
                  !isAlreadyRated && isLoggedIn
                      ? RatingBar(
                          initialRating: 0,
                          minRating: 0,
                          maxRating: 5,
                          glow: true,
                          glowColor: Colors.blue,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          ratingWidget: RatingWidget(
                              empty: Icon(
                                Icons.star,
                                color: Colors.black,
                              ),
                              full: Icon(
                                Icons.star,
                                color: Colors.deepOrange,
                              ),
                              half: Icon(
                                Icons.star,
                                color: Colors.deepOrange[200],
                                size: 10.0,
                              )),
                          updateOnDrag: true,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          onRatingUpdate: (rating) {
                            setState(() {
                              isShow = true;
                              newRating = rating;
                            });
                            print(rating);
                          },
                        )
                      : isLoggedIn
                          ? Column(children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child:
                                    Text("You have Already rated this course"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: MaterialButton(
                                  onPressed: () async {
                                    await rateAgain();
                                  },
                                  child: Text(
                                    "Rate Again",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  color: Colors.black,
                                ),
                              )
                            ])
                          : Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text('Please Log in to Rate The Course'),
                            ),
                  isShow
                      ? MaterialButton(
                          onPressed: () async {
                            await rateCourse();
                          },
                          child: Text(
                            "Rate",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.black,
                        )
                      : Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Center(
                            child: Text(!isAlreadyRated
                                ? "Rate This Course !!"
                                : "You can Rate Again"),
                          ),
                        ),
                  Container(
                      width: 380.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.black),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              "Course Name :" + currentCourse[0]['courseName'],
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                                "Course Description :" +
                                    currentCourse[0]['courseDescription'],
                                style: TextStyle(color: Colors.white)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                                "Channel Name :" +
                                    currentCourse[0]['channelName'],
                                style: TextStyle(color: Colors.white)),
                          ),
                          GestureDetector(
                            onTap: () {
                              launch(currentCourse[0]['courseUrl']);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 18.0, top: 10.0, bottom: 10.0),
                              child: Text(
                                  "Course URL :" +
                                      currentCourse[0]['courseUrl'],
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                                "Ratings :" +
                                    double.parse(
                                            currentCourse[0]['courseRatings'])
                                        .toStringAsFixed(2) +
                                    "⭐",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      )),
                  name != null
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Comment",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      : Text(""),

                  name != null
                      ? Container(
                          width: 350.0,
                          child: TextFormField(
                            controller: commentController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Comment Your Views on this Course',
                            ),
                          ),
                        )
                      : Text(""),
                  name != null
                      ? MaterialButton(
                          onPressed: () async {
                            commentController.text.isNotEmpty
                                ? commentCourse()
                                : null;

                            print(commentController.text);
                          },
                          child: Text(
                            "Comment",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.black,
                        )
                      : Text(""),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: courseComments.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i) {
                      if (courseComments != null) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Card(
                            elevation: 4.0,
                            child: ListTile(
                              title: Text(
                                courseComments[i]['commentedBy'],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                              subtitle: Padding(
                                padding: EdgeInsets.only(top: 10.0, left: 10.0),
                                child: Text(
                                  courseComments[i]['commentedText'],
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20.0),
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  )
                ],
              ),
            ),
          )
        : Center(child: CircularProgressIndicator());
  }
}
