import 'package:chatapp_third/allConstants/color_constants.dart';
import 'package:chatapp_third/helper/ui_helper.dart';
import 'package:chatapp_third/models/user_model.dart';
import 'package:chatapp_third/ui/complate_profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailCtr = TextEditingController();
  TextEditingController passwordCtr = TextEditingController();
  TextEditingController cPasswordCtr = TextEditingController();
  void checkValues() {
    String email = emailCtr.text.toString().trim();
    String password = passwordCtr.text.toString().trim();
    String cPassword = cPasswordCtr.text.toString().trim();

    if (email == "" || passwordCtr == "" || cPassword == "") {
      UiHelper.showAlertDialog(
          context, "Incomplete Data", "please fill all the fields!");
      print("please fill all the fields!");
    } else if (password != cPassword) {
      UiHelper.showAlertDialog(
          context, "Password Missmatch", "password do not match!");
      print("");
    } else {
      signUp(email, password);
      print("signup success");
    }
  }

  void signUp(String email, String password) async {
    UserCredential? credential;
    UiHelper.showLoadingDialog(context);
    try {
      credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      // close loading dialoge
      Navigator.pop(context);
      // open alert dialoge
      UiHelper.showAlertDialog(context, "An error occured!", e.message.toString());
      print(e.toString());
    }

    if (credential != null) {
      String uid = credential.user!.uid;
      UserModel newUser =
          UserModel(uid: uid, email: email, fullname: "", profilepic: "");
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set(newUser.toMap())
          .then((value) {
        print("new user created!");
      });
      emailCtr.clear();
      passwordCtr.clear();
      cPasswordCtr.clear();
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return ComplateProfileScreen(
                userModel: newUser, FirebaseUser: credential!.user!);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                  height: 10,
                ),
                TextField(
                  controller: emailCtr,
                  decoration: InputDecoration(hintText: "Email Address"),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: passwordCtr,
                  decoration: InputDecoration(hintText: "Password"),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: cPasswordCtr,
                  decoration: InputDecoration(hintText: "Confirm Password"),
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: CupertinoButton(
                    color: AppColors.themeColor,
                    child: Text("Sign Up"),
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      checkValues();
    
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) {
                      //       return ComplateProfileScreen();
                      //     },
                      //   ),
                      // );
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
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
                "Already have an account?",
                style: TextStyle(fontSize: 16),
              ),
              CupertinoButton(
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          ),
        ),
      ),
    );
  }
}
