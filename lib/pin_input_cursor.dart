import 'dart:async';

import 'package:flutter/material.dart';

/// Class that simulates TextFormField cursor
class PinInputCursor extends StatefulWidget {
  @override
  _PinInputCursorState createState() => _PinInputCursorState();
}

class _PinInputCursorState extends State<PinInputCursor> {
  static const double _CURSOR_HEIGHT = 20;
  static const double _CURSOR_WIDTH = 4;

  Timer _timer;
  bool _invisible = false;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(Duration(milliseconds: 250), (timer) {
      setState(() {
        _invisible = !_invisible;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 110),
      height: _CURSOR_HEIGHT,
      width: _CURSOR_WIDTH,
      decoration: BoxDecoration(
        color: _invisible ? Colors.transparent : Colors.black38,
      ),
    );
  }
}
