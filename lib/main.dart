import 'package:flutter/material.dart';
import 'package:templeticketsystem/base/bottom_nav_bar.dart';
import 'package:templeticketsystem/base/res/styles/app_styles.dart';
import 'package:templeticketsystem/base/utils/app_routes.dart';
import 'package:templeticketsystem/screens/home/all_tickets.dart';
import 'package:templeticketsystem/screens/home/all_temples.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: 'AIzaSyDzEqy5IV75KqzH3bxr6xRGEXpZyPOFra0',
        appId: '1:147328342265:android:2ebdba368f0b5441a86a28',
        messagingSenderId: '147328342265',
        projectId: 'ticketbookingsys',
        storageBucket: 'ticketbookingsys.appspot.com',
      )
  );  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {

    return   MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        AppRoutes.homePage:(context)=> const BottomNavBar(),
        AppRoutes.allTickets:(context)=> const AllTickets(),
        AppRoutes.alltemples:(context)=> const AllTemples(),
      },
    );
  }
}


