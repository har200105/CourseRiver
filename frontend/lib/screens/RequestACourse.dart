import 'package:courseriver/Services/Utility.dart';
import 'package:courseriver/providers/AdminProvider.dart';
import 'package:courseriver/providers/CourseProvider.dart';
import 'package:courseriver/widgets/BottomNavigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class RequestACourse extends StatefulWidget {
  @override
  _RequestACourseState createState() => _RequestACourseState();
}

class _RequestACourseState extends State<RequestACourse> {
  TextEditingController courseNameController = TextEditingController();
  TextEditingController courseDescriptionController = TextEditingController();
  TextEditingController courseUrlController = TextEditingController();
  TextEditingController channeNameController = TextEditingController();

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String _selectedLocation;
  @override
  void initState() {
    Provider.of<CourseProvider>(context, listen: false).getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var utils = Provider.of<UtilityNotifier>(context, listen: false);
    var userImage =
        Provider.of<UtilityNotifier>(context, listen: true).userimage;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BottomNavigationBarExample()));
            },
            icon: Icon(Icons.arrow_back)),
        backgroundColor: Colors.black,
        title: Text("Course River", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              userImage.isNotEmpty
                  ? Column(children: [
                      CircleAvatar(
                        radius: 60.0,
                        backgroundImage: NetworkImage(utils.userimage),
                      ),
                      Text("Course Image")
                    ])
                  : Container(
                      height: 0,
                      width: 0,
                    ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: courseNameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: "Enter The Course Name",
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: channeNameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: "Enter The Channel Name",
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: courseDescriptionController,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            labelText: "Course Description",
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: courseUrlController,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            labelText: "Course URL",
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButton(
                          hint: Text('Choose a Category'),
                          value: _selectedLocation,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedLocation = newValue;
                            });
                          },
                          items: Provider.of<CourseProvider>(context,
                                  listen: false)
                              .cd
                              .map((location) {
                            return DropdownMenuItem(
                              child: new Text(location.categoryName),
                              value: location.id,
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: SizedBox(
                  width: 250,
                  height: 45,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.indigoAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: utils.uploadImage,
                      child: Text(
                          utils.userimage.isEmpty
                              ? "Upload Course Image"
                              : "Reselect Image",
                          style: TextStyle(color: Colors.white))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: SizedBox(
                  width: 250,
                  height: 45,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(158, 17, 244, 240),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () async {
                        Provider.of<CourseProvider>(context, listen: false)
                            .addCourseReq(
                                courseNameController.text,
                                courseDescriptionController.text,
                                utils.userimage,
                                channeNameController.text,
                                courseUrlController.text,
                                _selectedLocation)
                            .whenComplete(() => {
                                  courseNameController.clear(),
                                  courseUrlController.clear(),
                                  channeNameController.clear(),
                                  courseDescriptionController.clear(),
                                });
                      },
                      child: Text("Add Course",
                          style: TextStyle(color: Colors.white))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
