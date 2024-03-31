import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:templeticketsystem/base/res/media.dart';
import 'package:templeticketsystem/base/res/styles/app_styles.dart';

class TempleView extends StatelessWidget {
  final Map<String,dynamic> hotel;
  const TempleView({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: size.width*0.8,
      height: 350,
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
          color: AppStyles.ticketBlue,
          borderRadius: BorderRadius.circular(18)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
                color: AppStyles.primaryColor,
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                    fit:BoxFit.cover,
                    image: AssetImage(
                        "assets/images/${hotel['image']}"
                    )
                )
            ),
          ),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              hotel['place'],
              style: AppStyles.headLineStyle1.copyWith(color:AppStyles.kakiColor),
            ),
          ),
          SizedBox(height: 5,),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              hotel['destination'],
              style: AppStyles.headLineStyle3.copyWith(color:Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
