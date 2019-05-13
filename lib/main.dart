import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
//import 'package:url_launcher/url_launcher.dart';

Map _data;
List _quakeList;

void main() async{

  _data = await getQuakes();
  _quakeList = _data['features'];

  runApp(new MaterialApp(
    title: "Quakes",
    home: new Quake(),
  ));

}

class Quake extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          "Quakes",
          style: new TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
      ),
      body: new Center(
        child: new ListView.builder(
          itemCount: _quakeList.length,
          padding: const EdgeInsets.all(16.0),
          itemBuilder: (BuildContext context, int position){

            if (position.isOdd){
              return new Divider(
                color: Colors.grey.shade700,
                height: 3.0,
              );
            }

            var index = position ~/2;

            var _formattedDate = new DateFormat.yMMMMd('en_US').add_jm();
            var _date = _formattedDate.format(new DateTime.fromMicrosecondsSinceEpoch(_quakeList[index]['properties']['time']*1000, isUtc: true));

            // creating the rows fot our list view
            return new ListTile(
              title: new Text(
                  '$_date'
              ),
              subtitle: new Text(
                  '${_quakeList[index]['properties']['place']}',
                style: new TextStyle(
                  color: Colors.grey.shade700,
                  fontStyle: FontStyle.italic,
                ),
              ),
              leading: new CircleAvatar(
                backgroundColor: Colors.greenAccent,
                child: new Text(
                    '${_quakeList[index]['properties']['mag']}',
                  style: new TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              onTap: () {_showAlertMessage(context, "${_quakeList[index]['properties']['url']}");},
            );
          },
        ),
      ),
    );
  }
}

void _showAlertMessage(BuildContext context, String message) {
  var _alert = new AlertDialog(
    title: new Text(
      "For more details",
      style: new TextStyle(
        color: Colors.black87,
      ),
    ),
    content: new Text(message),
    actions: <Widget>[
      new FlatButton(
        onPressed: () => Navigator.pop(context),
        child: new Text(
          'OK'
        ),
      )
    ],
  );
  showDialog(context: context, builder: (context){
    return _alert;
  });
}

/*_launchURL() async {
  var quakeUrl = 'https://flutter.io';
  if (await canLaunch(quakeUrl)) {
    await launch(quakeUrl);
  } else {
    throw 'Could not launch $quakeUrl';
  }
}*/

Future<Map> getQuakes() async{
  String apiUrl = 'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson';

  http.Response response = await http.get(apiUrl);

  return json.decode((response.body));
}
