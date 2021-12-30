import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';

import '../Models/DataSource.dart';
import '../Models/Item.dart';

class DataSourceWidget extends StatefulWidget {
  final int? width;
  final int? height;
  final DataSource dataSource;

  const DataSourceWidget({Key? key, required this.dataSource, this.width, this.height}) : super(key: key);

  @override
  _DataSourceWidgetState createState() => _DataSourceWidgetState();
}

class _DataSourceWidgetState extends State<DataSourceWidget> {




  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1000,
      height: 600,
      color: Colors.black87,
      child: Column(
        children: [
          Text(widget.dataSource.topic),
          //Text(widget.dataSource.client.connectionStatus.toString()),
          //Text(widget.dataSource.client.useAlternateWebSocketImplementation),

          FutureBuilder(
              future: widget.dataSource.connectingFuture,
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.done) {
                  return StreamBuilder<Item>(
                      stream: widget.dataSource.updates,
                      builder: (context, snapshot) {
                        if(snapshot.hasData) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[

                              LineGraph(
                                features: [  Feature(
                                  title: "Drink Water",
                                  color: Colors.blue,
                                  data: widget.dataSource.data.map((e) => double.parse(e.data)).toList(),
                                ),],
                                size: Size(MediaQuery.of(context).size.width * 0.8, MediaQuery.of(context).size.height * 0.8),
                                labelX: widget.dataSource.data.map((e) => e.readableDate).toList(),
                                labelY: widget.dataSource.data.map((e) => e.data).toList(),
                                showDescription: true,
                                graphColor: Colors.white30,
                                graphOpacity: 0.2,
                                verticalFeatureDirection: true,
                                descriptionHeight: 40,
                              ),

                            ],
                          );

                          return Column(
                            children: [
                              Text(snapshot.data?.timeStamp.toString() ?? "??"),
                              Text(snapshot.data?.data ?? "??"),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      });
                }
                return const SizedBox.shrink();
              }
          )
        ],
      ),
    );
  }
}
