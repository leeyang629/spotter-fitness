import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotter/Components/common/LoadingIndicator.dart';
import 'package:spotter/Components/common/profilePic.dart';
import 'package:spotter/Components/screens/chat/api.dart';
import 'package:spotter/Components/screens/chat/chat_details.dart';
import 'package:spotter/Components/screens/chat/model.dart';
import 'package:spotter/providers/app_state.dart';
import 'package:spotter/utils/retry.dart';
import 'package:spotter/utils/userDataLoad.dart';

class Chat extends StatefulWidget {
  @override
  ComponentState createState() => ComponentState();
}

class ComponentState extends State<Chat> {
  Future<ChatListModel> response;
  @override
  void initState() {
    super.initState();
    response = getChats(context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(216, 150, 21, 1),
            title: Text(
              "Chat",
            ),
            centerTitle: true,
          ),
          body: FutureBuilder(
              future: response,
              builder: (BuildContext context,
                  AsyncSnapshot<ChatListModel> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return LoadingIndicator();
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      print("error");
                      print(snapshot.error.toString());
                      if (snapshot.error.toString() ==
                          "Exception: Invalid session") {
                        goToLoginPage(context);
                        return Container();
                      } else {
                        return retry("Error fetching chats", () {
                          setState(() {
                            response = getChats(context);
                          });
                        });
                      }
                    }
                    if (snapshot.data.chatList.length == 0) {
                      return retry("No chat history found", () {
                        setState(() {
                          response = getChats(context);
                        });
                      });
                    }
                    return Container(
                      child: ListView(
                        children: snapshot.data.chatList
                            .map((val) => chatRow(val))
                            .toList(),
                      ),
                    );
                    break;
                  default:
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(children: []),
                    );
                }
              })),
    ]);
  }

  Widget chatRow(ChatModel chat) {
    return InkWell(
      onTap: () {
        Provider.of<AppState>(context, listen: false)
            .setCurrentRoute("/chat_details");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    ChatDetails(chat.name, chat.channel, chat.permalink, "")));
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            border: Border(top: BorderSide(width: 0.5, color: Colors.grey))),
        height: 80,
        child: Row(
          children: [
            ProfilePic(60,
                color: Colors.black, cache: false, imageUrl: chat.imageUrl),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 16),
              child: Text(chat.name, style: TextStyle(fontSize: 20)),
            )
          ],
        ),
      ),
    );
  }
}
