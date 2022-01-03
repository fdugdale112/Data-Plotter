import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:uuid/uuid.dart';

import '../Constants.dart';
import 'Item.dart';

class DataSource{

  DataSource(this.server, this.topic, this.username, this.key, {this.descriptor = "", this.name}){
    _client = MqttServerClient.withPort(server, id, 1883);
    data = List.empty(growable: true);
    //client.keepAlivePeriod = 300;
    connect();
  }


  Future<void> connect(){
    connectingFuture = _initialise();
    return connectingFuture;
  }

  Future<void> _initialise() async{
    try {
      var connectionStatus = await _client.connect(username, key);
      if (connectionStatus?.state == MqttConnectionState.connected)
      {
          subscription = _client.subscribe(topic, MqttQos.atLeastOnce);
          //_client.autoReconnect = true;
          // subscription?.changes.listen((event) {
          //   print(event);
          // });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      _client.disconnect();
    }

  }

  late Future<void> connectingFuture;

  late MqttServerClient _client;
  Subscription? subscription;

  bool get connected => subscription != null;
  String get title => name ?? topic;
  Stream<Item>? get updates => _client.updates?.map(initialiseItem);

  String id = clientIdentifier;
  String topic;
  String server;
  String username;
  String key;
  String descriptor;
  String? name;
  late List<Item> data;

  Item initialiseItem(List<MqttReceivedMessage<MqttMessage>> event) {
    final recMess = event[0].payload as MqttPublishMessage;
    final stringPayload = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    var item = Item(stringPayload);
    data.add(item);
    return item;
  }
}
