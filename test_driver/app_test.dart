library test_driver.elec_daily_option_test;

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Elec daily option tests', () {
    final dollarPrice = find.byValueKey('_edo_dollarPrice');

    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        await driver.close();
      }
    });

    test('get dollar price', () async {
      var value0 = await driver.getText(dollarPrice);

      print('hi');
      expect(value0, '1223');
    });
  });
}
