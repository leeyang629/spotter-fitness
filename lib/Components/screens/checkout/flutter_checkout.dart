import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:pay/pay.dart' as Pay;
import 'package:spotter/Components/screens/checkout/checkout.dart';

class StripeCheckout extends StatefulWidget {
  @override
  StripeCheckoutState createState() => StripeCheckoutState();
}

class StripeCheckoutState extends State<StripeCheckout> {
  final _paymentItem = <Pay.PaymentItem>[
    Pay.PaymentItem(amount: "20", label: "Item name")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(232, 44, 53, 1),
        title: Text(
          "Checkout Options",
        ),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
            padding: const EdgeInsets.all(64),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () async {
                      // final sessionId = await Server().createCheckout("1");
                      // final result = await Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => CheckoutPage(
                      //               sessionId: sessionId,
                      //             )));
                    },
                    child: Text(
                      'Buy with Card',
                      style: TextStyle(fontSize: 24),
                    ),
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        fixedSize:
                            MaterialStateProperty.all<Size>(Size(200, 50)),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.black))),
                Pay.ApplePayButton(
                  paymentConfigurationAsset: 'applepay.json',
                  paymentItems: _paymentItem,
                  style: Pay.ApplePayButtonStyle.black,
                  width: 200,
                  height: 50,
                  type: Pay.ApplePayButtonType.buy,
                  margin: const EdgeInsets.only(top: 15.0),
                  onPaymentResult: (data) async {
                    // print(data);
                  },
                  loadingIndicator: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                Pay.GooglePayButton(
                  paymentConfigurationAsset: 'gpay.json',
                  paymentItems: _paymentItem,
                  style: Pay.GooglePayButtonStyle.black,
                  type: Pay.GooglePayButtonType.pay,
                  margin: const EdgeInsets.only(top: 15.0),
                  onPaymentResult: (data) {
                    print(data);
                  },
                  loadingIndicator: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
