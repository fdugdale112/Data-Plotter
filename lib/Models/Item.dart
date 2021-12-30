class Item{
  Item(this.data){
    timeStamp = DateTime.now();
  }

  String data;
  late DateTime timeStamp;

  String get readableDate{
    return timeStamp.hour.toString() + ":" + timeStamp.minute.toString() + ":" + timeStamp.second.toString();
  }
}