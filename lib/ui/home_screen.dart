import 'package:chatapp_third/allConstants/color_constants.dart';
import 'package:chatapp_third/helper/firebase_helper.dart';
import 'package:chatapp_third/models/chat_room_model.dart';
import 'package:chatapp_third/models/user_model.dart';
import 'package:chatapp_third/ui/chat_room_screen.dart';
import 'package:chatapp_third/ui/login_screen.dart';
import 'package:chatapp_third/ui/realtime_databse/realtime_data_screen.dart';
import 'package:chatapp_third/ui/search_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  HomeScreen({super.key, required this.userModel, required this.firebaseUser});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final GoogleSignIn googleSignIn = GoogleSignIn();
  // final ScrollController listScrollController = ScrollController();

  // // int _limit = 20;
  // // int _limitIncrement = 20;
  // bool isLoading = false;

  // late String currentUserId;
  // late AuthProvider authProvider;
  // // late HomeProvider homeProvider;
  // List<PopupChoicesModel> choices = <PopupChoicesModel>[
  //   PopupChoicesModel(title: 'Settings', icon: Icons.settings),
  //   PopupChoicesModel(title: 'Sign out', icon: Icons.exit_to_app)
  // ];

  // void handleSignOut() async {
  //   authProvider.handleSignOut();
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => LoginScreen(),
  //     ),
  //   );
  // }

  // void scrollListener() {
  //   if (listScrollController.offset >=
  //           listScrollController.position.maxScrollExtent &&
  //       listScrollController.position.outOfRange) {
  //     setState(() {
  //       _limit += _limitIncrement;
  //     });
  //   }
  // }

  // void onItemMenuPress(PopupChoicesModel choicesModel) {
  //   if (choicesModel.title == "Sign out") {
  //     handleSignOut();
  //   } else {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => SettingScreen(),
  //       ),
  //     );
  //   }
  // }

  // Widget buildPopupMenu() {
  //   return PopupMenuButton<PopupChoicesModel>(
  //       icon: Icon(
  //         Icons.more_vert,
  //         color: Colors.grey,
  //       ),
  //       onSelected: onItemMenuPress,
  //       itemBuilder: (BuildContext context) {
  //         return choices.map((PopupChoicesModel choice) {
  //           return PopupMenuItem(
  //             value: choice,
  //             child: Row(
  //               children: <Widget>[
  //                 Icon(
  //                   choice.icon,
  //                   color: AppColors.primaryColor,
  //                 ),
  //                 Container(
  //                   width: 10,
  //                 ),
  //                 Text(
  //                   choice.title,
  //                   style: TextStyle(color: AppColors.primaryColor),
  //                 )
  //               ],
  //             ),
  //           );
  //         }).toList();
  //       });
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   authProvider = context.read<AuthProvider>();
  //   // homeProvider = context.read<HomeProvider>();
  //   if (authProvider.getUserFirebaseId()?.isNotEmpty == true) {
  //     currentUserId = authProvider.getUserFirebaseId()!;
  //   } else {
  //     Navigator.of(context).pushAndRemoveUntil(
  //         MaterialPageRoute(builder: (context) => LoginScreen()),
  //         (Route<dynamic> route) => false);
  //   }
  //   listScrollController.addListener(scrollListener);
  // }
  //  appBar: AppBar(
  //         backgroundColor: isWhite ? Colors.white : Colors.black,
  //         leading: IconButton(
  //           onPressed: () {},
  //           icon: Switch(
  //             activeColor: Colors.white,
  //             activeTrackColor: Colors.black,
  //             inactiveTrackColor: Colors.white,
  //             inactiveThumbColor: Colors.black54,
  //             value: isWhite,
  //             onChanged: (value) {
  //               setState(() {
  //                 isWhite = value;
  //                 print(isWhite);
  //               });
  //             },
  //           ),
  //         ),
  //         actions: [buildPopupMenu()],
  //       ),
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("Chat App"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () async {
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return RealtimeDatabaseScreen();
                }));
              },
              icon: Icon(Icons.drive_file_rename_outline_sharp)),
          SizedBox(
            width: 10,
          ),
          IconButton(
            onPressed: () async {
              // Navigator.push(context, MaterialPageRoute(builder: (context) {
              //   return VideoScreen();
              // }));
            },
            icon: Icon(Icons.video_collection),
          ),
          SizedBox(
            width: 10,
          ),
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return LoginScreen();
                }));
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),

      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return SearchScreen(
                          userModel: widget.userModel,
                          firebaseUser: widget.firebaseUser);
                    }));
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.search),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(child: Text("Search User")),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: AppColors.themeColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("chatrooms")
                      .where("users", arrayContains: widget.userModel.uid)
                      .orderBy("createdon")
                      .where("participants.${widget.userModel.uid}",
                          isEqualTo: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        QuerySnapshot chatRoomSnapshot =
                            snapshot.data as QuerySnapshot;
                        return ListView.builder(
                          itemCount: chatRoomSnapshot.docs.length,
                          itemBuilder: (context, index) {
                            ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                                chatRoomSnapshot.docs[index].data()
                                    as Map<String, dynamic>);
                            Map<String, dynamic> participants =
                                chatRoomModel.participants!;
                            List<String> participantsKey =
                                participants.keys.toList();
                            participantsKey.remove(widget.userModel.uid);
                            return FutureBuilder(
                              future: FirebaseHelper.getUserModelById(
                                  participantsKey[0]),
                              builder: (context, userData) {
                                if (userData.connectionState ==
                                    ConnectionState.done) {
                                  if (userData.data != null) {
                                    UserModel targetUser =
                                        userData.data as UserModel;
                                    return ListTile(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return ChatRoomScreen(
                                            chatRoom: chatRoomModel,
                                            firebaseUser: widget.firebaseUser,
                                            userUser: widget.userModel,
                                            targetUser: targetUser,
                                          );
                                        }));
                                      },
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            targetUser.profilepic.toString()),
                                      ),
                                      title:
                                          Text(targetUser.fullname.toString()),
                                      subtitle: chatRoomModel.lastMessage
                                                  .toString() !=
                                              ""
                                          ? Text(chatRoomModel.lastMessage
                                              .toString())
                                          : Text("Say hi to your new friend!"),
                                    );
                                  } else {
                                    return Container();
                                  }
                                } else {
                                  return Container();
                                }
                              },
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      } else {
                        return Center(
                          child: Text("No Chats"),
                        );
                      }
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   elevation: 0,
      //   onPressed: () {
      //     Navigator.push(context, MaterialPageRoute(builder: (context) {
      //       return SearchScreen(
      //           userModel: widget.userModel, firebaseUser: widget.firebaseUser);
      //     }));
      //   },
      //   child: Icon(Icons.search),
      // ),
    );
  }
}
