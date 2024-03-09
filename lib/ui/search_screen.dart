import 'package:chatapp_third/allConstants/color_constants.dart';
import 'package:chatapp_third/main.dart';
import 'package:chatapp_third/models/chat_room_model.dart';
import 'package:chatapp_third/models/user_model.dart';
import 'package:chatapp_third/ui/chat_room_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SearchScreen extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const SearchScreen(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchCtr = TextEditingController();

  Future<ChatRoomModel?> getChatRoomModel(UserModel targetUser) async {
    ChatRoomModel chatRoom;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.${widget.userModel.uid}", isEqualTo: true)
        .where("participants.${targetUser.uid}", isEqualTo: true)
        .get();

    if (snapshot.docs.length > 0) {
      //fetch existing chat
      print("chatroom alreday created");
      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatRoom =
          ChatRoomModel.fromMap(docData as Map<String, dynamic>);
      chatRoom = existingChatRoom;
    } else {
      //create a new one
      print("chatroom not created");
      ChatRoomModel newChatRoom = ChatRoomModel(
        chatroomid: uuid.v1(),
        lastMessage: "",
        participants: {
          widget.userModel.uid.toString(): true,
          targetUser.uid.toString(): true
        },
        users: [widget.userModel.uid.toString(), targetUser.uid.toString()],
        createdon: Timestamp.now(),
      );

      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(newChatRoom.chatroomid)
          .set(newChatRoom.toMap());

      chatRoom = newChatRoom;
      print("new chatroom created");
    }
    return chatRoom;
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
          title: Text("Search"),
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchCtr,
                        decoration: InputDecoration(hintText: "Search User"),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: AppColors.themeColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          setState(() {});
                        },
                        icon: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .where("fullname", isNotEqualTo: widget.userModel.fullname)
                        .where("fullname", isEqualTo: searchCtr.text)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        if (snapshot.hasData) {
                          QuerySnapshot datasnapshot =
                              snapshot.data as QuerySnapshot;
                    
                          if (datasnapshot.docs.length > 0) {
                            Map<String, dynamic> userMap =
                                datasnapshot.docs[0].data() as Map<String, dynamic>;
                            UserModel searchedUser = UserModel.fromMap(userMap);
                            return Column(
                              children: [
                                ListTile(
                                  title: Text(searchedUser.fullname.toString()),
                                  subtitle: Text(searchedUser.email.toString()),
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(searchedUser.profilepic!),
                                    backgroundColor:
                                        AppColors.greyColor.withOpacity(0.5),
                                  ),
                                  onTap: () async {
                                    ChatRoomModel? chatRoomModel =
                                        await getChatRoomModel(searchedUser);
                    
                                    if (chatRoomModel != null) {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return ChatRoomScreen(
                                              targetUser: searchedUser,
                                              userUser: widget.userModel,
                                              firebaseUser: widget.firebaseUser,
                                              chatRoom: chatRoomModel,
                                            );
                                          },
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            );
                          } else {
                            return Center(child: Text("No result found!"));
                          }
                        } else if (snapshot.hasError) {
                          return Center(child: Text("An error occured!"));
                        } else {
                          return Center(child: Text("No result found!"));
                        }
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
