import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'insights.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static String queryTerm = 'IBM';

  String url = 'https://gateway.watsonplatform.net/discovery/api/v1/environments/system/collections/news-en/query?version=2018-08-01&aggregation=filter%28enriched_title.entities.type%3A%3ACompany%29.term%28enriched_title.entities.text%29.timeslice%28crawl_date%2C1day%29.term%28enriched_text.sentiment.document.label%29&filter=IBM&highlight=true&passages.count=5&query=$queryTerm';
  
  String basicAuth = 'Basic ' + base64Encode(utf8.encode('apikey:YOUR_API_KEY'));

  List data;
  Future<String> makeRequest() async {

    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json", "Authorization": basicAuth});

    setState(() {
      var extractdata = json.decode(response.body);
      data = extractdata["results"];
    });
  }

  @override
  void initState() {
    this.makeRequest();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Watson Discovery News'),
        ),
        body: new ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, i) {
            return Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: new Image.network(
                      // some Discovery results do not return main_image_url
                      data[i]["main_image_url"] == null ? "https://ui-avatars.com/api/" : data[i]["main_image_url"],
                      height: 75.0, 
                      width: 75.0, 
                      fit: BoxFit.fitWidth,
                    ),
                    title: Text(data[i]["title"]),
                    subtitle: Text(data[i]["text"]),
                    dense: true,
                    contentPadding: EdgeInsets.all(5.0),
                  ),
                  ButtonTheme.bar(
                    child: ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: Text(data[i]["host"]),
                          onPressed: () {
                            launch(data[i]["url"]);
                          },
                        ),
                        FlatButton(
                          child: const Text('More Analysis'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              new MaterialPageRoute(
                                builder: (BuildContext context) => new InsightsPage(data[i])
                              )
                            );
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        )
    );
  }
}
