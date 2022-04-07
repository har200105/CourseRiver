import 'package:courseriver/providers/UserProvider.dart';
import 'package:courseriver/screens/SignupScreen.dart';
import 'package:courseriver/widgets/BottomNavigator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatefulWidget {
  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final formkey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();
  TextEditingController otpController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AuthenticationProvider>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
      body: SingleChildScrollView(
        reverse: true,
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(children: [
            Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          (MaterialPageRoute(builder: (context) => SignUp())));
                    },
                  ),
                ],
              ),
            ),
            Form(
              key: formkey,
              child: Column(children: [
                Text("Reset Password", style: TextStyle(fontSize: 25)),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 30.0, left: 80.0, right: 80.0),
                  child: TextFormField(
                      controller: emailController,
                      focusNode: FocusNode(),
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: "Email",
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
                        hintStyle:
                            TextStyle(fontSize: 18.0, color: Colors.black),
                      ),
                      // ignore:missing_return
                      validator: (a) {}),
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
                        await auth.sendForgotPasswordOTP(
                            context, emailController.text);
                        FocusScope.of(context).unfocus();
                      },
                      child: Text("Send OTP",
                          style: TextStyle(color: Colors.white))),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 25.0, left: 80.0, right: 80.0),
                  child: TextFormField(
                    controller: passwordController,
                    focusNode: FocusNode(),
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(Icons.remove_red_eye),
                        onPressed: () {},
                      ),
                      labelText: "New password",
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
                Padding(
                  padding: EdgeInsets.only(top: 25.0, left: 80.0, right: 80.0),
                  child: TextFormField(
                    controller: confirmPasswordController,
                    focusNode: FocusNode(),
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(Icons.remove_red_eye),
                        onPressed: () {},
                      ),
                      labelText: "Confirm password",
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
                Padding(
                  padding: EdgeInsets.only(top: 25.0, left: 80.0, right: 80.0),
                  child: TextFormField(
                    controller: otpController,
                    focusNode: FocusNode(),
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: "OTP",
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
                        await auth.resetPassword(context, emailController.text,
                            passwordController.text, otpController.text);
                        FocusScope.of(context).unfocus();
                      },
                      child: Text("Confirm",
                          style: TextStyle(color: Colors.white))),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}
