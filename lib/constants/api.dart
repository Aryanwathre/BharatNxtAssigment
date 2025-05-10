import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class ApiConstants {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com/';

}
class ApiEndpoints {
  static const String posts = '${ApiConstants.baseUrl}posts';
  static const String single_post = '${ApiConstants.baseUrl}posts/';
}

class ApiService {
  var client = http.Client();
  Future<List<dynamic>> fetchPosts() async {
    final response = await client.get(Uri.parse(ApiEndpoints.posts));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future getPostById(int id) async {
    final response = await client.get(Uri.parse(ApiEndpoints.single_post + id.toString()));
    if (response.statusCode == 200) {
      var userResponse = jsonDecode(response.body);
      return userResponse;
    } else {
      throw Exception('Failed to save data');
    }
  }

}