import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotter/Components/screens/chat/model.dart';
import 'package:spotter/core/endpoints.dart';
import 'package:spotter/core/http.dart';
import 'package:spotter/providers/app_state.dart';

Future<ChatListModel> getChats(BuildContext context) async {
  try {
    final api = HttpClient(productionApiUrls.user);
    final result = await api.get("/chat/get_channels", withAuthHeaders: true);
    if (result['statusCode'] == 200) {
      Provider.of<AppState>(context, listen: false).resetNewMessageIndicator();
      return ChatListModel.fromJSON(result["channels"]);
    }
    return ChatListModel.fromJSON([]);
  } catch (e) {
    print('error - $e');
    return ChatListModel.fromJSON([]);
  }
}

Future<String> createChannel(BuildContext context, String target) async {
  try {
    final api = HttpClient(productionApiUrls.user);
    final result = await api.post(
        "/chat/create_channel", {"targetPermalink": target},
        withAuthHeaders: true);
    if (result["statusCode"] == 200) {
      return result["channel"];
    }
    return "";
  } catch (e) {
    print('error - $e');
    return "";
  }
}
