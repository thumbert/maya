library test.widget.calculators.elec_swap_test;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maya/screens/calculators/elec_swap/elec_swap_main.dart';

void tests() {
  group('Elec swap tests:', () {
    testWidgets('price one', (WidgetTester tester) async {
      final initialValue = <String, dynamic>{
        'calculatorType': 'elec_swap',
        'term': 'Jul21-Aug21',
        'buy/sell': 'Buy',
        'comments': '',
        'legs': [
          {
            'curveId': 'isone_energy_4000_da_lmp',
            'tzLocation': 'America/New_York',
            'bucket': '5x16',
            'quantity': {
              'value': 50,
            },
          }
        ],
      };
      await tester.pumpWidget(ElecSwapMainUi(initialValue: initialValue));
      expect(find.byKey(Key('_dollarPriceValue')), findsOneWidget);
    });
  });
}

void main() {
  tests();

  // testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  //   // Build our app and trigger a frame.
  //   await tester.pumpWidget(MyApp());
  //
  //   // Verify that our counter starts at 0.
  //   expect(find.text('0'), findsOneWidget);
  //   expect(find.text('1'), findsNothing);
  //
  //   // Tap the '+' icon and trigger a frame.
  //   await tester.tap(find.byIcon(Icons.add));
  //   await tester.pump();
  //
  //   // Verify that our counter has incremented.
  //   expect(find.text('0'), findsNothing);
  //   expect(find.text('1'), findsOneWidget);
  // });
}
