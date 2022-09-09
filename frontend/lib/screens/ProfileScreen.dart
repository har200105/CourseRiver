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
          padding: const EdgeInsets.only(top: 70.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              image != null && image != ""
                  ? Center(
                      child: CircleAvatar(
                        radius: 60.0,
                        backgroundImage: NetworkImage(image),
                      ),
                    )
                  : Center(
                      child: Icon(
                        Icons.person,
                        size: 120.0,
                      ),
                    ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Text(name ?? ""),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: SizedBox(
                  width: 250,
                  height: 45,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.cyanAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RequestACourse()));
                      },
                      child: Text(
                        "Request a Course",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: SizedBox(
                  width: 150,
                  height: 45,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.lightGreenAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
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
                      )),
                ),
              ),
            ],
          ),
        ));
  }
}
