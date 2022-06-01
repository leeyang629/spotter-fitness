class ChatModel {
  String channel;
  String permalink;
  String imageUrl;
  String name = "";
  ChatModel(this.channel, this.permalink, this.imageUrl, this.name);
}

class ChatListModel {
  List<ChatModel> chatList = [];

  ChatListModel.fromJSON(List<dynamic> json) {
    json.forEach((dynamic chat) {
      chatList.add(new ChatModel(chat["channel"], chat["userPermalink"],
          chat["imageURL"], chat["firstName"]));
    });
  }
}
