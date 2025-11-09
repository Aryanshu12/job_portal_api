import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'utils/token_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final accessToken = await TokenHelper.getAccessToken();
  runApp(MyApp(isLoggedIn: accessToken != null));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
   MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Job Portal',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: isLoggedIn ?  HomeScreen() :  LoginScreen(),
    );
  }
}
