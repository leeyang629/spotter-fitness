import 'package:pubnub/pubnub.dart';

PubNub initiatePubNub(String permalink) {
  var pubnub = PubNub(
      defaultKeyset: Keyset(
          subscribeKey: 'sub-c-fd539ec2-1d47-11ec-a975-faf056e3304c',
          publishKey: 'pub-c-94373fba-62a8-4de4-8deb-92eb301fded6',
          uuid: UUID(permalink)));
  return pubnub;
}

subscribeToChannel(String permalink, PubNub pubnub) async {
  var channelGroup = "$permalink-group";
  await pubnub.channelGroups.addChannels(channelGroup, {'$permalink-dummy'});
}
