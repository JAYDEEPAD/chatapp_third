// import 'dart:io';
// import 'package:country_code_picker/country_code_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:ichat/allConstants/app_constants.dart';
// import 'package:ichat/allConstants/color_constants.dart';
// import 'package:ichat/allConstants/firestore_constants.dart';
// import 'package:ichat/allWidgets/loading_view.dart';
// import 'package:ichat/main.dart';
// import 'package:ichat/models/user_chat_model.dart';
// import 'package:ichat/providers/setting_provider.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';

// class SettingScreen extends StatefulWidget {
//   const SettingScreen({super.key});

//   @override
//   State<SettingScreen> createState() => _SettingScreenState();
// }

// class _SettingScreenState extends State<SettingScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: isWhite ? Colors.white : Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         iconTheme: IconThemeData(color: AppColors.primaryColor),
//         title: Text(
//           AppConstants.settingsTitle,
//           style: TextStyle(color: AppColors.primaryColor),
//         ),
//         elevation: 0,
//         centerTitle: true,
//       ),
//       body: SettingsScreen(),
//     );
//   }
// }

// class SettingsScreen extends StatefulWidget {
//   const SettingsScreen({super.key});

//   @override
//   State<SettingsScreen> createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends State<SettingsScreen> {
//   TextEditingController? controllerNickname;
//   TextEditingController? controllerAbouMe;

//   String dialCodeDigits = "+00";
//   final TextEditingController _controller = TextEditingController();

//   String id = "";
//   String nickname = "";
//   String aboutMe = "";
//   String photoUrl = "";
//   String phoneNumber = "";

//   bool isLoading = false;
//   File? avatarImageFile;
//   late SettingProvider settingProvider;

//   final FocusNode focusNodeNickname = FocusNode();
//   final FocusNode focusNodeAboutMe = FocusNode();

//   @override
//   void initState() {
//     super.initState();
//     settingProvider = context.read<SettingProvider>();
//     readLocal();
//   }

//   void readLocal() {
//     setState(() {
//       id = settingProvider.getPref(FirestoreConstants.id) ?? "";
//       nickname = settingProvider.getPref(FirestoreConstants.nickname) ?? "";
//       aboutMe = settingProvider.getPref(FirestoreConstants.aboutMe) ?? "";
//       photoUrl = settingProvider.getPref(FirestoreConstants.photoUrl) ?? "";
//       phoneNumber =
//           settingProvider.getPref(FirestoreConstants.phoneNumber) ?? "";
//     });

//     controllerNickname = TextEditingController(text: nickname);
//     controllerAbouMe = TextEditingController(text: aboutMe);
//   }

//   Future getImage() async {
//     ImagePicker imagePicker = ImagePicker();
//     XFile? pickedFile = await imagePicker
//         .pickImage(source: ImageSource.gallery)
//         .catchError((e) {
//       Fluttertoast.showToast(msg: e.toString());
//     });
//     File? image;
//     if (pickedFile != null) {
//       image = File(pickedFile.path);
//     }
//     if (image != null) {
//       setState(() {
//         avatarImageFile = image;
//         isLoading = true;
//       });
//       uploadFile();
//     }
//   }

//   Future uploadFile() async {
//     String filename = id;
//     UploadTask uploadTask =
//         settingProvider.uploadFile(avatarImageFile!, filename);
//     try {
//       TaskSnapshot snapshot = await uploadTask;
//       photoUrl = await snapshot.ref.getDownloadURL();
//       UserChatModel updateInfo = UserChatModel(
//           id: id,
//           photoURL: photoUrl,
//           nickname: nickname,
//           aboutMe: aboutMe,
//           phoneNumber: phoneNumber);
//       settingProvider
//           .updateDataFirestore(
//               FirestoreConstants.pathUserCollection, id, updateInfo.toJson())
//           .then((data) async {
//         await settingProvider.setPref(FirestoreConstants.photoUrl, photoUrl);
//         setState(() {
//           isLoading = false;
//         });
//       }).catchError((e) {
//         setState(() {
//           isLoading = false;
//         });
//         Fluttertoast.showToast(msg: e.toString());
//       });
//     } on FirebaseException catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       Fluttertoast.showToast(msg: e.message ?? e.toString());
//     }
//   }

//   void handleUpdateData() async {
//     focusNodeNickname.unfocus();
//     focusNodeAboutMe.unfocus();

//     setState(() {
//       isLoading = true;
//       if (dialCodeDigits != "+00" && _controller.text != "") {
//         phoneNumber = dialCodeDigits + _controller.text.toString();
//       }
//     });

//     UserChatModel updateInfo = UserChatModel(
//         id: id,
//         photoURL: photoUrl,
//         nickname: nickname,
//         aboutMe: aboutMe,
//         phoneNumber: phoneNumber);
//     settingProvider
//         .updateDataFirestore(
//             FirestoreConstants.pathUserCollection, id, updateInfo.toJson())
//         .then((data) async {
//       await settingProvider.setPref(FirestoreConstants.nickname, nickname);
//       await settingProvider.setPref(FirestoreConstants.aboutMe, aboutMe);
//       await settingProvider.setPref(FirestoreConstants.photoUrl, photoUrl);
//       await settingProvider.setPref(
//           FirestoreConstants.phoneNumber, phoneNumber);
//       setState(() {
//         isLoading = false;
//       });
//       Fluttertoast.showToast(msg: "Update success");
//     }).catchError((e) {
//       setState(() {
//         isLoading = false;
//       });
//       Fluttertoast.showToast(msg: e.toString());
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         SingleChildScrollView(
//           padding: EdgeInsets.only(left: 15, right: 15),
//           physics: PageScrollPhysics(),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               CupertinoButton(
//                 onPressed: getImage,
//                 child: Container(
//                   margin: EdgeInsets.all(20),
//                   child: avatarImageFile == null
//                       ? photoUrl.isNotEmpty
//                           ? ClipRRect(
//                               borderRadius: BorderRadius.circular(45),
//                               child: Image.network(
//                                 photoUrl,
//                                 fit: BoxFit.cover,
//                                 width: 90,
//                                 height: 90,
//                                 errorBuilder: (context, object, stackTrace) {
//                                   return Icon(
//                                     Icons.account_circle,
//                                     size: 90,
//                                     color: AppColors.greyColor,
//                                   );
//                                 },
//                                 loadingBuilder: (BuildContext context,
//                                     Widget child,
//                                     ImageChunkEvent? loadingProgress) {
//                                   if (loadingProgress == null) return child;
//                                   return Container(
//                                     width: 90,
//                                     height: 90,
//                                     child: Center(
//                                       child: CircularProgressIndicator(
//                                         color: AppColors.greyColor,
//                                         value: loadingProgress
//                                                         .expectedTotalBytes !=
//                                                     null &&
//                                                 loadingProgress
//                                                         .expectedTotalBytes !=
//                                                     null
//                                             ? loadingProgress
//                                                     .cumulativeBytesLoaded /
//                                                 loadingProgress
//                                                     .expectedTotalBytes!
//                                             : null,
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             )
//                           : Icon(
//                               Icons.account_circle,
//                               size: 90,
//                               color: AppColors.greyColor,
//                             )
//                       : ClipRRect(
//                           borderRadius: BorderRadius.circular(45),
//                           child: Image.file(
//                             avatarImageFile!,
//                             width: 90,
//                             height: 90,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                 ),
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     child: Text(
//                       "Name",
//                       style: TextStyle(
//                         fontStyle: FontStyle.italic,
//                         fontWeight: FontWeight.bold,
//                         color: AppColors.primaryColor,
//                       ),
//                     ),
//                     margin: EdgeInsets.only(
//                       left: 10,
//                       bottom: 5,
//                       top: 10,
//                     ),
//                   ),
//                   Container(
//                     margin: EdgeInsets.only(
//                       left: 30,
//                       right: 30,
//                     ),
//                     child: Theme(
//                       data: Theme.of(context).copyWith(
//                         primaryColor: AppColors.primaryColor,
//                       ),
//                       child: TextField(
//                         style: TextStyle(color: AppColors.greyColor),
//                         decoration: InputDecoration(
//                           enabledBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(color: AppColors.greyColor2),
//                           ),
//                           focusedBorder: UnderlineInputBorder(
//                             borderSide:
//                                 BorderSide(color: AppColors.primaryColor),
//                           ),
//                           hintText: "Write your name...",
//                           contentPadding: EdgeInsets.all(5),
//                           hintStyle: TextStyle(color: AppColors.greyColor),
//                         ),
//                         controller: controllerNickname,
//                         onChanged: (value) {
//                           nickname = value;
//                         },
//                         focusNode: focusNodeNickname,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     child: Text(
//                       "About me",
//                       style: TextStyle(
//                         fontStyle: FontStyle.italic,
//                         fontWeight: FontWeight.bold,
//                         color: AppColors.primaryColor,
//                       ),
//                     ),
//                     margin: EdgeInsets.only(
//                       left: 10,
//                       bottom: 5,
//                       top: 10,
//                     ),
//                   ),
//                   Container(
//                     margin: EdgeInsets.only(
//                       left: 30,
//                       right: 30,
//                     ),
//                     child: Theme(
//                       data: Theme.of(context).copyWith(
//                         primaryColor: AppColors.primaryColor,
//                       ),
//                       child: TextField(
//                         style: TextStyle(color: AppColors.greyColor),
//                         decoration: InputDecoration(
//                           enabledBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(color: AppColors.greyColor2),
//                           ),
//                           focusedBorder: UnderlineInputBorder(
//                             borderSide:
//                                 BorderSide(color: AppColors.primaryColor),
//                           ),
//                           hintText: "Write something about your self...",
//                           contentPadding: EdgeInsets.all(5),
//                           hintStyle: TextStyle(color: AppColors.greyColor),
//                         ),
//                         controller: controllerAbouMe,
//                         onChanged: (value) {
//                           aboutMe = value;
//                         },
//                         focusNode: focusNodeAboutMe,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     child: Text(
//                       "Phone No",
//                       style: TextStyle(
//                         fontStyle: FontStyle.italic,
//                         fontWeight: FontWeight.bold,
//                         color: AppColors.primaryColor,
//                       ),
//                     ),
//                     margin: EdgeInsets.only(
//                       left: 10,
//                       bottom: 5,
//                       top: 10,
//                     ),
//                   ),
//                   Container(
//                     margin: EdgeInsets.only(
//                       left: 30,
//                       right: 30,
//                     ),
//                     child: Theme(
//                       data: Theme.of(context).copyWith(
//                         primaryColor: AppColors.primaryColor,
//                       ),
//                       child: TextField(
//                         enabled: false,
//                         style: TextStyle(color: AppColors.greyColor),
//                         decoration: InputDecoration(
//                           hintText: phoneNumber,
//                           contentPadding: EdgeInsets.all(5),
//                           hintStyle: TextStyle(color: Colors.grey),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     margin: EdgeInsets.only(left: 10, top: 30, bottom: 5),
//                     child: SizedBox(
//                       width: 400,
//                       height: 60,
//                       child: CountryCodePicker(
//                         onChanged: (country) {
//                           setState(() {
//                             dialCodeDigits = country.dialCode!;
//                           });
//                         },
//                         initialSelection: "IN",
//                         showCountryOnly: false,
//                         showOnlyCountryWhenClosed: false,
//                         favorite: ["+1", "US", "+91", "IN"],
//                         textStyle: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     margin: EdgeInsets.only(
//                       left: 30,
//                       right: 30,
//                     ),
//                     child: TextField(
//                       style: TextStyle(color: AppColors.greyColor),
//                       decoration: InputDecoration(
//                         enabledBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(color: AppColors.greyColor2),
//                         ),
//                         focusedBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(color: AppColors.primaryColor),
//                         ),
//                         hintText: "Phone number",
//                         contentPadding: EdgeInsets.all(4),
//                         hintStyle: TextStyle(color: AppColors.greyColor),
//                         prefix: Padding(
//                           padding: EdgeInsets.all(4),
//                           child: Text(
//                             dialCodeDigits,
//                             style: TextStyle(color: Colors.grey),
//                           ),
//                         ),
//                       ),
//                       controller: _controller,
//                       maxLength: 12,
//                       keyboardType: TextInputType.number,
//                     ),
//                   ),
//                 ],
//               ),
//               Container(
//                 margin: EdgeInsets.only(top: 50, bottom: 50),
//                 child: MaterialButton(
//                   onPressed: handleUpdateData,
//                   child: Padding(
//                     padding: EdgeInsets.only(left: 15,right: 15),
//                     child: Text("Update Now",
//                         style: TextStyle(fontSize: 16, color: Colors.white)),
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   color: AppColors.primaryColor,
//                 ),
//               )
//             ],
//           ),
//         ),
//         Positioned(
//           child: isLoading ? LoadingView() : SizedBox.shrink(),
//         ),
//       ],
//     );
//   }
// }
