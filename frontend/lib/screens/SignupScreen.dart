import 'package:courseriver/Services/Cache.dart';
import 'package:courseriver/Services/Utility.dart';
import 'package:courseriver/providers/UserProvider.dart';
import 'package:courseriver/screens/LoginScreen.dart';
import 'package:courseriver/widgets/BottomNavigator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController userNameEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final Cache cache = Cache();

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(em);
  }

  final httpClient = http.Client();

  final formkey = GlobalKey<FormState>();
  bool isShow = true;
  String email = "";
  String password = "";
  String error = "";
  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AuthenticationProvider>(context, listen: false);
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
      resizeToAvoidBottomInset: false,
      body: Container(
        height: 900.0,
        width: 900.0,
        child: Column(children: [
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        (MaterialPageRoute(
                            builder: (context) =>
                                BottomNavigationBarExample())));
                  },
                ),
              ],
            ),
          ),
          userImage.isNotEmpty
              ? CircleAvatar(
                  radius: 60.0,
                  backgroundImage: NetworkImage(utils.userimage),
                )
              : Container(
                  height: 0,
                  width: 0,
                ),
          Form(
            key: formkey,
            child: Column(
              children: [
              Text("Signup", style: TextStyle(fontSize: 25)),
              Padding(
                padding:
                    const EdgeInsets.only(top: 25, left: 80.0, right: 80.0),
                child: TextFormField(
                  controller: userNameEditingController,
                  // validator: (val)=> val.isEmpty ? "Enter Email Please":null,
                  // ignore: missing_return
                  validator: (a) {
                    if (userNameEditingController.text.isEmpty || userNameEditingController.text.length<=0) {
                      return "Name Required";
                    }
                  },
                  // onChanged: (val) {
                  //   setState(() {
                  //     email = val;
                  //   });
                  // },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    labelText: "Enter your Name",
                    hintStyle: TextStyle(fontSize: 18.0, color: Colors.black),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 30.0, left: 80.0, right: 80.0),
                child: TextFormField(
                    controller: emailEditingController,
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    },
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: "Enter your Email",
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.black, width: 2.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.black, width: 2.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      hintStyle: TextStyle(fontSize: 18.0, color: Colors.black),
                    ),
                    //ignore:missing_return
                    validator: (text) {
                      if (!validateEmail(emailEditingController.text.trim())) {
                        return "Invalid Email";
                      }
                    }),
              ),
              Padding(
                padding: EdgeInsets.only(top: 25.0, left: 80.0, right: 80.0),
                child: TextFormField(
                  controller: passwordController,
                  onChanged: (val) {
                    setState(() {
                      password = val;
                    });
                  },
                  // ignore: missing_return
                  validator: (value) {
                    if ((passwordController.text.length < 6)) {
                      return "Password Should Be Of Minimum Length 6";
                    }
                  },
                  obscureText: isShow,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(Icons.remove_red_eye),
                      onPressed: () {
                        setState(() {
                          isShow = !isShow;
                        });
                      },
                    ),
                    labelText: "Enter your password",
                    hintStyle: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'Comic',
                        color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  utils.uploadImage();
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side:
                                BorderSide(color: Colors.white, width: 4.0)))),
                child: Text(
                  utils.userimage.isEmpty ? "Upload Image" : "Reselect Image",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: BorderSide(
                                        color: Colors.white, width: 2.0)))),
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      if (formkey.currentState.validate()) {
                        auth.Signup(
                            context,
                            userNameEditingController.text.trim(),
                            emailEditingController.text.trim(),
                            passwordController.text.trim(),
                            utils.userimage);
                      }
                    },
                    child:
                        Text("Signup", style: TextStyle(color: Colors.white))),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: TextButton(
                    onPressed: () async {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                    child: Text("Already a User ?",
                        style: TextStyle(color: Colors.black))),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
