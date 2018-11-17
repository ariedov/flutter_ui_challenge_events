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

class HomePage extends StatefulWidget {
  final String title;

  HomePage({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  ScrollController scrollController;

  Direction direction;
  int position = 0;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0.0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TitleSwitcher(
              scrollController: scrollController,
            ),
            Cards(
              onProgress: (progress, direction) {
                final titleHeight = (60 + 48);

                var newOffset = progress * titleHeight / 100;
                if (direction == Direction.AWAY) {
                  newOffset += (position * titleHeight);
                }

                if (direction == Direction.BACK) {
                  newOffset = ((position) * titleHeight) - newOffset;
                }

                if (progress == 100 && direction == Direction.NONE) {
                  if (this.direction == Direction.AWAY) {
                    position += 1;
                  } else {
                    position -= 1;
                  }
                } else {
                  print(
                      "progress: $progress; direction: $direction; newOffset: $newOffset");
                  scrollController.jumpTo(newOffset);
                }

                this.direction = direction;
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
    Title("Kabali show", "Kyiv", "Nov 25, 2018"),
    Title("Yoke Party", "Kyiv", "Nov 24, 2018"),
  ];

  final ScrollController scrollController;

  TitleSwitcher({Key key, this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.0,
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        controller: scrollController,
        children: <Widget>[
          EventTitle(titles[0]),
          EventTitle(titles[1]),
          EventTitle(titles[2]),
        ],
      ),
    );
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
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
      child: SizedBox(
        height: 60.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title.title,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                  ),
                  Text(
                    title.location,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 4.0),
              child: Text(
                title.date,
                style: TextStyle(fontSize: 16.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
