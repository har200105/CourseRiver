import 'package:courseriver/Services/Cache.dart';
import 'package:courseriver/providers/UserProvider.dart';
import 'package:courseriver/screens/SignupScreen.dart';
import 'package:courseriver/widgets/BottomNavigator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {


  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordController = TextEditingController(); 
  final Cache cache = Cache();
  final httpClient = http.Client(); 
   final formkey = GlobalKey<FormState>();
     bool isShow = true;
     String email="";
     String password ="";
     String error = "";
     bool loading = false;

    
     @override
  void initState(){
    super.initState();
  }
  
  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(em);
  }
  @override
  Widget build(BuildContext context) {
     var auth = Provider.of<AuthenticationProvider>(context, listen: false);
    return Scaffold(
      appBar:AppBar(
        leading: IconButton(onPressed: (){
             Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BottomNavigationBarExample()));
        }, icon: Icon(Icons.arrow_back)),
        backgroundColor: Colors.black,
        title: Text("Course River",style: TextStyle(
          color: Colors.white
        )),
        centerTitle: true,
      ),
  resizeToAvoidBottomInset: false,
   body: Container(
     height: 900.0,
     width: 900.0,
      decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children:[
            Padding(
              padding: EdgeInsets.only(top:50.0),
              child: Row(
                children:[
                  IconButton(
                    icon:Icon(Icons.arrow_back_ios,color:Colors.white),
                    onPressed: (){
                      Navigator.pushReplacement(context, (MaterialPageRoute(builder: (context)=>SignUp())));
                    },
                ),
                ],
              ),
            ),
                 Form(
            key: formkey,
            child: Column(children: [
              Text("Login",style:TextStyle(
                fontSize: 25
              )),
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
                    style:
                        TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: "Enter your Email",
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.black, width: 2.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.black, width: 2.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      hintStyle: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black),
                    ),
                    //ignore:missing_return
                    validator: (text) {
                      if (!isEmail(text)) {
                        print("Not a valid email");
                        return "Please Enter a Valid Email";
                      } else {
                        print("Valid");
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
                          borderSide: const BorderSide(
                              color: Colors.black, width: 2.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.black, width: 2.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: ElevatedButton(
                  
                     style: ButtonStyle(
                       
                        backgroundColor:MaterialStateProperty.all(
                          Colors.black
                        ),
                        
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      side: BorderSide(
                                          color: Colors.white, width: 2.0)))),
           
                    onPressed: () async {
                       auth.Login(
                          context,
                          emailEditingController.text,
                          passwordController.text,
                          );
                    },
                    child: Text("Login",
                        style: TextStyle(color: Colors.white))),
              ),

       

               Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: TextButton(
                    onPressed: () async {
                              Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => SignUp()));
                    },
                    child: Text("New User ?",
                        style: TextStyle(color: Colors.black))),
              ),

            ]),
          ),
          ]
        ),
   ),
    );
  }
}