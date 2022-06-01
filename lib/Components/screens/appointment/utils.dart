import 'package:flutter/material.dart';

final timeVals = [
  "12:00",
  "12:30",
  "1:00",
  "1:30",
  "2:00",
  "2:30",
  "3:00",
  "3:30",
  "4:00",
  "4:30",
  "5:00",
  "5:30",
  "6:00",
  "6:30",
  "7:30",
  "8:00",
  "8:30",
  "9:00",
  "9:30",
  "10:00",
  "10:30",
  "11:00",
  "11:30"
];

Widget dropDown(String value, Function selectTime, List<String> values) =>
    Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1))),
      child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        elevation: 16,
        underline: Container(
          height: 2,
          color: Colors.black,
        ),
        onChanged: (String value) {
          selectTime(value);
        },
        items: values.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
              value: value,
              child: LayoutBuilder(
                builder: (context, constraints) => Container(
                  child: Text(value),
                ),
              ));
        }).toList(),
      )),
    );

Widget workoutType(
        List<String> workouts, String value, Function changeHandler) =>
    dropDown(value, changeHandler, ["Miscellanous", ...workouts]);

Widget startTime(String value, Function changeHandler) =>
    dropDown(value, changeHandler, timeVals);

Widget meridian(String value, Function changeHandler) =>
    dropDown(value, changeHandler, ["AM", "PM"]);

Widget hours(String value, Function changeHandler) =>
    dropDown(value, changeHandler, ["00", "01", "02"]);

Widget minutes(String value, Function changeHandler) =>
    dropDown(value, changeHandler, ["00", "15", "30", "45"]);
