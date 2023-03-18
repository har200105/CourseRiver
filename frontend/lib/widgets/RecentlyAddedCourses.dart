import 'package:courseriver/screens/CourseDetail.dart';
import 'package:flutter/material.dart';

Widget recentlyAddedCourse(
    BuildContext context,
    String image,
    String name,
    String channelName,
    String id,
    String courseRatings,
    String courseUrl,
    String courseDescription,
    List ratedBy) {
  return Padding(
    padding: EdgeInsets.all(5.0),
    child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2.0, left: 8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CourseDetails(id: id)));
              },
              child: CircleAvatar(
                  radius: 55.0, backgroundImage: NetworkImage(image)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.005),
            child: Text(
              name,
              style: TextStyle(color: Colors.black),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.005),
            child: Text(
              channelName,
              style: TextStyle(color: Colors.black),
            ),
          )
        ],
      ),
    ),
  );
}
