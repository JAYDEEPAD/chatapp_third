import 'package:chatapp_third/allConstants/constants.dart';
import 'package:chatapp_third/helper/realtime_helper.dart';
import 'package:chatapp_third/models/realtime_message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';


class RealtimeDatabaseScreen extends StatefulWidget {
  const RealtimeDatabaseScreen({super.key});

  @override
  State<RealtimeDatabaseScreen> createState() => _RealtimeDatabaseScreenState();
}

class _RealtimeDatabaseScreenState extends State<RealtimeDatabaseScreen> {
  TextEditingController messageCtr = TextEditingController();
  late DatabaseReference ref;
  void sendMessage() async {
    String msg = messageCtr.text.trim();
    messageCtr.clear();
    if (msg.isNotEmpty) {
      RealtimeDatabase.write(
        
        data: {
          'message': msg.toString(),
        },
      );

      print("message sent");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection("data").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot datasnapshot =
                          snapshot.data as QuerySnapshot;

                      return ListView.builder(
                        reverse: true,
                        itemCount: datasnapshot.docs.length,
                        itemBuilder: (context, index) {
                          RealtimeMessageModel currentMessage =
                              RealtimeMessageModel.fromJson(
                                  datasnapshot.docs[index].data()
                                      as Map<String, dynamic>);
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  margin: EdgeInsets.symmetric(vertical: 3),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    currentMessage.text.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  )),
                            ],
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                            "An error occured! Please check your internet conection."),
                      );
                    } else {
                      return Center(
                        child: Text("Say hi to your new friend"),
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
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: AppColors.greyColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: messageCtr,
                      maxLines: 3,
                      minLines: 1,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: "Enter Message"),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.greyColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(50)),
                  child: IconButton(
                    onPressed: () {
                      sendMessage();
                    },
                    icon: Icon(
                      Icons.send,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      )),
    );
  }
}
