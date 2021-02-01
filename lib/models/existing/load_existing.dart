library models.existing.load_existing;

import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:maya/models/new/calculator_model/elec_swap.dart';

class LoadExisting {
  LoadExisting();

  final String _baseUrl = DotEnv().env['rootUrl'] + 'calculators/v1/';

  Future<List<String>> getUsers() async {
    var url = _baseUrl + 'users';
    var aux = await http.get(url);
    var res = json.decode(aux.body) as List;
    return res.cast<String>();
  }

  Future<List<String>> getCalculatorNames(String userId) async {
    var url = _baseUrl + 'userId/$userId/names';
    var aux = await http.get(url);
    var res = json.decode(aux.body) as List;
    return res.cast<String>();
  }

  Future<CalculatorModel> getCalculator(
      String userId, String calculatorName) async {
    var url = _baseUrl + 'userId/$userId/calculatorName/$calculatorName';
    var aux = await http.get(url);
    var x = json.decode(aux.body) as Map<String, dynamic>;
    return CalculatorModel.fromJson(x);
  }
}
