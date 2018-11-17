import 'package:flutter/material.dart';
import 'package:flutter_events/cards.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: HomePage(title: 'Events'),
    );
  }
}

class HomePage extends StatelessWidget {
  final String title;
  const HomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        elevation: 0.0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TitleSwitcher(),
            Cards(
              onProgress: (progress, direction) {
                print("progress: $progress; direction: $direction");
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TitleSwitcher extends StatelessWidget {
  final List<Title> titles = [
    Title("Fashion Talk", "Kyiv", "Nov 24, 2018"),
    Title("Fashion Talk", "Kyiv", "Nov 24, 2018"),
    Title("Fashion Talk", "Kyiv", "Nov 24, 2018"),
  ];

  @override
  Widget build(BuildContext context) {
    return EventTitle(titles[0]);
  }
}

class Title {
  final String title;
  final String location;
  final String date;

  Title(this.title, this.location, this.date);
}

class EventTitle extends StatelessWidget {
  final Title title;

  const EventTitle(this.title, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: SizedBox(
        height: 40.0,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title.title),
                  Text(title.location),
                ],
              ),
            ),
            Text(title.date)
          ],
        ),
      ),
    );
  }
}
