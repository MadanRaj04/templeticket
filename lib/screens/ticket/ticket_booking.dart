import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:templeticketsystem/screens/ticket/qr_viewer.dart';
import 'package:templeticketsystem/screens/home/home_screen.dart';
import 'package:templeticketsystem/screens/ApiStore.dart';
import 'package:templeticketsystem/screens/ticket/choosepaymentmethod.dart';
import 'package:templeticketsystem/screens/CryptoWallet/genwallet.dart';
class TicketBooking extends StatefulWidget {

  final String? eventName;
  final int? PriceA;
  final int? PriceC;

  const TicketBooking({Key? key, this.eventName, this.PriceA, this.PriceC})
      : super(key: key);

  @override
  State<TicketBooking> createState() => _TicketBookingState();
}

class _TicketBookingState extends State<TicketBooking> {
  int adultsCount = 0;
  int childrenCount = 0;
  Razorpay? _razorpay;
  FirebaseFirestore db = FirebaseFirestore.instance;
  String emailenc=''; // Declare emailenc here

  TextEditingController _NameController = TextEditingController();
  TextEditingController _EmailController = TextEditingController();
  TextEditingController _Phonecontroller = TextEditingController();

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final key = utf8.encode('uSAjM8QzucBgRmaDIMD48V9R');
    final bytes = utf8.encode('${response.orderId}|${response.paymentId}');
    final hmacSha256 = Hmac(sha256, key);
    final generatedSignature = hmacSha256.convert(bytes);

    if (generatedSignature.toString() == response.signature) {
      debugPrint("Payment was successful!");

      // Create a map containing the payment data
      Map<String, dynamic> paymentData = {
        "username": _NameController.text,
        "Email": _EmailController.text,
        "UID": response.signature,
      };

      // Check if the document exists
      print("calling firebasestorage");

      await firestorestorage(widget.eventName.toString(),_NameController.text,emailenc,response.signature.toString());
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Success: Payment Successful"),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      debugPrint("The payment was unauthentic!");
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR HERE: ${response.code} - ${response.message}",
        timeInSecForIosWeb: 4);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET IS : ${response.walletName}",
        timeInSecForIosWeb: 4);
  }

  void openPaymentPortal(int amt) async {
    var options = {
      'key': 'rzp_test_WP5dpf7LDm87Tn',
      'amount': amt*100,
      'name': 'placeholder',
      'description': 'Payment',
      'prefill': {'contact': '9999999999', 'email': 'placeholder@razorpay.com'},

    };

    try {
      _razorpay?.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //* create order##############################################################
  void createOrder(int amt, String emailenc) async {
    String username = 'rzp_test_WP5dpf7LDm87Tn'; // Razorpay pay key
    String password = "uSAjM8QzucBgRmaDIMD48V9R"; // Razorpay secret key
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    Map<String, dynamic> body = {
      "amount": amt * 100,
      "currency": "INR",
      "receipt": "rcptid_11"
    };
    print("entered createorder");
    try {
      DocumentSnapshot snapshot = await db.collection("Payments").doc(widget.eventName).get();
      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

        print("if entered");
        if (data != null && data.containsKey(_NameController.text)) {
          print("entering");
          String userData = snapshot.get(_NameController.text).toString();
          String UID = snapshot.get(_NameController.text)["UID"];
          if (userData != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QRImage(UID)),
            );
            print("Already registered");
          }
        }
        else{
          print("entering else");
          try {
            var res = await http.post(
              Uri.https("api.razorpay.com", "v1/orders"),
              headers: <String, String>{
                "Content-Type": "application/json",
                'authorization': basicAuth,
              },
              body: jsonEncode(body),
            );

            if (res.statusCode == 200) {
              print("Entering 200 successfully");
              var orderId = jsonDecode(res.body)["id"]; // Extracting orderId from response
              print(orderId);
              openCheckout(orderId,amt);
            } else {
              debugPrint("Failed to create order: ${res.statusCode}");
              // Handle error
            }
          } catch (e) {
            debugPrint("Error creating order: $e");
            // Handle error
          }

        }

      }
      else{
        print("entering else");
        try {
          var res = await http.post(
            Uri.https("api.razorpay.com", "v1/orders"),
            headers: <String, String>{
              "Content-Type": "application/json",
              'authorization': basicAuth,
            },
            body: jsonEncode(body),
          );

          if (res.statusCode == 200) {
            print("Entering 200 successfully");
            var orderId = jsonDecode(res.body)["id"]; // Extracting orderId from response
            print(orderId);
            openCheckout(orderId,amt);
          } else {
            debugPrint("Failed to create order: ${res.statusCode}");
            // Handle error
          }
        } catch (e) {
          debugPrint("Error creating order: $e");
          // Handle error
        }

      }
      print("try entered");

    }
    catch (e) {

      print("Error checking username: $e");
      // Handle error
    }

  }

  void openCheckout(String orderId,int amt) async {
    print("entered successfully");
    var options = {
      'key': 'rzp_test_WP5dpf7LDm87Tn',
      "amount": amt * 100,
      'order_id': orderId,
      'name': _NameController.text,
      'prefill': {'contact': _Phonecontroller.text, 'email': _EmailController.text},

    };

    try {
      _razorpay?.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  Future<String> encryption(String data) async {
    final encdata = await Encryptdata(data);
    setState(() {
      emailenc = encdata; // Assign encdata to emailenc
    });
    return encdata;
  }


  void _showPaymentMethodDialog(int totalAmount) async {
    String emailenc = await encryption(_EmailController.text);
    print(emailenc);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Payment Method'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Credit/Debit/Netbanking'),
                onTap: () {

                  createOrder(((adultsCount * (widget.PriceA ?? 0)) + (childrenCount * (widget.PriceC ?? 0))),emailenc);
                },
              ),
              ListTile(
                title: Text('Cryptocurrencies'),
                onTap: () {
                  Navigator.pop(context); // Close the dialog
                  _handleCryptocurrencies(totalAmount);
                },
              ),
            ],
          ),
        );
      },
    );
  }


  void _handleCryptocurrencies(int totalAmount) {

    Navigator.push(
       context,
       MaterialPageRoute(builder: (context) => WalletApp()),
     );
  }

  @override
  void initState(){
    super.initState();
    _razorpay = Razorpay();
    _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Ticket Booking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Center(
              child: Text(
                widget.eventName ?? 'Event Name Not Available',
                style: TextStyle(fontSize: 24),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _NameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _EmailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _Phonecontroller,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            SizedBox(height: 20),
            Text(
              'Number of Persons',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(labelText: 'Total Adults'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        adultsCount = int.tryParse(value) ?? 0;
                      });
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(labelText: 'Total Children'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        childrenCount = int.tryParse(value) ?? 0;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Total Amount: \₹${((adultsCount * (widget.PriceA ?? 0)) + (childrenCount * (widget.PriceC ?? 0)))}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Check if the phone number is valid
                  if (_Phonecontroller.text.length != 10 ||
                      !RegExp(r'^[0-9]+$').hasMatch(_Phonecontroller.text)) {
                    Fluttertoast.showToast(
                      msg: 'Please enter a valid 10-digit phone number',
                      timeInSecForIosWeb: 4,
                    );
                  } else {
                    // Show the payment method dialog if the phone number is valid
                    _showPaymentMethodDialog(
                        ((adultsCount * (widget.PriceA ?? 0)) +
                            (childrenCount * (widget.PriceC ?? 0))));
                  }
                },
                child: Text('Book Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
