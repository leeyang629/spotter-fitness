import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:spotter/Components/common/LoadingIndicator.dart';
import 'package:spotter/Components/screens/chat/api.dart';
import 'package:spotter/Components/screens/layout/Layout.dart';
import 'package:spotter/providers/app_state.dart';
import 'package:spotter/utils/chat_subscription.dart';
import 'package:spotter/utils/dateTimeUtils.dart';
import 'package:spotter/utils/retry.dart';
import 'package:spotter/utils/userDataLoad.dart';
import 'package:pubnub/pubnub.dart';
import 'package:spotter/utils/utils.dart';

class ChatDetails extends StatefulWidget {
  final String name;
  final String channel;
  final String permalink;
  final String targetUserRole;
  ChatDetails(this.name, this.channel, this.permalink, this.targetUserRole);
  @override
  ComponentState createState() => ComponentState();
}

class ComponentState extends State<ChatDetails> {
  Future response;
  ScrollController _scrollController;
  TextEditingController message = TextEditingController(text: "");
  final chats = [];
  bool _needsScroll = false;
  String channelName = "";
  PubNub pubnub;
  Subscription subscription;
  bool disableSending = true;
  @override
  void initState() {
    super.initState();
    response = Future.delayed(Duration(milliseconds: 200), () {
      return 2;
    });
    _scrollController = new ScrollController();
    pubnub = initiatePubNub(
        Provider.of<AppState>(context, listen: false).userPermalink);
    pubnubSimulation();
  }

  createConnection() async {
    final userPeramlink =
        Provider.of<AppState>(context, listen: false).userPermalink;
    var channelName = "";
    // Form channel name alphabetically for consistency
    if (userPeramlink.compareTo(widget.permalink) < 0) {
      channelName = "${userPeramlink}_${widget.permalink}";
    } else {
      channelName = "${widget.permalink}_$userPeramlink";
    }
    // Create groups and add channels to them
    await pubnub.channelGroups
        .addChannels("$userPeramlink-group", {channelName});
    await pubnub.channelGroups
        .addChannels("${widget.permalink}-group", {channelName});
    var result =
        await pubnub.channelGroups.listChannels("srinivasb-srinivasb-group");
    print(result.channels);
    return channelName;
  }

  pubnubSimulation() async {
    // Subscribe to a channel
    // var channel = await createConnection();
    var channel = await createChannel(context, widget.permalink);
    setState(() {
      channelName = channel;
    });
    if (channel != "") {
      var history = pubnub.channel(channel).history(chunkSize: 100);
      await history.more();
      history.messages.forEach((message) {
        setState(() {
          if (message.content["sender"] ==
              Provider.of<AppState>(context, listen: false).userPermalink)
            chats.insert(0, {
              "side": "right",
              "message": message.content["content"]["message"],
              "time": formatDateTime(message.publishedAt.toDateTime())
            });
          else
            chats.insert(0, {
              "side": "left",
              "message": message.content["content"]["message"],
              "time": formatDateTime(message.publishedAt.toDateTime())
            });
        });
      });
      subscription = pubnub.subscribe(channels: {channel});
      subscription.messages.listen((message) {
        setState(() {
          if (message.payload["sender"] ==
              Provider.of<AppState>(context, listen: false).userPermalink)
            chats.insert(0, {
              "side": "right",
              "message": message.payload["content"]["message"],
              "time": formatDateTime(message.publishedAt.toDateTime())
            });
          else
            chats.insert(0, {
              "side": "left",
              "message": message.payload["content"]["message"],
              "time": formatDateTime(message.publishedAt.toDateTime())
            });
        });
      });
      setState(() {
        disableSending = false;
      });
    }
  }

  _scrollToEnd() async {
    _scrollController.jumpTo(0);
  }

  @override
  Widget build(BuildContext context) {
    if (_needsScroll) {
      SchedulerBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
      _needsScroll = false;
    }
    return Layout(
      FutureBuilder(
          future: response,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                    return retry("Error fetching chats", () {});
                  }
                }
                return Column(
                  children: [
                    Expanded(
                      child: ListView(
                        reverse: true,
                        shrinkWrap: true,
                        controller: _scrollController,
                        padding: EdgeInsets.all(8),
                        children: chats.map((val) => messageRow(val)).toList(),
                      ),
                    ),
                    sendMessage()
                  ],
                );
                break;
              default:
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(children: []),
                );
            }
          }),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(216, 150, 21, 1),
        title: InkWell(
          onTap: () {
            if (isNotEmpty(widget.targetUserRole)) {
              if (widget.targetUserRole == "trainer") {
                Navigator.pushNamed(context, '/trainer_profile',
                    arguments: {"permalink": widget.permalink});
              }
              if (widget.targetUserRole == "user") {
                Navigator.pushNamed(context, '/user_profile',
                    arguments: {"permalink": widget.permalink});
              }
            }
          },
          child: Text(
            widget.name,
          ),
        ),
        centerTitle: true,
      ),
      noPadding: true,
      headerVisible: false,
    );
  }

  Widget messageRow(dynamic value) {
    return Container(
      margin: EdgeInsets.all(8),
      alignment: value["side"] == "left"
          ? Alignment.centerLeft
          : Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: value["side"] == "left"
                ? Color.fromRGBO(15, 32, 84, 1)
                : Color.fromRGBO(232, 44, 53, 1),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value["message"] ?? "",
              style:
                  TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              value["time"] ?? "",
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 8,
                  // fontWeight: FontWeight.w500,
                  color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  Widget sendMessage() => TextField(
      controller: message,
      readOnly: disableSending,
      decoration: InputDecoration(
          suffixIcon: InkWell(
              onTap: () async {
                if (message.text != "") {
                  setState(() {
                    _needsScroll = true;
                  });
                  pubnub.publish(
                    channelName,
                    {
                      "content": {
                        "message": message.text,
                      },
                      "sender": Provider.of<AppState>(context, listen: false)
                          .userPermalink
                    },
                  );
                  pubnub.publish(
                    "${widget.permalink}-dummy",
                    notifcationPayload(),
                  );
                  message.text = "";
                }
              },
              child: Icon(Icons.send)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(216, 216, 216, 1))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(216, 216, 216, 1))),
          filled: true,
          hintText: "Type a message",
          fillColor: Color.fromRGBO(216, 216, 216, 1)));

  notifcationPayload() {
    return {
      "pn_debug": true,
      "pn_gcm": {
        "notification": {
          "title":
              "New message from ${Provider.of<AppState>(context, listen: false).userName}",
          "body": "Tap to open",
        },
        "data": {
          "topic": "spotter-chat",
          "targetUserId":
              Provider.of<AppState>(context, listen: false).userPermalink,
          "targetUserName":
              Provider.of<AppState>(context, listen: false).userName,
          "targetUserRole": ""
        },
      },
      "pn_apns": {
        "aps": {
          "alert": {
            "title":
                "New message from ${Provider.of<AppState>(context, listen: false).userName}",
            "body": "Tap to open"
          },
        },
        "content_available": true,
        "custom-keys": {
          "topic": "spotter-chat",
          "targetUserId":
              Provider.of<AppState>(context, listen: false).userPermalink,
          "targetUserName":
              Provider.of<AppState>(context, listen: false).userName,
          "targetUserRole": ""
        },
        "pn_push": [
          {
            "push_type": "alert",
            "auth_method": "token",
            "targets": [
              {
                "environment": "development",
                "topic": "com.camsilu.spotter",
              }
            ],
            "version": "v2"
          }
        ]
      }
    };
  }

  @override
  void dispose() async {
    super.dispose();
    // Unsubscribe and quit
    await subscription.dispose();
  }
}
