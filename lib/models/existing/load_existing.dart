library models.existing.load_existing;

import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class LoadExisting {
  LoadExisting();

  String userId;

  final String _baseUrl = DotEnv().env['rootUrl'] + 'calculators/v1/';

  Future<List<String>> getUsers() async {
    var url = _baseUrl + 'users';
    var aux = await http.get(url);
    var res = json.decode(aux.body) as List;
    return res.cast<String>();
  }

  Future<List<String>> getCalculators() async {
    var url = _baseUrl + 'userId/$userId';
    var aux = await http.get(url) as List;
    print(aux);
    return aux.cast<String>();
  }
}
