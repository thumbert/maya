import 'package:flutter/material.dart';
import 'package:maya/models/new/calculator_model.dart';
import 'package:maya/models/new/calculator_model/elec_daily_option.dart' as edo;
import 'package:maya/screens/calculators/elec_daily_option/elec_daily_option.dart';
import 'package:maya/screens/calculators/elec_swap/elec_swap.dart';
import 'package:maya/screens/error404.dart';
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
          ChangeNotifierProvider(
              create: (context) => edo.CalculatorModel()..init()),
        ],
        child: MaterialApp(
          title: 'Maya',
          onGenerateRoute: _routes(),
          initialRoute: HomePage.route,
          home: HomePage(),
          onUnknownRoute: (settings) {
            return MaterialPageRoute(builder: (_) => Error404());
          },
          theme: ThemeData(
            primarySwatch: Colors.indigo,
            buttonColor: Colors.orange[200],
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
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
        screen = ElecSwapCalculatorUi();
        break;
      case '/calculators/2':
        screen = ElecDailyOptionUi();
        break;
      default:
        screen = Error404();
        break;
    }
    return MaterialPageRoute(builder: (context) => screen);
  };
}
