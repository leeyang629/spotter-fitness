import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';

class QuestionWithDropDown extends StatefulWidget {
  final int keyvalue;
  final String text;
  final List<String> options;
  final Function changeHandler;
  final bool mandatory;
  final String savedVal;
  QuestionWithDropDown(
      this.keyvalue, this.text, this.options, this.changeHandler,
      {this.mandatory = false, this.savedVal})
      : super(key: ObjectKey(keyvalue));

  @override
  DropDownState createState() => DropDownState();
}

class DropDownState extends State<QuestionWithDropDown> {
  String dropDownValue = "";
  @override
  void initState() {
    super.initState();
    dropDownValue = widget.savedVal ?? widget.options[0];
  }

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(widget.text,
              style: TextStyle(
                color: Color.fromRGBO(210, 184, 149, 1)
                )
          ),
          Padding(padding: EdgeInsets.only(top: 10)),
          DropdownButtonFormField<String>(
            key: ObjectKey(widget.keyvalue),
            value: dropDownValue,
            elevation: 16,
            decoration: InputDecoration(
              fillColor: Color.fromRGBO(210, 184, 149, 0.2),
              filled: true,
              border: new OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10.0),
                ),
              ),
            ),
            onChanged: (String value) {
              setState(() {
                dropDownValue = value;
              });
              widget.changeHandler(value);
            },
            items: widget.options.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                  value: value,
                  child: LayoutBuilder(
                    builder: (context, constraints) => Container(
                      width: MediaQuery.of(context).size.width/2,
                      child: Text(value),
                    ),
                  ));
            }).toList(),
          )
        ],
      ),
    );
  }
}

class QuestionWithRadioBtn extends StatefulWidget {
  final int keyValue;
  final String text;
  final List<String> values;
  final String axis;
  final Function(String) changeHandler;
  final String savedVal;
  QuestionWithRadioBtn(
      this.keyValue, this.text, this.values, this.axis, this.changeHandler,
      {this.savedVal})
      : super(key: ObjectKey(keyValue));
  @override
  RadioButtonState createState() => new RadioButtonState();
}

class RadioButtonState extends State<QuestionWithRadioBtn> {
  String selectedValue;
  @override
  void initState() {
    super.initState();
    selectedValue = widget.savedVal ?? '';
    // print("init state");
  }

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(widget.text,
            style: TextStyle(
                color: Color.fromRGBO(210, 184, 149, 1))),
        widget.axis == "horizontal"
            ? Row(
                children: widget.values
                    .map((value) => Expanded(
                          child: listTile(value),
                        ))
                    .toList())
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.values
                    .map(
                        (value) => SizedBox(height: 36, child: listTile(value)))
                    .toList(),
              )
      ]),
    );
  }

  Widget listTile(value) {
    return RadioListTile<String>(
      contentPadding: EdgeInsets.all(0),
      title: Text(value, style: TextStyle(fontSize: 14,
          color: Color.fromRGBO(210, 184, 149, 1))),
      toggleable: true,
      activeColor: Color.fromRGBO(247, 165, 4, 1),
      value: value,
      groupValue: selectedValue,
      onChanged: (String value) {
        setState(() {
          selectedValue = value;
        });
        widget.changeHandler(value);
      },
    );
  }
}

class QuestionWithRadioBtnAndText extends StatefulWidget {
  final int keyValue;
  final String text;
  final List<String> values;
  final String axis;
  final Function(String) changeHandler;
  final Map<String, dynamic> savedVal;
  QuestionWithRadioBtnAndText(
      this.keyValue, this.text, this.values, this.axis, this.changeHandler,
      {this.savedVal})
      : super(key: ObjectKey(keyValue));
  @override
  RadioButtonAndTextState createState() => new RadioButtonAndTextState();
}

class RadioButtonAndTextState extends State<QuestionWithRadioBtnAndText> {
  Map<String, dynamic> selectedValue = {};
  @override
  void initState() {
    super.initState();
    // if (widget.savedVal != null)
    selectedValue = widget.savedVal ?? {};
  }

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(widget.text,
            style: TextStyle(
              color: Color.fromRGBO(210, 184, 149, 1),)),
        widget.axis == "horizontal"
            ? Row(
                children: widget.values
                    .map((value) => Expanded(
                          child: listTile(value),
                        ))
                    .toList())
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    widget.values.map((value) => listTile(value)).toList(),
              )
      ]),
    );
  }

  Widget listTile(String value) {
    return Column(
      children: [
        SizedBox(
          height: 36,
          child: RadioListTile<String>(
            contentPadding: EdgeInsets.all(0),
            title: Text(value, style: TextStyle(fontSize: 14,
              color: Color.fromRGBO(210, 184, 149, 1),)),
            toggleable: true,
            activeColor: Color.fromRGBO(210, 184, 149, 1),
            value: value,
            groupValue:
                selectedValue.keys.toList().indexOf(value) > -1 ? value : "",
            onChanged: (String change) {
              /// For already selected radio button changedValue comes as null
              if (change == null) {
                setState(() {
                  selectedValue.remove(value);
                  widget.changeHandler('$value - ');
                });
                selectedValue
                    .remove(value); // Dont know why this works only placed here
                print(value);
              } else {
                setState(() {
                  selectedValue[value] = "";
                });
              }
            },
          ),
        ),
        if (selectedValue.keys.toList().indexOf(value) > -1)
          SizedBox(
            height: 36,
            child: TextFormField(
              initialValue: selectedValue[value],
              onChanged: (text) {
                widget.changeHandler('$value - $text');
              },
              decoration: InputDecoration(contentPadding: EdgeInsets.all(0)),
            ),
          )
      ],
    );
  }
}

class QuestionWithText extends StatefulWidget {
  final int keyValue;
  final String text;
  int maxLines;
  final Function(String) changeHandler;
  final String savedVal;
  QuestionWithText(this.keyValue, this.text, this.changeHandler,
      {this.maxLines = 1, this.savedVal})
      : super(key: ObjectKey(keyValue));
  @override
  TextQuestionState createState() => new TextQuestionState();
}

class TextQuestionState extends State<QuestionWithText> {
  TextEditingController textValue = TextEditingController(text: "");
  @override
  void initState() {
    super.initState();
    textValue.text = widget.savedVal ?? '';
    // print("init state");
  }

  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 20),
        child:
          Column(crossAxisAlignment: CrossAxisAlignment.stretch, 
              children: [
                Text(widget.text,
                    style: TextStyle(color: Color.fromRGBO(210, 184, 149, 1))),
                Padding(padding: EdgeInsets.only(top: 10)),
                TextField(
                  maxLines: widget.maxLines,
                  controller: textValue,
                  onChanged: (String value) {
                    widget.changeHandler(value);
                  },
                  decoration: InputDecoration(
                      fillColor: Color.fromRGBO(210, 184, 149, 0.2),
                      filled: true,
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(10.0),
                        ),
                      ),
                  )
                )
              ]
          )
    );
  }
}

class QuestionWithStripSelect extends StatefulWidget {
  final int keyValue;
  final String text;
  final List<String> values;
  final Function changeHandler;
  final List<String> savedVal;
  QuestionWithStripSelect(
      this.keyValue, this.text, this.values, this.changeHandler,
      {this.savedVal})
      : super(key: ObjectKey(keyValue));
  @override
  StripSelectState createState() => new StripSelectState();
}

class StripSelectState extends State<QuestionWithStripSelect> {
  // Map<int, String> selectedStrips = {};
  List<String> selectedStrips = [];
  @override
  void initState() {
    super.initState();
    // if (widget.savedVal != null) selectedStrips = {...widget.savedVal.asMap()};
    if (widget.savedVal != null) selectedStrips = [...widget.savedVal];
    // print("init state");
  }

  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 20),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(widget.text,
              style: TextStyle(
                color: Color.fromRGBO(210, 184, 149, 1),)),
          Padding(padding: EdgeInsets.only(top: 10.0)),
          Wrap(
              spacing: 5,
              runSpacing: 0,
              // direction: Axis.horizontal,
              children: widget.values.asMap().entries.map((entry) {
                return TextButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          selectedStrips.indexOf(entry.value) > -1
                              ? Color.fromRGBO(247, 165, 4, 1)
                              : Color.fromRGBO(234, 234, 235, 1)),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(10))),
                  child: Text(entry.value,
                      style: TextStyle(
                          fontSize: 12, color: Color.fromRGBO(54, 53, 52, 1))),
                  onPressed: () {
                    if (selectedStrips.indexOf(entry.value) > -1) {
                      setState(() {
                        selectedStrips.remove(entry.value);
                      });
                    } else {
                      setState(() {
                        selectedStrips.add(entry.value);
                      });
                    }
                    widget.changeHandler(selectedStrips);
                  },
                );
              }).toList())
        ]));
  }
}

class IconStripSelect extends StatefulWidget {
  final int keyValue;
  final String text;
  final List<Map<String, String>> values;
  final Function changeHandler;
  final List<String> savedVal;
  IconStripSelect(this.keyValue, this.text, this.values, this.changeHandler,
      {this.savedVal})
      : super(key: ObjectKey(keyValue));
  @override
  IconStripSelectState createState() => new IconStripSelectState();
}

class IconStripSelectState extends State<IconStripSelect> {
  Map<int, String> selectedStrips = {};
  @override
  void initState() {
    super.initState();
    if (widget.savedVal != null) selectedStrips = {...widget.savedVal.asMap()};
    // print("init state");
  }

  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(
          bottom: 20,
        ),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(widget.text,
              style: TextStyle(color: Color.fromRGBO(176, 182, 186, 1))),
          Wrap(
              spacing: 5,
              runSpacing: 5,
              // direction: Axis.horizontal,
              children: widget.values.asMap().entries.map((entry) {
                return TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        selectedStrips[entry.key] != null
                            ? Color.fromRGBO(247, 165, 4, 1)
                            : Color.fromRGBO(234, 234, 235, 1)),
                  ),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        'assets/images/${entry.value["icon"]}.svg',
                        width: 40,
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(entry.value["text"],
                            style: TextStyle(
                                fontSize: 12,
                                color: Color.fromRGBO(54, 53, 52, 1))),
                      ),
                    ],
                  ),
                  onPressed: () {
                    if (selectedStrips[entry.key] != null) {
                      setState(() {
                        selectedStrips.remove(entry.key);
                      });
                    } else {
                      setState(() {
                        selectedStrips[entry.key] = entry.value["text"];
                      });
                    }
                    widget.changeHandler(selectedStrips.values.toList());
                  },
                );
              }).toList())
        ]));
  }
}
