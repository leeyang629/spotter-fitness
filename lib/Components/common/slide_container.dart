import 'package:flutter/material.dart';

class SliderContainer extends StatefulWidget {
  final bool open;
  final Widget child;
  final Function close;
  SliderContainer({this.open, this.close, this.child});
  @override
  _State createState() => _State();
}

class _State extends State<SliderContainer> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      transform: Matrix4.translationValues(
          0, widget.open ? 0 : MediaQuery.of(context).size.height, 0),
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
      child: widget.open
          ? Stack(
              children: [
                Positioned(
                    top: 0,
                    child: GestureDetector(
                        onTap: () {
                          widget.close();
                        },
                        child: Icon(Icons.arrow_back))),
                widget.child
              ],
            )
          : Container(),
    );
  }
}
