
import 'package:data_plotter/Models/DataSource.dart';

import '../TopicsAndKeys.dart';

class DataPlotter {
  static final DataPlotter instance = DataPlotter._internal();

  factory DataPlotter() {
    return instance;
  }

  DataPlotter._internal(){
    sources = List.empty(growable: true);
    
    addSource(DataSource(MQTT_SERVER, TEMPERATURE_TOPIC, IO_USERNAME, IO_KEY, descriptor: "°C", name: "Temperature"));
    addSource(DataSource(MQTT_SERVER, HUMIDITY_TOPIC, IO_USERNAME, IO_KEY, descriptor: "%", name: "Humidity"));

  }

  late List<DataSource> sources;
  
  void addSource(DataSource source){
    sources.add(source);
  }
}