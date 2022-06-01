import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pay/pay.dart' as pay;
import 'package:spotter/Components/common/IconWithText.dart';
import 'package:spotter/Components/common/LoadingIndicator.dart';
import 'package:spotter/Components/common/bottomDialog.dart';
import 'package:spotter/Components/screens/checkout/checkout.dart';
import 'package:spotter/Components/screens/checkout/payment_success.dart';
import 'package:spotter/Components/screens/map/gyms_list.dart';
import 'package:spotter/Components/screens/profile_setup/gym_owner/questions_data.dart';
import 'package:spotter/core/endpoints.dart';
import 'package:spotter/core/http.dart';

class GymDetails extends StatefulWidget {
  final bool openGymDetails;
  final Function setOpenGymDetails;
  final GymLocation selectedGymDetails;
  final bool update;
  final Function openImageEdit;
  const GymDetails(
      {this.setOpenGymDetails,
      this.openGymDetails = false,
      this.selectedGymDetails,
      this.update = false,
      this.openImageEdit});
  @override
  _State createState() => _State();
}

class _State extends State<GymDetails> {
  List<pay.PaymentItem> _paymentItem = [
    pay.PaymentItem(amount: "20", label: "Item name")
  ];
  int buyCount = 1;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          transform: Matrix4.translationValues(
              0,
              widget.openGymDetails ? 0 : MediaQuery.of(context).size.height,
              0),
          color: Colors.white,
          padding: widget.update
              ? EdgeInsets.only(left: 20, right: 20)
              : EdgeInsets.fromLTRB(20, 40, 20, 40),
          child: (widget.openGymDetails)
              ? SingleChildScrollView(
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            child: Row(
                              children: [
                                InkWell(
                                    onTap: () {
                                      widget.setOpenGymDetails(false);
                                    },
                                    child: Icon(Icons.arrow_back)),
                                Expanded(
                                    child: Text(widget.selectedGymDetails.name,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 24))),
                                if (widget.update)
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context,
                                            '/update_gym_profile_setup');
                                      },
                                      child: Text('Edit'))
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                imageList(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: rating(),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: iconWithFlexibleText(
                                      Icons.near_me_outlined,
                                      widget.selectedGymDetails.address),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: iconWithFlexibleText(
                                      Icons.phone_outlined,
                                      widget.selectedGymDetails.phone),
                                ),
                                // isNotEmpty(widget.selectedGymDetails.dropInFee)
                                // ?
                                dropInRates(),
                                // : Container(),
                                ...about(),
                                if (widget
                                        .selectedGymDetails.equipments.length >
                                    0)
                                  ...equipments(),
                                if (widget.selectedGymDetails.aminities.length >
                                    0)
                                  ...aminitiesWrapper(),
                                if (widget.selectedGymDetails.specialization
                                        .length >
                                    0)
                                  ...specialization()
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              : Container(),
        ),
        if (loading) LoadingIndicator()
      ],
    );
  }

  Widget dropInRates() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.money),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                    "Drop-in Rate - \$${widget.selectedGymDetails.dropInFee}/day"),
              ),
            ],
          ),
          widget.update
              ? Container()
              : Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: counter(),
                    ),
                    SizedBox(
                      width: 44,
                      child: TextButton(
                          onPressed: () => {
                                // _paymentItem = [
                                //         PaymentItem(amount: "${20*buyCount}", label: "Item name")
                                //       ]
                                BottomDialog().showBottomDialog(
                                    context, payDialogContent())
                              },
                          child: Text(
                            'Buy',
                            style: TextStyle(fontSize: 14),
                          ),
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black))),
                    )
                  ],
                )
        ],
      ),
    );
  }

  Widget counter() {
    return Row(children: [
      SizedBox(
        width: 20,
        child: TextButton(
            onPressed: () {
              if (buyCount > 1) {
                setState(() {
                  buyCount--;
                });
                _paymentItem = [
                  pay.PaymentItem(
                      amount: "${20 * buyCount}", label: "Item name")
                ];
              }
            },
            child: Text("-"),
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.grey[200]))),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("$buyCount"),
      ),
      SizedBox(
        child: TextButton(
            onPressed: () {
              setState(() {
                buyCount++;
              });
              _paymentItem = [
                pay.PaymentItem(amount: "${20 * buyCount}", label: "Item name")
              ];
            },
            child: Text("+"),
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.grey[200]))),
        width: 24,
      )
    ]);
  }

  Widget imageList() {
    return Container(
      height: 225,
      child: widget.selectedGymDetails.imageURLs != null &&
              widget.selectedGymDetails.imageURLs.length > 0
          ? ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ...widget.selectedGymDetails.imageURLs.map((imageURL) {
                  if (imageURL != null)
                    return Container(
                        margin: EdgeInsets.only(left: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            color: Colors.grey,
                            child: Image.network(imageURL,
                                width: 150, fit: BoxFit.fitHeight, errorBuilder:
                                    (BuildContext context, Object exception,
                                        StackTrace stackTrace) {
                              return Container(width: 150);
                            }),
                          ),
                        ));
                }).toList(),
                if (widget.update)
                  TextButton(
                    child: Text("+ AddMore Images"),
                    onPressed: () {
                      if (widget.update) {
                        widget.openImageEdit();
                      }
                    },
                  )
              ],
            )
          : Row(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey,
                  ),
                  width: 150,
                  child: Text(
                    "No images uploaded",
                    textAlign: TextAlign.center,
                  ),
                ),
                if (widget.update)
                  TextButton(
                    child: Text("+ AddMore Images"),
                    onPressed: () {
                      if (widget.update) {
                        widget.openImageEdit();
                      }
                    },
                  )
              ],
            ),
    );
  }

  Widget rating() => Padding(
        padding: const EdgeInsets.only(top: 12.0, bottom: 12),
        child: Row(
          children: [
            Icon(
              Icons.star,
              size: 20,
              color: Colors.yellow[700],
            ),
            Icon(
              Icons.star,
              size: 20,
              color: Colors.yellow[700],
            ),
            Icon(
              Icons.star,
              size: 20,
              color: Colors.yellow[700],
            ),
            Icon(
              Icons.star,
              size: 20,
              color: Colors.yellow[700],
            ),
            Icon(
              Icons.star_border,
              size: 20,
              color: Colors.yellow[700],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text('(${widget.selectedGymDetails.rating})'),
            ),
          ],
        ),
      );

  List<Widget> about() {
    return [
      Padding(
        padding: EdgeInsets.fromLTRB(8, 20, 8, 0),
        child: Text("About",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            )),
      ),
      Padding(
          padding: EdgeInsets.fromLTRB(8, 20, 8, 12),
          child: Text(widget.selectedGymDetails.about))
    ];
  }

  List<Widget> equipments() {
    return [
      Padding(
        padding: EdgeInsets.fromLTRB(8, 20, 8, 12),
        child: Text("Equipment",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            )),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
            spacing: 10,
            runSpacing: 5,
            children: widget.selectedGymDetails.equipments
                .asMap()
                .entries
                .map((entry) {
              return SvgPicture.asset(
                'assets/images/${equipment.firstWhere((element) {
                  return entry.value == element["text"];
                })["icon"]}.svg',
                width: 32,
                height: 32,
              );
            }).toList()),
      ),
    ];
  }

  List<Widget> aminitiesWrapper() {
    return [
      Padding(
        padding: EdgeInsets.fromLTRB(8, 20, 8, 12),
        child: Text("Aminities",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            )),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
            spacing: 10,
            runSpacing: 5,
            children: widget.selectedGymDetails.aminities
                .asMap()
                .entries
                .map((entry) {
              return SvgPicture.asset(
                'assets/images/${aminities.firstWhere((element) {
                  return entry.value == element["text"];
                })["icon"]}.svg',
                width: 32,
                height: 32,
              );
            }).toList()),
      ),
    ];
  }

  List<Widget> specialization() {
    return [
      Padding(
        padding: EdgeInsets.fromLTRB(8, 20, 8, 12),
        child: Text("Specialization",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            )),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
            spacing: 10,
            runSpacing: 5,
            // direction: Axis.horizontal,
            children: widget.selectedGymDetails.specialization
                .asMap()
                .entries
                .map((entry) {
              return Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(234, 234, 235, 1),
                ),
                child: Text(entry.value,
                    style: TextStyle(
                        fontSize: 12, color: Color.fromRGBO(54, 53, 52, 1))),
              );
            }).toList()),
      )
    ];
  }

  Widget payDialogContent() {
    return IntrinsicHeight(
      child: Container(
        width: double.maxFinite,
        clipBehavior: Clip.antiAlias,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Material(
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 24,
                  ),
                  TextButton(
                      onPressed: () async {
                        // get session id from backend
                        final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CheckoutPage(
                                    // sessionId: sessionId,
                                    )));
                      },
                      child: Text(
                        'Checkout with Card',
                        style: TextStyle(fontSize: 15),
                      ),
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          fixedSize:
                              MaterialStateProperty.all<Size>(Size(200, 50)),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black))),
                  pay.ApplePayButton(
                    paymentConfigurationAsset: 'applepay.json',
                    paymentItems: _paymentItem,
                    style: pay.ApplePayButtonStyle.black,
                    width: 200,
                    height: 50,
                    type: pay.ApplePayButtonType.checkout,
                    margin: const EdgeInsets.only(top: 15.0),
                    onPaymentResult: (data) async {
                      Navigator.pop(context);
                      setState(() {
                        loading = true;
                      });
                      try {
                        // 1. Fetch stripe token
                        // 2. fetch Intent Client Secret from backend
                        // // 3. Confirm Apple pay payment method

                        setState(() {
                          loading = false;
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    PaymentSuccessful()));
                      } catch (e) {
                        print(e);
                        setState(() {
                          loading = false;
                        });
                      }
                    },
                    loadingIndicator: const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.yellow,
                      ),
                    ),
                  ),
                  pay.GooglePayButton(
                    paymentConfigurationAsset: 'gpay.json',
                    paymentItems: _paymentItem,
                    style: pay.GooglePayButtonStyle.black,
                    type: pay.GooglePayButtonType.pay,
                    margin: const EdgeInsets.only(top: 15.0),
                    onPaymentResult: (data) {
                      print(data);
                    },
                    loadingIndicator: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
