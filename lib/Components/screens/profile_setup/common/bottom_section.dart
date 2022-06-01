import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget bottomSection(int index, int totalPageCount, Function skipHandler,
    Function nextHandler, Function finishiHandler, bool enableFinishBtn,
    {bool disableSkipNext = false}) {
  return Container(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: index < totalPageCount - 1
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.center,
        children: _progressStrip(index, totalPageCount, skipHandler,
            nextHandler, finishiHandler, enableFinishBtn, disableSkipNext),
      ));
}

List<Widget> _progressStrip(
    int index,
    int totalPageCount,
    Function skipHandler,
    Function nextHandler,
    Function finishiHandler,
    bool enableFinishBtn,
    bool disableSkipNext) {
  if (index < totalPageCount - 1) {
    return [
      _skip(skipHandler, disableSkipNext),
      // _progress(index, totalPageCount),
      _next(nextHandler, disableSkipNext)
    ];
  } else if (index == totalPageCount - 1) {
    return [Container()];
  }
  return [];
}

Widget _progress(int index, int totalPageCount) => Row(
    children: List<int>.filled(totalPageCount, 0)
        .asMap()
        .entries
        .map((entry) => Container(
                child: Icon(
              Icons.fiber_manual_record,
              size: 14,
              color: index == entry.key
                  ? Color.fromRGBO(216, 150, 21, 1)
                  : Color.fromRGBO(218, 219, 221, 1),
            )))
        .toList());

Widget _skip(Function skipHandler, bool disableSkipNext) => TextButton(
    onPressed: disableSkipNext ? null : skipHandler,
    child: Text('SKIP',
        style: TextStyle(
            fontSize: 16,
            color: disableSkipNext ? Colors.white : Colors.white,
            fontWeight: FontWeight.bold)
    ),
    style: ButtonStyle(
      padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.fromLTRB(28,10,28,10)),
    )
);

Widget _next(Function nextHandler, bool disableSkipNext) => TextButton(
    onPressed: disableSkipNext ? null : nextHandler,
    child: Text('NEXT',
        style: TextStyle(
            fontSize: 16,
            color: disableSkipNext ? Colors.white : Colors.white,
            fontWeight: FontWeight.bold,
        )
    ),
    style: ButtonStyle(
      backgroundColor:
      MaterialStateProperty.all<Color>(Color.fromRGBO(210, 184, 149, 1)),
      padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.fromLTRB(28,10,28,10)),
    )
);

Widget finish(bool enableFinishBtn, Function finishiHandler) => ElevatedButton(
    style: ButtonStyle(
        minimumSize: MaterialStateProperty.all<Size>(Size.fromRadius(70)),
        // padding: MaterialStateProperty.all<EdgeInsets>(
        //     EdgeInsets.fromLTRB(40, 10, 40, 10)),
        backgroundColor: enableFinishBtn
            ? MaterialStateProperty.all<Color>(Color.fromRGBO(225, 159, 12, 1))
            : MaterialStateProperty.all<Color>(Colors.grey),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(70.0),
        ))),
    onPressed: () {
      if (enableFinishBtn) {
        finishiHandler();
      }
    },
    child: SvgPicture.asset(
      'assets/images/spot.svg',
      width: 100,
    ));
