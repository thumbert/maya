library test_driver.elec_daily_option_test;

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Calculator list tests', () {
    final es = find.byValueKey('elec_swap');

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
      await driver.waitFor(es);
      var value0 = es.toString();

      print('hi');
      expect(value0, '1223');
    });
  });
}
