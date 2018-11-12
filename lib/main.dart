import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: MyHomePage(title: 'Events'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double dragStart = 0.0;
  double progress = 0.0;

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
            EventTitle(),
            GestureDetector(
              onHorizontalDragStart: _onDragStart,
              onHorizontalDragUpdate: _onDragUpdate,
              onHorizontalDragEnd: _onDragEnd,
              child: Stack(
                children: <Widget>[
                  EventCard(image: "assets/asia.jpg", progress: progress),
                  EventCard(image: "assets/man.jpg", progress: progress + .6),
                  EventCard(
                    image: "assets/trees.jpg",
                    progress: 1.0 - progress,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onDragStart(DragStartDetails details) {
    dragStart = details.globalPosition.dx;
  }

  _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      progress = ((100 * dragStart - details.globalPosition.dx) / 1.0).clamp(0.0, 1.0);
    });
  }

  _onDragEnd(DragEndDetails details) {
    progress = 1.0;
  }
}

class EventTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[Text("Fashion Talk"), Text("Kyiv")],
            ),
          ),
          Text("Nov 24, 2017")
        ],
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String image;
  final bool interested;
  final double progress;

  final Size size = const Size(280, 400);

  const EventCard({Key key, this.image, this.interested, this.progress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final offset = 40 + progress * 80;

    return Transform.translate(
      offset: Offset(offset, progress * 15),
      child: SizedBox(
        width: size.width - (progress * 40),
        height: size.height - (progress * 40),
        child: Opacity(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Image.asset(
              image,
              fit: BoxFit.cover,
            ),
          ),
          opacity: 1.0 - (progress / 2),
        ),
      ),
    );
  }
}
