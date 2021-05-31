library models.existing.load_existing;

import 'package:http/http.dart' as http;
import 'package:elec_server/client/risk_system/calculator.dart';

class LoadExisting extends CalculatorClient {
  LoadExisting({required String rootUrl}) : super(http.Client(), rootUrl: rootUrl);
}
