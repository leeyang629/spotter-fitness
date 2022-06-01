import 'package:flutter/material.dart';
import 'package:spotter/Components/common/IconWithText.dart';
import 'package:spotter/utils/dateTimeUtils.dart';
import 'package:spotter/Components/screens/schedule/model.dart';

Widget scheduleCard(ScheduleCardDetails schedule,
    {bool actions = false,
    bool actions2 = false,
    Function onTap,
    Function update,
    Function checkIn,
    Function approve,
    Function startSession,
    Function endSession,
    Function cancel,
    Function chatWith}) {
  return Container(
    padding: const EdgeInsets.all(8.0),
    height: actions || actions2 ? 220 : 160,
    margin: EdgeInsets.all(8),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey, blurRadius: 8, offset: Offset(0, 0))
        ]),
    child: ListTile(
      onTap: onTap,
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text("Workout with"),
        Row(
          children: [
            InkWell(
              onTap: () {
                if (chatWith != null) chatWith();
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 12, 4),
                child: Icon(Icons.chat_bubble_outline),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(15, 32, 84, 1),
                  borderRadius: BorderRadius.circular(12)),
              child:
                  Text(schedule.status, style: TextStyle(color: Colors.white)),
            ),
          ],
        )
      ]),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            schedule.trainWith,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                    fit: FlexFit.tight,
                    child: iconWithFlexibleText(
                        Icons.people, schedule.workout ?? '-')),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: iconWithText(Icons.calendar_today,
                      formatDateDDMMMYYYY(DateTime.parse(schedule.date))),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                    fit: FlexFit.tight,
                    child: iconWithText(Icons.watch, schedule.startTime)),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: iconWithText(Icons.place, "-"),
                )
              ],
            ),
          ),
          if (actions) ...actionSection(schedule, update, checkIn, cancel),
          if (actions2)
            ...actionSection2(schedule, approve, startSession, endSession),
        ],
      ),
      isThreeLine: true,
    ),
  );
}

List<Widget> actionSection(ScheduleCardDetails schedule, Function update,
    Function checkIn, Function cancel) {
  return [
    Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 8),
      child: Container(
        height: 1,
        color: Colors.grey,
      ),
    ),
    Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            cardButton("Cancel", schedule.status != "Cancelled" ? cancel : null,
                color: Color.fromRGBO(232, 44, 53, 1)),
            cardButton(
                "Check-in", schedule.status == "Approved" ? checkIn : null),
            // cardButton("End Session"),
            cardButton("Update", schedule.status != "Cancelled" ? update : null)
          ],
        ))
  ];
}

List<Widget> actionSection2(ScheduleCardDetails schedule, Function approve,
    Function start, Function end) {
  return [
    Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 8),
      child: Container(
        height: 1,
        color: Colors.grey,
      ),
    ),
    Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            cardButton(
              schedule.status != "Approved" ? "Approve" : "Cancel",
              schedule.status != "Cancelled" && schedule.status != "Progress"
                  ? approve
                  : null,
              color: schedule.status != "Approved"
                  ? Color.fromRGBO(15, 32, 84, 1)
                  : Color.fromRGBO(232, 44, 53, 1),
            ),
            if (schedule.status != "Progress")
              cardButton("Start Session ",
                  schedule.status == "Approved" ? start : null),
            if (schedule.status == 'Progress') cardButton("End Session ", end),
          ],
        ))
  ];
}

Widget cardButton(String text, Function tapHandler,
    {Color color = const Color.fromRGBO(15, 32, 84, 1)}) {
  return InkWell(
    onTap: tapHandler,
    child: Container(
      padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: tapHandler != null ? color : Colors.grey, width: 1)),
      child: Text(
        text,
        style: TextStyle(color: tapHandler != null ? color : Colors.grey),
      ),
    ),
  );
}
