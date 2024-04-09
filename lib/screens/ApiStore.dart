import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';


firestorestorage(String eventName, String name, String email, String signature) async {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final encryptedName = await Encryptdata(name);
  final encryptedEmail = await Encryptdata(email);
  final encryptedSignature = await Encryptdata(signature);
  Map<String, dynamic> paymentData = {
    "username": encryptedName,
    "Email": encryptedEmail,
    "UID": encryptedSignature,
  };
  DocumentSnapshot snapshot = await db.collection("Payments").doc(eventName).get();
  db.collection("Payments").doc(eventName).get().then((doc) {
    if (doc.exists) {
      // Document exists, update the data
      db.collection("Payments").doc(eventName).update({
        Encryptdata(name): paymentData
      }).then((_) {
        print("Document updated successfully!");
      }).catchError((error) {
        print("Error updating document: $error");
      });
    } else {
      // Document doesn't exist, create a new document
      db.collection("Payments").doc(eventName).set({
        encryptedName: paymentData
      }, SetOptions(merge: true)).then((_) {
        print("Document created successfully!");
      }).catchError((error) {
        print("Error creating document: $error");
      });
    }
  }).catchError((error) {

    print("Error creating document: $error");
  }
);
      }

Future<String> Encryptdata(String msg) async {
  final url = Uri.http('192.168.100.47:5002', '/encrypt', {
    'encrypted_message': msg
  });

  final response = await http.get(url);





  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to get message');
  }
}



Future<String> getEncrypt(String encmsg) async {
  final url = Uri.http('192.168.100.47:5002', '/decrypt', {
      'encrypted_message': encmsg
  });

  final response = await http.get(url);

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to get message');
  }
}