import 'dart:io';
import 'dart:math';

import 'package:chatapp_third/allConstants/constants.dart';
import 'package:chatapp_third/helper/ui_helper.dart';
import 'package:chatapp_third/models/user_model.dart';
import 'package:chatapp_third/ui/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ComplateProfileScreen extends StatefulWidget {
  final UserModel userModel;
  final User FirebaseUser;
  ComplateProfileScreen(
      {super.key, required this.userModel, required this.FirebaseUser});

  @override
  State<ComplateProfileScreen> createState() => _ComplateProfileScreenState();
}

class _ComplateProfileScreenState extends State<ComplateProfileScreen> {
  File? imageFile;
  TextEditingController fullNameCtr = TextEditingController();

  void selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      cropImage(pickedFile);
      // setState(() {
      //   imageFile = File(pickedFile.path);
      // });
    }
  }

  void cropImage(XFile file) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 20);
    if (croppedImage != null) {
      setState(() {
        imageFile = File(croppedImage.path);
      });
    }
  }

  void showPhotoOption() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Upload Profile Picture"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.gallery);
                },
                leading: Icon(Icons.photo_album),
                title: Text("Select from Gallery"),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.camera);
                },
                leading: Icon(Icons.camera_alt),
                title: Text("Take a Photo"),
              )
            ],
          ),
        );
      },
    );
  }

  void checkValues() {
    String fullname = fullNameCtr.text;
    if (fullname == null || imageFile == "") {
      UiHelper.showAlertDialog(
          context, "Incomplete Data", "please fill all the fields!");
      print("please fill all the fields");
    } else {
      uploadData();
      print("uploading data...");
    }
  }

  void uploadData() async {
    UiHelper.showLoadingDialog(context);
    UploadTask uploadTask = FirebaseStorage.instance
        .ref("profilepictures")
        .child(widget.userModel.uid.toString())
        .putFile(imageFile!);
    TaskSnapshot snapshot = await uploadTask;
    String? imageUrl = await snapshot.ref.getDownloadURL();
    String? fullname = fullNameCtr.text;

    widget.userModel.fullname = fullname;
    widget.userModel.profilepic = imageUrl;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userModel.uid)
        .set(widget.userModel.toMap())
        .then((value) {
      // sometime print not work user log log dart development
      // log("data uploaded");
      print("data uploaded");
      fullNameCtr.clear();
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return HomeScreen(
                userModel: widget.userModel, firebaseUser: widget.FirebaseUser);
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Complate Profile"),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Container(
            child: ListView(
              children: [
                SizedBox(height: 20),
                CupertinoButton(
                  onPressed: () {
                    showPhotoOption();
                  },
                  padding: EdgeInsets.zero,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage:
                        imageFile != null ? FileImage(imageFile!) : null,
                    child: imageFile == null
                        ? Icon(
                            Icons.person,
                            size: 60,
                          )
                        : null,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: fullNameCtr,
                  decoration: InputDecoration(labelText: "Full Name"),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: CupertinoButton(
                    child: Text("Submit"),
                    onPressed: () {
                      checkValues();
                    },
                    color: AppColors.themeColor,
                  ),
                )
              ],
            ),
          ),
        )),
      ),
    );
  }
}
