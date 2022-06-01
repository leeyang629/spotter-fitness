import 'package:flutter/material.dart';
import './gyms_list.dart';
import 'package:url_launcher/url_launcher.dart';

class GymCarousel extends StatefulWidget {
  final List<GymLocation> nearByGyms;
  final int gymSelected;
  final Function setSelected;
  final Function(bool) openGymDetails;

  GymCarousel(
      this.nearByGyms, this.gymSelected, this.setSelected, this.openGymDetails);

  @override
  _GymCarouselState createState() => _GymCarouselState();
}

class _GymCarouselState extends State<GymCarousel> {
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController();
  }

  void scrollTo(BuildContext context) {
    if (widget.gymSelected >= 0) {
      _scrollController.animateTo(
          (widget.gymSelected) *
              (MediaQuery.of(context).size.width * 0.75 + 10), // 10 for margin
          duration: Duration(milliseconds: 1000),
          curve: Curves.easeOutCubic);
    }
  }

  @override
  Widget build(BuildContext context) {
    scrollTo(context);
    return Container(
      // padding: EdgeInsets.only(bottom: 5),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.nearByGyms?.length,
        controller: _scrollController,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () {
                widget.setSelected(index);
              },
              child: _gymMapCard(index));
        },
      ),
    );
  }

  Widget _gymMapCard(int index) {
    return Stack(alignment: AlignmentDirectional.bottomStart, children: [
      Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.only(left: 10),
        child: Container(
          decoration: BoxDecoration(
              // gradient: widget.nearByGyms[index].onboarded
              //     ? LinearGradient(colors: [
              //         Color.fromRGBO(209, 130, 23, 1),
              //         Color.fromRGBO(255, 217, 0, 1),
              //         Color.fromRGBO(209, 130, 23, 1)
              //       ], begin: Alignment.topLeft, end: Alignment.bottomRight)
              //     : null,
              border: widget.nearByGyms[index].onboarded
                  ? Border.all(color: Color.fromRGBO(255, 182, 0, 1), width: 2)
                  : null,
              borderRadius: BorderRadius.circular(20)),
          padding: EdgeInsets.all(16),
          height: 120,
          width: MediaQuery.of(context).size.width * 0.75,
          child: Column(children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(flex: 2, child: Container()),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 12,
                        color: Color.fromRGBO(255, 186, 105, 1),
                      ),
                      Text(widget.nearByGyms[index].rating)
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Icon(
                        Icons.favorite,
                        size: 12,
                        color: Color.fromRGBO(234, 19, 42, 1),
                      ),
                      Text("-")
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(widget.nearByGyms[index].name,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600))),
            ),
            Container(
              height: 1,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Container(
                height: 22,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                        onTap: () async {
                          if (widget.nearByGyms[index].phone != "" &&
                              widget.nearByGyms[index].phone != "-" &&
                              widget.nearByGyms[index].phone != null)
                            await launch(
                                "tel:${widget.nearByGyms[index].phone}");
                        },
                        child: widget.nearByGyms[index].phone != "" &&
                                widget.nearByGyms[index].phone != "-" &&
                                widget.nearByGyms[index].phone != null
                            ? Icon(Icons.phone_outlined)
                            : Icon(Icons.phone_outlined,
                                color: Colors.black38)),
                    InkWell(
                        onTap: () {
                          widget.setSelected(index);
                          widget.openGymDetails(true);
                        },
                        child: Icon(Icons.menu))
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
      Positioned(
          top: 0,
          left: 25,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromRGBO(216, 216, 216, 1),
              border:
                  Border.all(color: Color.fromRGBO(209, 130, 23, 1), width: 4),
            ),
            child: widget.nearByGyms[index].imageURLs != null &&
                    widget.nearByGyms[index].imageURLs.length > 0 &&
                    widget.nearByGyms[index].imageURLs[0] != null
                ? ClipOval(
                    child: Image.network(
                      widget.nearByGyms[index].imageURLs[0],
                      fit: BoxFit.fitHeight,
                    ),
                  )
                : SizedBox(
                    width: 60,
                    height: 60,
                  ),
          )),
    ]);
  }
}
