import 'dart:convert';
import 'package:courseriver/models/Course.dart';
import 'package:courseriver/providers/CourseProvider.dart';
import 'package:courseriver/widgets/BottomNavigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
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
  // bool isAlreadyRated = false;
  double currentRatings = 5.0;
  String name;
  bool isLoadingRatingbar = false;
  var currentCourse;
  var courseComments;
  String idU;
  TextEditingController commentController = TextEditingController();

  _launchURL(String courseLink) async {
    String url = courseLink;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> setUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var id = preferences.getString("id");
    setState(() {
      idU = id;
    });
    print("ID : " + id);
    setState(() {
      name = preferences.getString("name");
      if (id != null) {
        print("iddd : "+ id);
        isLoggedIn = true;
      }
    });
    // setState(() {
    if (Provider.of<CourseProvider>(context, listen: false)
        .courseData
        .ratedBy
        .contains(id)) {
      setState(() {
        // isAlreadyRated = true;
      });
    } else {}

    // setState(() {
    //   currentRatings = double.parse(
    //       Provider.of<CourseProvider>(context, listen: true)
    //           .courseData
    //           .courseRatings);
    // });
    // });
  }

  Future<void> rateAgain() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var ids = preferences.getString("jwt");
    print(ids);
    var response = await http.put(
        Uri.parse(
            "https://courseriver.herokuapp.com/removeRating/${widget.id}"),
        headers: {"Authorization": ids},
        body: {'newRatings': ((currentRatings + 3) / 2).toString()}).then((value) => {
          Provider.of<CourseProvider>(context,listen: false).getCourseData(widget.id)
        });
   
    setState(() {
      // isAlreadyRated = false;
      currentRatings = ((currentRatings + 3) / 2);
    });
    setState(() {});
  }

  @override
  void initState() {
    // String cr="";
    Provider.of<CourseProvider>(context, listen: false)
        .getCourseData(widget.id).then((value) => {
          setState((){
            currentRatings = double.parse(value.courseRatings);
          })
        });
    setUser();
    super.initState();
  }

  CourseProvider courseProvider(bool renderUi) =>
      Provider.of<CourseProvider>(context, listen: renderUi);

  @override
  Widget build(BuildContext context) {
    return Consumer<CourseProvider>(builder: (context, course, snapshot) {
      if (course.courseData == null || course.courseData.courseName == null) {
        return Center(child: CircularProgressIndicator());
      }
      return Scaffold(
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
            course.courseData.courseName,
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
                  backgroundImage: NetworkImage(course.courseData.coursePic),
                ),
              ),
              !course.courseData.ratedBy.contains(idU) && isLoggedIn 
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
                            child: Text("You have Already rated this course"),
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
                        Provider.of<CourseProvider>(context, listen: false)
                            .rateCourse(widget.id,
                                ((currentRatings + newRating) / 2).toString())
                            .whenComplete(() {
                          setState(() {
                            currentRatings = ((currentRatings + newRating) / 2);
                            // isAlreadyRated = true;
                             Provider.of<CourseProvider>(context, listen: false).getCourseData(widget.id);
                            isShow = false;
                          });
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Course Rated Successfully"),
                                  content: MaterialButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Ok"),
                                  ),
                                );
                              });
                        });
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
                        child: Text(!course.courseData.ratedBy.contains(idU) 
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
                          "Course Name :" + course.courseData.courseName,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                            "Course Description :" +
                                course.courseData.courseDescription,
                            style: TextStyle(color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                            "Channel Name :" + course.courseData.channelName,
                            style: TextStyle(color: Colors.white)),
                      ),
                      GestureDetector(
                        onTap: () {
                          launch(course.courseData.courseUrl);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 18.0, top: 10.0, bottom: 10.0),
                          child: Text(
                              "Course URL :" + course.courseData.courseUrl,
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                            "Ratings :" +
                                currentRatings.toStringAsFixed(2) +
                                "⭐" + " (" +(course.courseData.ratedBy.length + 1).toString() + " Reviews" + ")",
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
              idU != null
                  ? MaterialButton(
                      onPressed: () async {
                        commentController.text.isNotEmpty
                            ? courseProvider(false)
                                .commentCourse(
                                    commentController.text, widget.id)
                                .whenComplete(() {
                                commentController.clear();
                                Provider.of<CourseProvider>(context,
                                        listen: false)
                                    .getCourseData(widget.id);
                              })
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Comments",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              commentWidget(course)
            ],
          ),
        ),
      );
    });
  }

  Widget commentWidget(snapshot) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: snapshot.courseData.comments.length,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Card(
              elevation: 4.0,
              child: ListTile(
                title: Text(
                  snapshot.courseData.comments[i].commentedBy,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 10.0),
                  child: Text(
                    snapshot.courseData.comments[i].commentedText,
                    style: TextStyle(color: Colors.black, fontSize: 20.0),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
