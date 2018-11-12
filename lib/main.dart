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
  
  double offset = 0.0;
  double opacity = 1.0;


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
                  EventCard(
                      image: "assets/asia.jpg",
                      opacity: opacity / 3,
                      offset: (offset / 10) + 80),
                  EventCard(
                      image: "assets/man.jpg",
                      opacity: opacity / 2,
                      offset: (offset / 8) + 40),
                  EventCard(
                      image: "assets/trees.jpg",
                      opacity: opacity,
                      offset: offset),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onDragStart(DragStartDetails details) {
  }

  _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      offset += details.delta.dx;
      // opacity = (1 - (offset.abs())).clamp(0.0, 1.0);
    });
  }

  _onDragEnd(DragEndDetails details) {
    setState(() {
      offset = 0.0;
      opacity = 1.0;
    });
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

  final double opacity;
  final double offset;

  final Size size = const Size(280, 400);

  const EventCard({
    Key key,
    this.image,
    this.interested,
    this.offset = 0.0,
    this.opacity = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(40 + offset, 0.0),
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: Opacity(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Image.asset(
              image,
              fit: BoxFit.cover,
            ),
          ),
          opacity: opacity,
        ),
      ),
    );
  }
}
