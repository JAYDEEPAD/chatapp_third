import 'package:chatapp_third/allConstants/color_constants.dart';
import 'package:chatapp_third/helper/ui_helper.dart';
import 'package:chatapp_third/models/user_model.dart';
import 'package:chatapp_third/ui/home_screen.dart';
import 'package:chatapp_third/ui/signup_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailCtr = TextEditingController();
  TextEditingController passwordCtr = TextEditingController();

  void checkValues() {
    String email = emailCtr.text.toString().trim();
    String password = passwordCtr.text.toString().trim();

    if (email == "" || passwordCtr == "") {
      UiHelper.showAlertDialog(
          context, "Incomplete Data", "please fill all the fields!");
      print("please fill all the fields!");
    } else {
      signIn(email, password);
      print("signin success");
    }
  }

  void signIn(String email, String password) async {
    UserCredential? credential;
    UiHelper.showLoadingDialog(context);
    try {
      credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      // close loading dialoge
      Navigator.pop(context);
      // open alert dialoge
      UiHelper.showAlertDialog(
          context, "An error occured!", e.message.toString());
      print(e.toString());
    }

    if (credential != null) {
      String uid = credential.user!.uid;
      DocumentSnapshot userData =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      UserModel userModel =
          UserModel.fromMap(userData.data() as Map<String, dynamic>);
      emailCtr.clear();
      passwordCtr.clear();
      print("login successful!");
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return HomeScreen(
                userModel: userModel, firebaseUser: credential!.user!);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // AuthProvider authProvider = Provider.of<AuthProvider>(context);
    // switch (authProvider.status) {
    //   case Status.authenticateError:
    //     Fluttertoast.showToast(msg: "Sign in fail");
    //     break;
    //   case Status.authenticateCanceled:
    //     Fluttertoast.showToast(msg: "Sign in canceled");
    //     break;
    //   case Status.authenticated:
    //     Fluttertoast.showToast(msg: "Sign in success");
    //     break;
    //   default:
    // }
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Image.asset(
                    "images/back.png",
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: emailCtr,
                  decoration: InputDecoration(hintText: "Email Address"),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: passwordCtr,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: "password"),
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: CupertinoButton(
                    color: AppColors.themeColor,
                    child: Text("Sign In"),
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      checkValues();
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: GestureDetector(
                    onTap: () async {
                      // bool isSuccess = await authProvider.handleSignIn();
                      // if (isSuccess) {
                      //   Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => HomeScreen(),
                      //     ),
                      //   );
                      //   return;
                      // }
                    },
                    child: Image.asset("images/google_login.jpg"),
                  ),
                ),
                // Positioned(
                //   child: authProvider.status == Status.authenticating
                //       ? LoadingView()
                //       : SizedBox.shrink(),
                // )
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account?",
                style: TextStyle(fontSize: 16),
              ),
              CupertinoButton(
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SignUpScreen();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
