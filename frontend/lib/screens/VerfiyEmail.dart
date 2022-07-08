import 'package:courseriver/providers/UserProvider.dart';
import 'package:courseriver/screens/LoginScreen.dart';
import 'package:courseriver/screens/SignupScreen.dart';
import 'package:courseriver/widgets/BottomNavigator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerifyEmail extends StatefulWidget {
  @override
  final String email;
  const VerifyEmail({Key key, @required this.email}) : super(key: key);
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController otpController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AuthenticationProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Login()));
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
            child: Column(children: [
              Text("Verify Your Account", style: TextStyle(fontSize: 25)),
              Padding(
                padding:
                    const EdgeInsets.only(top: 30.0, left: 80.0, right: 80.0),
                child: TextFormField(
                    initialValue: widget.email ?? "",
                    focusNode: FocusNode(),
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
                    // ignore:missing_return
                    validator: (a) {}),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 30.0, left: 80.0, right: 80.0),
                child: TextFormField(
                    controller: otpController,
                    focusNode: FocusNode(),
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: "OTP",
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
                      auth.verifyEmail(
                          context, widget.email, otpController.text);
                      FocusScope.of(context).unfocus();
                    },
                    child:
                        Text("Verify", style: TextStyle(color: Colors.white))),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
