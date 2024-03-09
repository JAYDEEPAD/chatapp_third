import 'package:chatapp_third/allConstants/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1500), () {
      // checkSignIn();
    });
  }

  // void checkSignIn() async {
  //   AuthProvider authProvider = context.read<AuthProvider>();
  //   bool isLoggedIn = await authProvider.isLoggedIn();
  //   if (isLoggedIn) {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => HomeScreen(),
  //       ),
  //     );
  //     return;
  //   }
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => LoginScreen(),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "images/splash.png",
              width: 300,
              height: 300,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Chat App",
              style: TextStyle(color: AppColors.themeColor),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(color: AppColors.themeColor),
            ),
          ],
        ),
      ),
    );
  }
}
