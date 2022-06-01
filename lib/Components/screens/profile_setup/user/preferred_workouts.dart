import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotter/Components/screens/profile_setup/common/question_components.dart';

const WorkOuts = [
  {
    "workout": "Cardio",
    "image_type": "svg",
    "asset": "assets/images/running.svg",
    "color": Color.fromRGBO(249, 196, 17, 1),
    "colStart": 0,
    "colSpan": 1,
    "rowStart": 0,
    "rowSpan": 1
  },
  {
    "workout": "Yoga",
    "image_type": "svg",
    "asset": "assets/images/yoga.svg",
    "color": Color.fromRGBO(217, 151, 20, 1),
    "colStart": 0,
    "colSpan": 1,
    "rowStart": 1,
    "rowSpan": 1
  },
  {
    "workout": "Lifting",
    "image_type": "svg",
    "asset": "assets/images/lifting.svg",
    "color": Colors.red,
    "colStart": 0,
    "colSpan": 2,
    "rowStart": 2,
    "rowSpan": 2
  },
  {
    "workout": "Fitness",
    "image_type": "svg",
    "asset": "assets/images/fitness.svg",
    "color": Color.fromRGBO(15, 32, 84, 1),
    "colStart": 1,
    "colSpan": 2,
    "rowStart": 0,
    "rowSpan": 2
  },
  {
    "workout": "Crossfit",
    "image_type": "png",
    "asset": "assets/images/crossfit.png",
    "color": Color.fromRGBO(131, 135, 138, 1),
    "colStart": 2,
    "colSpan": 1,
    "rowStart": 2,
    "rowSpan": 1
  },
  {
    "workout": "Sports",
    "image_type": "png",
    "asset": "assets/images/sports.png",
    "color": Color.fromRGBO(175, 136, 9, 1),
    "colStart": 2,
    "colSpan": 1,
    "rowStart": 3,
    "rowSpan": 1
  }
];

class PreferredWorkouts extends StatefulWidget {
  final Function updateFavWorkouts;
  final List<String> savedWorkouts;
  PreferredWorkouts(this.updateFavWorkouts, {this.savedWorkouts});
  @override
  ComponentState createState() => ComponentState();
}

class ComponentState extends State<PreferredWorkouts> {
  List<String> selectedWorkouts = [];
  @override
  void initState() {
    super.initState();
    if (widget.savedWorkouts != null && widget.savedWorkouts != []) {
      selectedWorkouts = widget.savedWorkouts;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          // height: MediaQuery.of(context).size.height * 0.5,
          // child: LayoutGrid(
          //   columnGap: 8,
          //   rowGap: 8,
          //   columnSizes: [1.fr, 1.fr, 1.fr],
          //   rowSizes: [1.fr, 1.fr, 1.fr, 1.fr],
          //   children: WorkOuts.map((workout) => _workoutBox(workout)).toList(),
          // ),
          child: QuestionWithStripSelect(
              0,
              "",
              [
                "1:1 Individual Training",
                "Bodybuilding",
                "Boxing",
                "Cardio",
                "Corrective exercise",
                "Free Weights",
                "Flexology",
                "Glute Building",
                "Group Training",
                "Health coaching",
                "Nutrition",
                "Personal Training",
                "Posing",
                "Rehabilitation & Therapy Services",
                "Senior Fitness",
                "Show Prep",
                "Strength and Conditioning",
                "Stretching",
                "Supplement/Smoothie Bar",
                "Synchronized Swimming",
                "Youth Fitness",
                "Weight loss transformation",
                "Weight Machines",
                "Yoga",
              ],
              (dynamic value) => {widget.updateFavWorkouts(value)},
              savedVal: widget.savedWorkouts),
        )
      ],
    );
  }

  Widget _workoutBox(workOut) => GridPlacement(
        child: GestureDetector(onTap: () {
          final index = selectedWorkouts.indexOf(workOut['workout']);
          if (index > -1) {
            setState(() {
              selectedWorkouts.removeAt(index);
            });
          } else {
            setState(() {
              selectedWorkouts.add(workOut['workout']);
            });
          }
          widget.updateFavWorkouts(selectedWorkouts);
        }, child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return Stack(
            children: [
              Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: workOut['color'],
                      borderRadius: BorderRadius.all(Radius.circular(14))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (workOut["image_type"] == "png")
                        SizedBox(
                          child: Image.asset(
                            workOut["asset"],
                            width: constraints.maxWidth * 0.6,
                            height: constraints.maxHeight * 0.6,
                            color: Colors.white,
                          ),
                        ),
                      if (workOut["image_type"] == "svg")
                        SvgPicture.asset(workOut["asset"],
                            color: Colors.white,
                            width: constraints.maxWidth * 0.5,
                            height: constraints.maxHeight * 0.6),
                      if (workOut["image_type"] == "icon")
                        Icon(
                          Icons.directions_run,
                          size: constraints.maxWidth * 0.6,
                          color: Colors.white,
                        ),
                      Container(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(workOut['workout'],
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  )),
              selectedWorkouts.indexOf(workOut['workout']) > -1
                  ? Positioned(
                      top: 10,
                      right: 10,
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.white,
                      ))
                  : Container()
            ],
          );
        })),
        columnStart: workOut['colStart'],
        columnSpan: workOut['colSpan'],
        rowStart: workOut['rowStart'],
        rowSpan: workOut['rowSpan'],
      );
}
