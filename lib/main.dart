import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MyBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Column(
        children: <Widget>[
          new Text('Hello world'),
          new FlatButton(
            onPressed: () async{
              const url = 'https:yandex.ru';
              if (await canLaunch(url)) {
                await (launch(url));
              } else {
                throw('ERROR');
              }
            },
            child: Text('Open'),
            color: Colors.red,
            textColor: Colors.white,
          )
        ],
      ),
    );
  }
}

void main() {
  runApp(
    new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Flutter bar'),
        ),
        body: new MyBody(),
      )
    )
  );
}