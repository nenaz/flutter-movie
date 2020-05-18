import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class MainPage extends StatefulWidget {
  final String url;

  MainPage({String url}):url = url;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String _url;
  String _body;
  int _status;

  @override
  void initState() {
    _url = widget.url;
    _status = 0;
    _body = _body;
    super.initState();
  }

  _sendRequestPost() async {
    try {
      var response = await http.get('https://www.googleapis.com/books/v1/volumes?q={http}');
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        var itemCount = jsonResponse['totalItems'];
        print('Number of books about http: $itemCount.');
        _status = response.statusCode;
        _body = response.body;
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      _status = 0;
      _body = e.toString();
    }
    setState(() {
      _status = _status;
      _body = _body;
    });
  }

  _sendRequestPostBodyHeaders() async {
    try {
      var response = await http.post(
        _url,
        body: {'name':'test','num':'10'},
        headers: {'Accept':'application/json'},
      );
      _status = response.statusCode;
      _body = response.body;
    } catch (e) {
      _status = 0;
      _body = e.toString();
    }
    setState(() {
      
    });
  }

  _goToCard() {
    Navigator.pushNamed(context, '/card-page');
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Page'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text('Send request POST'),
              onPressed: _sendRequestPost,
            ),
            RaisedButton(
              child: Text('Send request POST with Body and Headers'),
              onPressed: _sendRequestPostBodyHeaders,
            ),
            Text('$_status'),
            Text('$_body'),
            RaisedButton(
              child: Text('Посмортеть карточку'),
              onPressed: _goToCard,
            ),
          ],
        ),
      ),
    );
  }
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Test HTTP API'),
//         ),
//         body: MainPage(url: 'https://json.flutter.su/echo')
//     );
//   }
// }
