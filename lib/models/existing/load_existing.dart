library models.existing.load_existing;

import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:elec_server/client/risk_system/calculator.dart';

class LoadExisting extends CalculatorClient {
  LoadExisting({rootUrl}) : super(http.Client(), rootUrl: rootUrl);
}
