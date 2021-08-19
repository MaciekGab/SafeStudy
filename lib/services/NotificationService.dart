import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../Keys.dart';

class NotificationService {
  static final http.Client client = http.Client();
  static final Uri url = Uri.parse(urlToFcm);
   static Future<http.Response> sendTo({@required String title, @required String body, @required List<String> fcmTokens}) async{
     return await client.post(
       url,
       body: json.encode({
         "registration_ids" : fcmTokens,
         "priority" : "high",
         "notification" : {
           "body" : body,
           "title": title
         }
       }),
       headers: {
         "Content-Type": "application/json",
         "Authorization": "key=$serverKey"
       }
     );
   }
}