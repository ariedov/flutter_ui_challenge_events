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

                final titleHeight = (40 + 64);

                final offset = scrollController.offset;
                var newOffset = progress * titleHeight / 100;
                if (direction == Direction.BACK) {
                  newOffset *= -1;
                }

                print("progress: $progress; direction: $direction; offse: $offset, newOffset: $newOffset");
                scrollController.jumpTo((position * titleHeight) + newOffset);
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
