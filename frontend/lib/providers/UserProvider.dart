import 'dart:convert';
import 'package:courseriver/API/Auth.dart';
import 'package:courseriver/Services/Cache.dart';
import 'package:courseriver/Services/Utility.dart';
import 'package:courseriver/screens/LoginScreen.dart';
import 'package:courseriver/screens/SignupScreen.dart';
import 'package:courseriver/screens/VerfiyEmail.dart';
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
      print(email);
      print("signup");
      var userData =
          await authentication.signupUser(email, password, name, image);
      Map<String, dynamic> parsedData = await jsonDecode(userData);
      print(parsedData['success']);
      final success = parsedData['success'];
      final message = parsedData['message'];
      var utils = Provider.of<UtilityNotifier>(context, listen: false);
      if (success == true) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => VerifyEmail(
                      email: email,
                    )));
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Something went wrong")));
      print(e);
    }
  }

  Future LoginService(
      BuildContext context, String email, String password) async {
    try {
      var userData = await authentication.loginUser(email, password);
      Map<String, dynamic> parsedData = await jsonDecode(userData);
      print(parsedData);

      final verified = parsedData['verified'];
      final success = parsedData['success'];
      final message = parsedData['message'];

      final pic = parsedData['image'];
      if (success && verified) {
        final userjwt = parsedData['token'];
        final names = parsedData['name'];
        final id = parsedData['id'];
        final image = parsedData['image'];
        final admin = parsedData['admin'];
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
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: Colors.green));
      } else if (success && !verified) {
        print(message);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => VerifyEmail(email: email)));
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      } else if (!success && !verified) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: Colors.red));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Something Went Wrong"), backgroundColor: Colors.red));
    }
  }

  Future resetPassword(
      BuildContext context, String email, String password, String otp) async {
    try {
      var userData = await authentication.resetPassword(email, password, otp);
      Map<String, dynamic> parsedData = await jsonDecode(userData);
      print(parsedData);
      final success = parsedData['success'];
      final message = parsedData['message'];
      if (success) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: Colors.green));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SignUp()));
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: Colors.red));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Invalid OTP"), backgroundColor: Colors.red));
    }
  }

  Future verifyEmail(BuildContext context, String email, String otp) async {
    try {
      var userData = await authentication.verifyEmail(email, otp);
      Map<String, dynamic> parsedData = await jsonDecode(userData);
      print(parsedData);
      final success = parsedData['success'];
      final message = parsedData['message'];
      if (success) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: Colors.green));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SignUp()));
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: Colors.red));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Invalid OTP"), backgroundColor: Colors.red));
    }
  }

  Future sendForgotPasswordOTP(BuildContext context, String email) async {
    try {
      var userData = await authentication.sendforgotPasswordOTP(email);
      Map<String, dynamic> parsedData = await jsonDecode(userData);
      print(parsedData);
      final success = parsedData['success'];
      final message = parsedData['message'];
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: Colors.green));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: Colors.red));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Invalid OTP"), backgroundColor: Colors.red));
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
