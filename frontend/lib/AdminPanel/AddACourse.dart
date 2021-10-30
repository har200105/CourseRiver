import 'package:courseriver/Services/Utility.dart';
import 'package:courseriver/providers/AdminProvider.dart';
import 'package:courseriver/widgets/BottomNavigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddACourse extends StatefulWidget {
  @override
  _AddACourseState createState() => _AddACourseState();
}

class _AddACourseState extends State<AddACourse> {
  TextEditingController courseNameController = TextEditingController();
  TextEditingController courseDescriptionController = TextEditingController();
  TextEditingController courseUrlController = TextEditingController();
  TextEditingController channeNameController = TextEditingController();

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  List<String> categories = ['A', 'B', 'C', 'D'];
  String _selectedLocation;
  @override
  Widget build(BuildContext context) {
    var utils = Provider.of<UtilityNotifier>(context, listen: false);
    var userImage =
        Provider.of<UtilityNotifier>(context, listen: true).userimage;
    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(onPressed: (){
      //        Navigator.pushReplacement(
      //                 context,
      //                 MaterialPageRoute(
      //                     builder: (context) => BottomNavigationBarExample()));
      //   }, icon: Icon(Icons.arrow_back)),
      //   backgroundColor: Colors.black,
      //   title: Text("Course River",style: TextStyle(
      //     color: Colors.white
      //   )),
      //   centerTitle: true,
      // ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
                   userImage.isNotEmpty
                    ? Column(
                      children:[ 
                        CircleAvatar(
                        radius: 60.0,
                          backgroundImage: NetworkImage(utils.userimage),
                        ),
                        Text("Course Image")
                      ]
                    )
                    : Container(
                        height: 0,
                        width: 0,
                      ),
              Padding(
                padding: const EdgeInsets.only(top:10.0),
                child: Form(
                  key: _formKey,
                  child: Expanded(
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
                              // enabledBorder: OutlineInputBorder(
                              //   borderSide: BorderSide(color: Colors.red, width: 5.0),
                              // ),
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
                              // enabledBorder: OutlineInputBorder(
                              //   borderSide: BorderSide(color: Colors.red, width: 5.0),
                              // ),
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
                              // enabledBorder: OutlineInputBorder(
                              //   borderSide: BorderSide(color: Colors.red, width: 5.0),
                              // ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2.0),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                          ),
                        ),
                             ElevatedButton(
                    onPressed: () {
                      utils.uploadImage();
                    },
                          style: ButtonStyle(
                            backgroundColor:MaterialStateProperty.all(
                              Colors.black
                            ),
                              shape:
                                  MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12.0),
                                          side: BorderSide(
                                              color: Colors.white, width: 4.0)))),
                    child: Text(utils.userimage.isEmpty
                        ? "Upload Course Image"
                        : "Reselect Image",style: TextStyle(
                      color: Colors.white
                    ),),
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
                              // enabledBorder: OutlineInputBorder(
                              //   borderSide: BorderSide(color: Colors.red, width: 5.0),
                              // ),
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
                            items: categories.map((location) {
                              return DropdownMenuItem(
                                child: new Text(location),
                                value: location,
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Provider.of<AdminProvider>(context, listen: false)
                      .addCourse(
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
                            utils.userimage="",
                            courseDescriptionController.clear(),
                            _selectedLocation=""
                          });
                },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.teal, width: 2.0)))),
                child: Text(
                  "Add Course",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
