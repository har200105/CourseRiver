import 'package:courseriver/screens/RequestACourse.dart';
import 'package:courseriver/screens/HomeScreen.dart';
import 'package:courseriver/screens/SearchScreen.dart';
import 'package:courseriver/screens/UserRatedCourses.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';



class BottomNavigationBarExample extends StatefulWidget {
  @override
  _BottomNavigationBarExampleState createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  PageController pageController = PageController();
  int currentIndex = 0;
  var currentTab = [
    HomeScreen(), 
    SearchPage(),
    UserRated()
  ];


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        // Navigator.pushReplacement(context, route)
        return Future.value(false);

      },
      child: Scaffold(
        body: PageView(
          children: currentTab,
          controller: pageController,
          onPageChanged: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
              pageController.animateToPage(index,
                  duration: Duration(milliseconds: 500), curve: Curves.easeIn);
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(LineIcons.home,color: Colors.white),
              label: ""
            ),
            BottomNavigationBarItem(
              icon: Icon(LineIcons.search,color: Colors.white,),
              label: ""
            ),
            BottomNavigationBarItem(
              icon: Icon(LineIcons.heart,color: Colors.white,),
              label: ""
            ),
          ],
        ),
      ),
    );
  }
}