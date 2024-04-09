import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert'; // Import the dart:convert library


firestorestorage(String eventName, String name, String email, String signature) async {
  print("inside firebasestorage");
  FirebaseFirestore db = FirebaseFirestore.instance;
  final encryptedName = await name;
  final encryptedEmail = await email;
  final encryptedSignature = await signature;
  print("encrpyted executed");
  Map<String, dynamic> paymentData = {
    "username": encryptedName,
    "Email": encryptedEmail,
    "UID": encryptedSignature,
  };
  DocumentSnapshot snapshot = await db.collection("Payments").doc(eventName).get();
  db.collection("Payments").doc(eventName).get().then((doc) {
    if (doc.exists) {
      // Document exists, update the data
      print("doc already exists");
      db.collection("Payments").doc(eventName).update({
        name: paymentData
      }).then((_) {
        print("Document updated successfully!");
      }).catchError((error) {
        print("Error updating document: $error");
      });
    } else {
      // Document doesn't exist, create a new document
      print("document does not exists");
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
  final url = Uri.http('34.224.106.165:80', '/encrypt');
  print(msg);
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'}, // Specify JSON content type
    body: jsonEncode({"message": msg}), // Encode the message as JSON
  );

  if (response.statusCode == 200) {
    return response.body;
  } else {
    print(response.body);
    throw Exception('Failed to encrypt message');
  }
}

Future<String> decryptData(String encmsg) async {
  final url = Uri.http('34.207.141.126', '/decrypt'); // Remove the port from the URL

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'}, // Specify JSON content type
    body: jsonEncode({'encrypted_message': encmsg}), // Encode the encrypted message as JSON
  );

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to decrypt message');
  }
}
