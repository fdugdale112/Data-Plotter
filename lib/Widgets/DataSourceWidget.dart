import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';

import '../Models/DataSource.dart';
import '../Models/Item.dart';
import 'LineGraph.dart';

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
      child: FutureBuilder(
          future: widget.dataSource.connectingFuture,
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done) {
              return StreamBuilder<Item>(
                  stream: widget.dataSource.updates,
                  builder: (context, snapshot) {
                    if(snapshot.hasData) {
                      return Stack(

                        children: <Widget>[

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: LineGraph(items: widget.dataSource.data),
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
      ),
    );
  }
}
