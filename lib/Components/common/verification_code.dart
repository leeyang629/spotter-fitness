import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VerficationCode extends StatefulWidget {
  final Function verify;
  VerficationCode(this.verify);
  @override
  ComponentState createState() => ComponentState();
}

class ComponentState extends State<VerficationCode> {
  TextEditingController value0;
  TextEditingController value1;
  TextEditingController value2;
  TextEditingController value3;
  TextEditingController value4;
  TextEditingController value5;
  FocusNode node0 = FocusNode();
  bool sendVerfication = false;

  @override
  void initState() {
    super.initState();
    initializeWithEmpty();
  }

  initializeWithEmpty() {
    value0 = TextEditingController(text: " ");
    value1 = TextEditingController(text: " ");
    value2 = TextEditingController(text: " ");
    value3 = TextEditingController(text: " ");
    value4 = TextEditingController(text: " ");
    value5 = TextEditingController(text: " ");
  }

  @override
  Widget build(BuildContext context) {
    return (Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _getTextField(value0, first: true),
        _getTextField(value1),
        _getTextField(value2),
        _getTextField(value3),
        _getTextField(value4),
        _getTextField(value5, last: true)
      ],
    ));
  }

  _getTextField(TextEditingController controller,
      {bool first = false, bool last = false}) {
    return Container(
      margin: EdgeInsets.only(left: 8),
      width: 28,
      child: TextField(
        style: TextStyle(color: Colors.white, fontSize: 20),
        focusNode: first ? node0 : null,
        textAlign: TextAlign.center,
        enableInteractiveSelection: false,
        autofocus: first,
        showCursor: false,
        controller: controller,
        onChanged: (value) {
          if (value.length == 2) {
            if (last) {
              if (!sendVerfication) {
                widget.verify(code());
              }
            } else {
              FocusScope.of(context).nextFocus();
            }
          } else if (value.length == 1) {
            if (first) {
              value0.text = " ";
            } else {
              FocusScope.of(context).previousFocus();
            }
          } else if (value.length == 0) {
            controller.text = " ";
            if (!first) {
              FocusScope.of(context).previousFocus();
            }
          }
        },
        decoration: InputDecoration(
          counterText: "",
        ),
        maxLength: 2,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^ ?\d*'))],
      ),
    );
  }

  String code() =>
      value0.text.trim() +
      value1.text.trim() +
      value2.text.trim() +
      value3.text.trim() +
      value4.text.trim() +
      value5.text.trim();

  resetEverything() {
    setState(() {
      sendVerfication = false;
      initializeWithEmpty();
    });
    FocusScope.of(context).requestFocus(node0);
  }
}
