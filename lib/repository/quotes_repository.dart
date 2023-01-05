import 'dart:convert';

import 'package:citations/models/quotes.dart';
import 'package:http/http.dart' as http;

class Quotesrepository {
  static Future<Quote> get() async {
    Map<String, String> headers = {
      'X-Api-Key': 'TkTnSAfEtM4h5EU1aYvpuA==0BexmkfwzQewxXH4'
    };
    final response = await http.get(
        Uri.parse('https://api.api-ninjas.com/v1/quotes?category=movies'),
        headers: headers);
    final jsonData = json.decode(response.body)[0];

    return Quote(autore: jsonData['author'], citazione: jsonData['quote']);
  }
}
