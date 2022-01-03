import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mqtt_client/mqtt_client.dart';

import '../Models/DataSource.dart';
import '../Models/Item.dart';
import 'LineGraph.dart';

class DataSourceWidget extends StatefulWidget {
  final double? width;
  final double? height;
  final DataSource dataSource;

  const DataSourceWidget({Key? key, required this.dataSource, this.width, this.height}) : super(key: key);

  @override
  _DataSourceWidgetState createState() => _DataSourceWidgetState();
}

class _DataSourceWidgetState extends State<DataSourceWidget> {




  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.black87,
      child: FutureBuilder(
          future: widget.dataSource.connectingFuture,
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done) {
              return StreamBuilder<Item>(
                  stream: widget.dataSource.updates,
                  builder: (context, snapshot) {
                    if(snapshot.hasData) {
                      return Column(

                        children: <Widget>[


                          Expanded(
                            flex: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: LineGraph(items: widget.dataSource.data),
                            ),
                          ),


                          Container(
                            color: Colors.red,
                            child: Align(
                              alignment: Alignment.centerLeft,

                              child: FittedBox(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text(widget.dataSource.title, style: TextStyle(color: Colors.white70, fontSize: 45)),

                                      SizedBox(width: 50),

                                      Text((snapshot.data?.data ?? "??") + widget.dataSource.descriptor,
                                        style: TextStyle(color: Colors.white70, fontSize: 45),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    return loading();
                  });
            }
            return loading();
          }
      ),
    );
  }

  Widget loading(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FittedBox(child: SpinKitFadingCube( color: Theme.of(context).primaryColor,)),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: FittedBox(child: Text(widget.dataSource.title, style: TextStyle(color: Colors.white70, fontSize: 45))),
        ),
      ],
    );
  }
}
