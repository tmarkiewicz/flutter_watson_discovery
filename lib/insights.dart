import 'package:flutter/material.dart';

class InsightsPage extends StatelessWidget {
  // display the Discovery enriched results (keywords) for the selected article 
  InsightsPage(this.data);
  final data;
  @override
  Widget build(BuildContext context) => new Scaffold(
      appBar: new AppBar(title: new Text('Keywords')),
      body: new ListView.builder(
        itemCount: data["enriched_title"]["keywords"].length,
        itemBuilder: (BuildContext context, i) {
          return new ListTile(
            title: new Text(data["enriched_title"]["keywords"][i]["text"]),
            subtitle: new Text("Relevance: " + data["enriched_title"]["keywords"][i]["relevance"].toString()),
            dense: true
          );
        },
      )
    );
}