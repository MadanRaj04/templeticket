import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:templeticketsystem/base/res/media.dart';
import 'package:templeticketsystem/base/res/styles/app_styles.dart';
import 'package:templeticketsystem/base/utils/all_json.dart';
import 'package:templeticketsystem/base/widgets/app_coloum_text_layout.dart';
import 'package:templeticketsystem/base/widgets/app_layoutbuilder_widget.dart';
import 'package:templeticketsystem/base/widgets/ticket_view.dart';
import 'package:templeticketsystem/screens/search/widgets/app_ticket_tabs.dart';
class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key});

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> with TickerProviderStateMixin {
  @override

  Widget build(BuildContext context) {
    List images = [
      "assets/images/guruvayur.png",
      "assets/images/tirupathi.png",
    ];
    TabController _tabController = TabController(length: 2, vsync: this);

    return Scaffold(
        backgroundColor: AppStyles.bgColor,
        body:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              padding: const EdgeInsets.only(
                top: 70,
        ),
    ),
            Container(
            padding: const EdgeInsets.only(
            left: 20,
            ),
            child: Text("MY Tickets", style: AppStyles.headLineStyle1,)),
            Container(
              padding: const EdgeInsets.only(
                top: 40,
              ),
            ),
            Container(

              child: TabBar(
                  unselectedLabelColor: Colors.grey,
                  controller:  _tabController,
                  tabs: [
                    Tab(text: "Upcoming"),
                    Tab(text: "Past")
                  ],
                ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10),
              width: double.maxFinite,
              height: 610,
              child: TabBarView(
                controller:  _tabController,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: ticketList
                          .map((singleTicket) =>
                          Container(
                              margin: EdgeInsets.only(bottom: 20),
                              child: TicketView(ticket: singleTicket, wholeScreen: true,)
                          ))
                          .toList(),
                    ),
                  ),
                  ListView.builder(
                      itemCount:2,
                      itemBuilder: (_, index){
                        return Container(
                          height:300,
                          width:200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image:DecorationImage(
                                image : AssetImage(
                                    images[index]
                                )
                            ),
                          ),

                        );

                      }),
                ],


              ),
            ),

          ],
        )
    );
  }
}
