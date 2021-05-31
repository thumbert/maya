// library test_driver.elec_daily_option_test;
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:integration_test/integration_test.dart';
// import 'package:maya/main.dart';
//
// void main() {
//   IntegrationTestWidgetsFlutterBinding.ensureInitialized();
//
//   testWidgets('get dollar price', (WidgetTester tester) async {
//     final dollarPrice = find.byKey(Key('_edo_dollarPrice'));
//
//     await tester.pumpWidget(MyApp());
//     await tester.pumpAndSettle();
//
//     await tester.tap(find.byKey(Key('elec_daily_option')));
//     await tester.pumpAndSettle(Duration(seconds: 5));
//
//     print('hi');
//     expect(dollarPrice.toString(), '1223');
//   });
// }
