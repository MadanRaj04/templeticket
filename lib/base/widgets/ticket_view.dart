import 'package:flutter/material.dart';
import 'package:templeticketsystem/base/res/styles/app_styles.dart';
import 'package:templeticketsystem/base/utils/all_json.dart';
import 'package:templeticketsystem/base/widgets/app_coloum_text_layout.dart';
import 'package:templeticketsystem/base/widgets/app_layoutbuilder_widget.dart';
import 'package:templeticketsystem/base/widgets/big_circle.dart';
import 'package:templeticketsystem/base/widgets/text_style_fourth.dart';
import 'package:templeticketsystem/base/widgets/text_style_third.dart';
import 'package:templeticketsystem/screens/ticket/ticket_booking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TicketView extends StatelessWidget {
  final Map<String, dynamic> ticket;
  final bool wholeScreen;
  final bool? isColor;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  TicketView({
    Key? key,
    required this.ticket,
    this.wholeScreen = false,
    this.isColor,
  });

  Future<int> _getTotalElements() async {
    DocumentSnapshot snapshot =
    await db.collection("Payments").doc(ticket["from"]["name"]).get();

    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        return data.keys.length;
      }
    }
    return 0; // Return 0 if document doesn't exist or data is null
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return FutureBuilder<int>(
      future: _getTotalElements(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for the future to complete, show a loading indicator
          return CircularProgressIndicator();
        } else {
          if (snapshot.hasError) {
            // If an error occurred, you can handle it here
            return Text('Error: ${snapshot.error}');
          } else {
            // Once the future is completed, build your widget with the retrieved totalElements
            int totalElements = snapshot.data ?? 0;
            return SizedBox(
              width: size.width * 0.85,
              height: 180,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TicketBooking(
                        eventName: ticket["from"]["name"],
                        PriceA: ticket["priceA"],
                        PriceC: ticket["priceC"],
                      ),
                    ),
                  );
                },
                child: Container(
                  margin:
                  EdgeInsets.only(right: wholeScreen == true ? 0 : 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isColor == null
                              ? AppStyles.ticketBlue
                              : AppStyles.ticketColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(21),
                            topRight: Radius.circular(21),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(child: Container()),
                                Expanded(child: Container()),
                                TextStyleThird(
                                  text: ticket["from"]["code"],
                                  isColor: isColor,
                                ),
                                Expanded(child: Container()),
                                Expanded(child: Container()),
                              ],
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Row(
                              children: [
                                SizedBox(width: 120),
                                SizedBox(
                                  width: 100,
                                  child: TextStyleFourth(
                                    text: ticket["from"]["name"],
                                    isColor: isColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: isColor == null
                            ? AppStyles.ticketOrange
                            : AppStyles.ticketColor,
                        child: Row(
                          children: [
                            BigCircle(
                              isRight: false,
                              isColor: isColor,
                            ),
                            Expanded(
                              child: AppLayoutBuilderWidget(
                                randomDivider: 16,
                                width: 6,
                                isColor: isColor,
                              ),
                            ),
                            BigCircle(
                              isRight: true,
                              isColor: isColor,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isColor == null
                              ? AppStyles.ticketOrange
                              : AppStyles.ticketColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(isColor == null ? 21 : 0),
                            bottomRight:
                            Radius.circular(isColor == null ? 21 : 0),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppColumnTextLayout(
                                  topText: ticket["date"],
                                  bottomText: "DATE",
                                  alignment: CrossAxisAlignment.start,
                                  isColor: isColor,
                                ),
                                AppColumnTextLayout(
                                  topText: ticket["departure_time"],
                                  bottomText: "Entry Time",
                                  alignment: CrossAxisAlignment.center,
                                  isColor: isColor,
                                ),
                                AppColumnTextLayout(
                                  topText: totalElements.toString(),
                                  bottomText: "Total",
                                  alignment: CrossAxisAlignment.end,
                                  isColor: isColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        }
      },
    );
  }
}
