import 'package:flutter/material.dart';
import 'package:maya/models/calculator_model.dart';
import 'package:maya/screens/calculators/elec_swap/elec_swap.dart';
import 'package:maya/screens/homepage/homepage.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
          onGenerateRoute: _routes(),
          theme: ThemeData(
            primarySwatch: Colors.indigo,
            buttonColor: Colors.orange[200],
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: HomePage(),
        ));
  }
}

RouteFactory _routes() {
  return (settings) {
    final Map<String, dynamic> arguments = settings.arguments;
    var route = settings.name + '/${arguments['calculatorId']}';
    print(route);
    Widget screen;
    switch (route) {
      case '/calculators/0':
        screen = ElecSwapCalculatorUi(
          title: 'Electricity swap calculator',
        );
        break;
      default:
        screen = Text('Sorry not implemented yet! Excuse');
        break;
    }
    return MaterialPageRoute(builder: (context) => screen);
  };
}
