import 'dart:convert';
import 'package:courseriver/Services/Cache.dart';
import 'package:courseriver/screens/CourseDetail.dart';
import 'package:courseriver/widgets/BottomNavigator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserRated extends StatefulWidget {

  @override
  _UserRatedState createState() => _UserRatedState();
}

class _UserRatedState extends State<UserRated> {

   
    var coursesOfUser; 
    final Cache cache = Cache();
  Future<void> getUser()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
             var response = await http.get(Uri.parse("https://courseriver.herokuapp.com/getUserCourse"),headers: {
               "Authorization": prefs.getString("jwt")
             });
            //  print(response.body);
  
     setState(() {
            coursesOfUser=jsonDecode(response.body);
            print(coursesOfUser[0]['ratingsGiven'][0]['courseName']);
            print("sssssddd" + coursesOfUser[0]['ratingsGiven'][0]['channelName']);
          });
  }
   
  @override    
    void initState() {
      getUser();
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Courses Rated By You Recently"),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
          Navigator.pushReplacement(context,
           MaterialPageRoute(builder: (context)=>BottomNavigationBarExample()));
        }),
      ),
      body: coursesOfUser!=null ?Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            FutureBuilder(
              builder: (context,snapshot){
                return Expanded(
                  child: ListView.builder(
                    itemCount:coursesOfUser[0]['ratingsGiven'].length,
                    itemBuilder: (context,index){
                      if(coursesOfUser!=null){
                      return Padding(
                        padding: EdgeInsets.all(10.0),
                        child: GestureDetector(
                              onTap: () { 
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CourseDetails(
                                          
                                            id: coursesOfUser[0]['ratingsGiven'][index]['_id'])));
                              },
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 40.0,
                                  backgroundImage: NetworkImage(
                                       coursesOfUser[0]['ratingsGiven'][index]['coursePic']),
                                ),
                                title: Text(
                                   coursesOfUser[0]['ratingsGiven'][0]['courseName'],
                                  style: TextStyle(color: Colors.black),
                                ),
                                subtitle: Text(
                                  coursesOfUser[0]['ratingsGiven'][index]['channelName'],
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                      );
                      }else return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text("You have rated no courses  df")),
                      );
                    },
                  ),
                );
              },
            )
          ],
        ),
      ):Center(child: Text("You have rated no courses"),)
    );
  }
}