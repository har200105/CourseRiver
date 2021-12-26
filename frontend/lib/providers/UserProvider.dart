import 'dart:convert';
import 'package:courseriver/API/Auth.dart';
import 'package:courseriver/Services/Cache.dart';
import 'package:courseriver/Services/Utility.dart';
import 'package:courseriver/widgets/BottomNavigator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationProvider extends ChangeNotifier {
  final Cache cache = Cache();
  final Authentication authentication = Authentication();

  String name;
  String get getName => name;
  String image;
  String get getImage => image;
  Future Signup(BuildContext context, String name, String email,
      String password, String image) async {
    try {
      print("Authentication");
      var userData =
          await authentication.signupUser(email, password, name, image);
      print("Authentication1");
      Map<String, dynamic> parsedData = await jsonDecode(userData);
      print("AA");
      print(parsedData);

      final userjwt = parsedData['token'];
      final code = parsedData['code'];
      final names = parsedData['name'];
      final id = parsedData['_id'];
      final admin = parsedData['admin'];
      var utils = Provider.of<UtilityNotifier>(context, listen: false);
      print(parsedData['newUser.name']);
      print(names);
      final pic = parsedData['image'];
      print(pic);

      print("Code :" + code.toString());
      if (code == 201) {
        cache.writeCache(key: "jwt", value: userjwt);
        cache.writeCache(key: "name", value: names);
        // cache.writeCache(key: "admin",value:admin);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("imaged", pic);
        prefs.setBool("admin", admin);
        setName(names);
        cache.writeCache(key: "pic", value: pic);
        cache.writeCache(key: "id", value: id);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => BottomNavigationBarExample()));
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Signup Successfull")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Invalid Credentials")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Something went wrong")));
      print(e);
    }
  }

  Future Login(BuildContext context, String email, String password) async {
    try {
      var userData = await authentication.loginUser(email, password);
      Map<String, dynamic> parsedData = await jsonDecode(userData);
      print(parsedData);
      final userjwt = parsedData['token'];
      final code = parsedData['code'];
      final names = parsedData['name'];
      final id = parsedData['_id'];
      final image = parsedData['image'];
      final admin = parsedData['admin'];
      // cache.writeCache(key: "admin",value:admin);

      print(names);
      final pic = parsedData['image'];
      print("Code :" + code.toString());
      if (code == 201) {
        cache.writeCache(key: "jwt", value: userjwt);
        cache.writeCache(key: "name", value: names);
        setName(names);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("imaged", image);
        prefs.setString("named", names);
        prefs.setBool("admin", admin);
        cache.writeCache(key: "pic", value: pic);
        cache.writeCache(key: "id", value: id);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => BottomNavigationBarExample()));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Logged In Successfully"),
            backgroundColor: Colors.green));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Invalid Credentials"), backgroundColor: Colors.red));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Invalid Credentials"), backgroundColor: Colors.red));
    }
  }

  setName(String name) {
    this.name = name;
    notifyListeners();
    print(name);
  }

  setImage(String image) {
    this.image = image;
    notifyListeners();
    print(image);
  }
}
