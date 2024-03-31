import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:templeticketsystem/base/utils/all_json.dart';
import 'package:templeticketsystem/base/widgets/ticket_view.dart';
import 'package:templeticketsystem/screens/home/widgets/hotel.dart';
import 'package:templeticketsystem/screens/home/widgets/templeview.dart';

class AllTemples extends StatelessWidget {
  const AllTemples({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Temples"),
      ),
      body: ListView(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: hotelList

                  .map((singleHotel) => Column(
                children: [
                  TempleView(hotel: singleHotel),
                  SizedBox(height: 20), // Adjust the height as needed
                ],
              ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

