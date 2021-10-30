import 'package:courseriver/Services/Decider.dart';
import 'package:courseriver/Services/Utility.dart';
import 'package:courseriver/providers/AdminProvider.dart';
import 'package:courseriver/providers/CourseProvider.dart';
import 'package:courseriver/providers/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CourseProvider()),
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => UtilityNotifier()),
        ChangeNotifierProvider(create: (_) => AdminProvider())
      ],
      child: MaterialApp(
        theme: ThemeData(fontFamily: "Poppins"),
        debugShowCheckedModeBanner: false,
        home: Decider(),
      ),
    );
  }
}
