import 'package:flutter/material.dart';
import 'package:spotter/Components/common/profilePic.dart';
import 'package:spotter/Components/screens/trainers_list/model.dart';
import 'package:spotter/Components/screens/trainers_list/shimmer_card.dart';

Widget listCard(TrainerData trainer, BuildContext context) => InkWell(
      borderRadius: BorderRadius.circular(24),
      child: Card(
          color: Color.fromRGBO(158, 158, 158, 1),
          elevation: 4,
          // color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Container(
            height: 80,
            padding: EdgeInsets.fromLTRB(5, 5, 25, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    // child: trainer.imageUrl != ""
                    //     ?
                    child: ProfilePic(60,
                        color: Colors.black,
                        cache: false,
                        imageUrl: trainer.imageUrl)
                    // ClipOval(
                    //     child: Image.network(
                    //       trainer.imageUrl,
                    //       width: 60,
                    //       height: 60,
                    //       errorBuilder: (BuildContext context,
                    //           Object exception, StackTrace stackTrace) {
                    //         return Icon(
                    //           Icons.account_circle_rounded,
                    //           size: 70,
                    //         );
                    //       },
                    //     ),
                    //   )
                    // : Icon(
                    //     Icons.account_circle_rounded,
                    //     size: 70,
                    //   )
                    // ,
                    ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                        // alignment: Alignment.center,
                        child: Text('${trainer.name}',
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // rating(),
                          // Text(
                          //     trainer.specialization.length > 0
                          //         ? trainer.specialization[0] ?? ""
                          //         : "",
                          //     style: TextStyle(
                          //         color: Colors.white, fontSize: 12.0)),
                          Text("${trainer.distance} mi away",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 10.0)),
                          // Container(
                          //     child: Row(
                          //   children: [
                          //     Icon(Icons.social_distance,
                          //         color: Colors.black, size: 18),
                          //   ],
                          // ))
                          Text("${trainer.percentageMatch}% match",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 10.0)),
                        ],
                      ),
                    ],
                  ),
                )

                // Container(
                //   alignment: Alignment.center,
                //   child: Text(trainer['yoe']),
                // ),
              ],
            ),
          )),
      onTap: () {
        Navigator.pushNamed(context, '/trainer_profile',
            arguments: {"permalink": trainer.permalink});
      },
    );

Widget buildMovieShimmer(BuildContext context) => Card(
    elevation: 4,
    color: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    child: Container(
        height: 80,
        padding: EdgeInsets.fromLTRB(5, 5, 25, 5),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          CustomWidget.circular(height: 64, width: 64),
          Padding(
            padding: const EdgeInsets.only(left: 10),
          ),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                CustomWidget.rectangular(
                  height: 16,
                  width: MediaQuery.of(context).size.width * 0.3,
                ),
                Padding(padding: EdgeInsets.all(8)),
                CustomWidget.rectangular(
                    height: 16, width: MediaQuery.of(context).size.width * 0.6)
              ]))
        ])));

Widget rating() => Container(
    alignment: Alignment.topLeft,
    child: Row(
      children: [
        Icon(
          Icons.star,
          size: 15,
          color: Colors.yellow[700],
        ),
        Icon(
          Icons.star,
          size: 15,
          color: Colors.yellow[700],
        ),
        Icon(
          Icons.star,
          size: 15,
          color: Colors.yellow[700],
        ),
        Icon(
          Icons.star,
          size: 15,
          color: Colors.yellow[700],
        ),
        Icon(
          Icons.star_border,
          size: 15,
          color: Colors.yellow[700],
        )
      ],
    ));
