// import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:maya/main.dart';

void main() {
  testWidgets('Main page', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    // Verify that our counter starts at 0.
    expect(find.textContaining('Create new'), findsOneWidget);

    // Tap the '+' icon and trigger a frame.
    // await tester.tap(find.byIcon(Icons.add));
    // await tester.pump();
    //
    // // Verify that our counter has incremented.
    // expect(find.text('0'), findsNothing);
    // expect(find.text('1'), findsOneWidget);
  });
}
