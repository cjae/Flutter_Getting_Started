import 'package:flutter/material.dart';
import './views/details_page.dart';
import './views/video_cell.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(new RealWorldApp());

class RealWorldApp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {

    return new RealWorldState();
  }
}

class RealWorldState extends State<RealWorldApp> {

  var _isLoading = true;
  var videos;

  _fetchData() async {
    print("Attempting to get data from network");

    final url = "https://api.letsbuildthatapp.com/youtube/home_feed";
    final response = await http.pget(url);

    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      final videosJson = map['videos'];

      setState(() {
        _isLoading = false;
        this.videos = videosJson;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("Real World Appbar"),
          actions: <Widget>[
            new IconButton(icon: new Icon(Icons.refresh),
                onPressed: () {
                  print("Reloading...");
                  setState(() {
                    _isLoading = true;
                  });

                  _fetchData();
                })
          ],
        ),
        body: new Center(
          child: _isLoading ? new CircularProgressIndicator() :
          new ListView.builder(
              itemCount: this.videos != null ? this.videos.length : 0,
              itemBuilder: (context, i) {
                final video = this.videos[i];
                return new FlatButton(
                  padding: new EdgeInsets.all(0.0),
                    onPressed: () {
                      print("Cell tapped: $i");
                      Navigator.push(context, new MaterialPageRoute(
                          builder: (context) => new DetailsPage()
                      ));
                    },
                    child: new VideoCell(video)
                );
              }
          ),
        ),
      ),
    );
  }
}