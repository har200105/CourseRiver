import 'dart:convert';
import 'package:courseriver/Services/Api.dart';
import 'package:courseriver/providers/CourseProvider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'CourseDetail.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();

  var searchedCourses;
  bool hasSearched = false;

  Future<dynamic> searchCourse(String course) async {
    var response = await http
        .post(Uri.parse("${API().api}/searchcourse"), body: {'query': course});

    setState(() {
      searchedCourses = jsonDecode(response.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    CourseProvider courseProvider(bool renderUi) =>
        Provider.of<CourseProvider>(context, listen: renderUi);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Course River",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 50.0, right: 25.0),
            child: Container(
              height: 54,
              width: double.infinity,
              child: TextField(
                controller: searchController,
                onChanged: (text) {
                  setState(() {
                    hasSearched = true;
                  });
                  searchCourse(text);
                },
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      searchCourse(searchController.text);
                    },
                    icon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  hintText: 'Search For Courses',
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            child: FutureBuilder(
              builder: (context, snapshot) {
                if (searchedCourses != null) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: searchedCourses.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.all(10.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CourseDetails(
                                          id: searchedCourses[index]['_id'])));
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 40.0,
                                backgroundImage: NetworkImage(
                                    searchedCourses[index]['coursePic']),
                              ),
                              title: Text(
                                searchedCourses[index]['courseName'],
                                style: TextStyle(color: Colors.black),
                              ),
                              subtitle: Text(
                                searchedCourses[index]['channelName'],
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return hasSearched
                      ? CircularProgressIndicator()
                      : Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
