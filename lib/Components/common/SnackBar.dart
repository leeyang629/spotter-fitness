import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotter/providers/app_state.dart';

class SnackBarCustom extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<SnackBarCustom> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation animation;
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _controller.addListener(() {
      if (_controller.status == AnimationStatus.completed) {
        Future.delayed(Duration(seconds: 3), () {
          _controller.reverse().then((value) {
            Provider.of<AppState>(context, listen: false).hideSnackBar();
          });
        });
      }
    });
    animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic));
    _controller?.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Opacity(
            opacity: animation.value,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Material(
                child: Text(
                  Provider.of<AppState>(context, listen: false).snackBarText,
                  style: TextStyle(
                      backgroundColor: Colors.grey[200],
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ),
          );
        });
  }
}
