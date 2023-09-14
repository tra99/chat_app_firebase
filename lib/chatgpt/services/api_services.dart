import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/ap_constants.dart';
import '../models/chat_model.dart';
import '../models/model.dart';

class ApiService {
  static Future<List<Models>> getModels() async {
    try {
      var response = await http.get(Uri.parse("$BASE_URL/models"),
          headers: {'Authorization': 'Bearer $API_KEY'});
      Map jsonsResponse = jsonDecode(response.body);
      if (jsonsResponse['error'] != null) {
        throw HttpException(jsonsResponse['error']['message']);
      }
      List temp = [];
      for (var value in jsonsResponse["data"]) {
        temp.add(value);
      }
      return Models.modelsFromSnapshot(temp);
    } catch (error) {
      print("error $error");
      rethrow;
    }
  }

  // sent message fact
  static Future<List<ChatModel>> sendMessage(
      {required String message}) async {
    try {
      var response = await http.post(Uri.parse("$BASE_URL/completions"),
          headers: {
            'Authorization': 'Bearer $API_KEY',
            "Content-Type": "application/json",
          },
          body: jsonEncode(
              {"model": "gpt-4", "stream": true, "max_tokens": 100}));
      Map jsonsResponse = jsonDecode(response.body);
      if (jsonsResponse['error'] != null) {
        throw HttpException(jsonsResponse['error']['message']);
      }
      List<ChatModel> chatList = [];
      if (jsonsResponse['choices'].length > 0) {
        // print("jsonResponse[choices]text ${jsonsResponse['choices'][0]['text']}");
        chatList = List.generate(
            jsonsResponse['choices'].length,
            (index) => ChatModel(
                  msg: jsonsResponse['choices'][index]['text'],
                  chatIndex: 1,
                ));
      }
      return chatList;
    } catch (error) {
      print("error $error");
      rethrow;
    }
  }
}
