import 'package:flutter/material.dart';
import 'package:maya/models/calculator_model.dart';
import 'package:maya/screens/calculators/elec_swap/elec_swap.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const homepage = '/';
const reportsRoute = '/reports';
const reportOutput = '/reports/output';

void main() async {
  initializeTimeZones();
  await DotEnv().load('.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (context) => CalculatorModel()..init()),
        ],
        child: MaterialApp(
          title: 'Maya - A modern commodity pricing interface',
          theme: ThemeData(
            primarySwatch: Colors.indigo,
            buttonColor: Colors.orange[200],
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => MyHomePage(title: 'Electricity swap calculator '),
          },
        ));
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElecSwapCalculatorUi(),
          ],
        ),
      ),
    );
  }
}
