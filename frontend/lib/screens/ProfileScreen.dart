import 'package:courseriver/screens/RequestACourse.dart';
import 'package:courseriver/widgets/BottomNavigator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name;
  String image;

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("name");
      image = prefs.getString("imaged");
    });
  }

  @override
  void initState() {
    getUserData();
    super.initState();
}

  @override
  Widget build(BuildContext context) {
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
          title: Text("Profile", style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 70.0, left: 100.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              image != null  &&  image != ""
                  ? CircleAvatar(
                      radius: 60.0,
                      backgroundImage: NetworkImage(image),
                    )
                  : Icon(
                      Icons.person,
                      size: 120.0,
                    ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Text(name ?? "s"),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RequestACourse()));
                    },
                    child: Text(
                      "Request To Add a Course",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.black,
                  )),
              Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: MaterialButton(
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.remove("jwt");
                      await prefs.remove("id");
                      await prefs.remove("name");
                      await prefs.remove("image");
                      await prefs.clear();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  BottomNavigationBarExample()));
                    },
                    child: Text(
                      "Logout",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.black,
                  ))
            ],
          ),
        ));
  }
}
