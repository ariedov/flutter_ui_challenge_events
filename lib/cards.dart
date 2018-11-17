import 'package:flutter/material.dart';

class Cards extends StatefulWidget {
  final OnProgress onProgress;

  Cards({Key key, this.onProgress}) : super(key: key);

  @override
  _CardsState createState() => _CardsState();
}

class _CardsState extends State<Cards> with TickerProviderStateMixin {
  List<ViewModel> models = [
    ViewModel(
      "assets/asia.jpg",
      0.0,
      1.0,
      0.0,
    ),
    ViewModel(
      "assets/man.jpg",
      70,
      0.6,
      40.0,
    ),
    ViewModel(
      "assets/trees.jpg",
      140,
      0.3,
      80.0,
    )
  ];

  List<Tween<double>> offsetTweens = [];
  List<Tween<double>> sizeOffsetTweens = [];
  List<Tween<double>> opacityTweens = [];

  AnimationController _swipeController;
  AnimationController _backController;

  int position = 0;
  Direction direction = Direction.NONE;

  @override
  void initState() {
    _swipeController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250))
          ..addListener(() {
            setState(() {
              for (var i = 0; i < models.length - position; ++i) {
                models[position + i].offset =
                    offsetTweens[i].evaluate(_swipeController);
                models[position + i].sizeOffset =
                    sizeOffsetTweens[i].evaluate(_swipeController);
                models[position + i].opacity =
                    opacityTweens[i].evaluate(_swipeController);

                if (i == position) {
                  widget.onProgress(
                      _calculateProgress(models[i].offset), Direction.AWAY);
                }
              }
            });
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              position += 1;
            }
          });

    _backController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250))
          ..addListener(() {
            setState(() {
              for (var i = 0; i < models.length - position; ++i) {
                models[position + i].offset =
                    offsetTweens[i].evaluate(_backController);
                models[position + i].sizeOffset =
                    sizeOffsetTweens[i].evaluate(_backController);
                models[position + i].opacity =
                    opacityTweens[i].evaluate(_backController);

                if (i == position) {
                  widget.onProgress(
                      100 - _calculateProgress(models[i].offset), Direction.BACK);
                }
              }
            });
          });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _onDragStart,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      child: Stack(children: _buildStack()),
    );
  }

  List<Widget> _buildStack() {
    return models
        .map((model) {
          return EventCard(
            image: model.image,
            opacity: model.opacity,
            offset: model.offset,
            sizeOffset: model.sizeOffset,
          );
        })
        .toList()
        .reversed
        .toList();
  }

  _onDragStart(DragStartDetails details) {}

  _onDragUpdate(DragUpdateDetails details) {
    if (direction == Direction.NONE) {
      if (details.delta.dx > 0) {
        direction = Direction.BACK;
        position -= 1;
      } else {
        direction = Direction.AWAY;
      }
    }

    setState(() {
      for (var i = position; i < models.length; ++i) {
        final model = models[i];

        if (i == position) {
          model.opacity = 1.0;
          model.offset += details.delta.dx;
          model.sizeOffset -= details.delta.dx / 12;

          widget.onProgress(_calculateProgress(model.offset), direction);
          continue;
        }

        final distance = details.delta.dx / (i * 6);
        model.offset += distance;
        model.sizeOffset = (model.sizeOffset + distance).clamp(0.0, 400.0);

        final targetOpacity = 0.3 * i;
        final targetOffset = 70 * i;

        model.opacity = 1 - (targetOpacity * model.offset / targetOffset);
      }
    });
  }

  _onDragEnd(DragEndDetails details) {
    offsetTweens.clear();
    sizeOffsetTweens.clear();
    opacityTweens.clear();

    if (direction == Direction.AWAY) {
      for (var i = position; i < models.length; ++i) {
        offsetTweens.add(Tween(
            begin: models[i].offset,
            end: i == position ? -280.0 : 70.0 * (i - position - 1)));
        sizeOffsetTweens.add(Tween(
            begin: models[i].sizeOffset,
            end: i == position ? 0 : 40.0 * (i - position - 1)));
        opacityTweens.add(Tween(
            begin: models[i].opacity,
            end: i == position ? 0 : 1 - (0.3 * (i - position - 1))));
      }
      _swipeController.forward(from: 0.0);
    } else {
      for (var i = position; i < models.length; ++i) {
        offsetTweens
            .add(Tween(begin: models[i].offset, end: 70.0 * (i - position)));
        sizeOffsetTweens.add(
            Tween(begin: models[i].sizeOffset, end: 40.0 * (i - position)));
        opacityTweens.add(Tween(
            begin: models[i].opacity,
            end: i == position ? 1 : 1 - (0.3 * (i - position))));
      }
      _backController.forward(from: 0.0);
    }
    direction = Direction.NONE;
  }

  /// from 40 to -280
  /// means 40 is 0 and -280 is 100
  int _calculateProgress(double offset) {
    final positiveOffset = offset + 280;
    return 100 - (100 * positiveOffset ~/ 320);
  }

  @override
  void reassemble() {
    models = [
      ViewModel(
        "assets/asia.jpg",
        0.0,
        1.0,
        0.0,
      ),
      ViewModel(
        "assets/man.jpg",
        70,
        0.6,
        40.0,
      ),
      ViewModel(
        "assets/trees.jpg",
        140,
        0.3,
        80.0,
      )
    ];

    position = 0;
    direction = Direction.NONE;

    super.reassemble();
  }
}

class ViewModel {
  String image;
  double offset = 0.0;
  double opacity = 1.0;
  double sizeOffset = 0.0;

  ViewModel(this.image, this.offset, this.opacity, this.sizeOffset);
}

class EventCard extends StatelessWidget {
  final String image;
  final bool interested;

  final double opacity;
  final double offset;
  final double sizeOffset;

  final Size size = const Size(280, 400);

  const EventCard({
    Key key,
    this.image,
    this.interested,
    this.offset = 0.0,
    this.opacity = 1.0,
    this.sizeOffset = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(40 + offset, sizeOffset / 2),
      child: SizedBox(
        width: size.width - sizeOffset,
        height: size.height - sizeOffset,
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

enum Direction { AWAY, BACK, NONE }

typedef OnProgress = Function(int progress, Direction direction);
