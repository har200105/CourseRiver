import 'package:courseriver/AdminPanel/AcceptACourse.dart';
import 'package:courseriver/AdminPanel/AddACourse.dart';
import 'package:courseriver/AdminPanel/CurrentCourses.dart';
import 'package:courseriver/widgets/BottomNavigator.dart';
import 'package:flutter/material.dart';

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      leading: IconButton(onPressed: (){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomNavigationBarExample()));
      }, icon: Icon(Icons.arrow_back)),
        backgroundColor: Colors.black,
        title: Text("Admin Panel", style: TextStyle(color: Colors.white)),
        bottom: TabBar(
          indicatorColor: Colors.white,
          controller: _tabController,
          tabs: [
            Tab(
              text: "Current",
            ),
            Tab(
              text: "Accept",
            ),
            Tab(
              text: "Add",
            )
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [CurrentCourses(), AcceptCourse(),AddACourse() ],
      ),
    );
  }
}
