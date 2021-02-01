import 'package:flutter/material.dart';
import 'package:maya/screens/calculators/elec_daily_option/elec_daily_option_main.dart';
import 'package:maya/screens/calculators/elec_swap/elec_swap_main.dart';
import 'package:maya/screens/error404.dart';
import 'package:maya/screens/homepage/homepage.dart';
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
    return MaterialApp(
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
    );
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
        screen = ElecSwapMainUi();
        break;
      case '/calculators/2':
        screen = ElecDailyOptionMainUi();
        break;
      default:
        screen = Error404();
        break;
    }
    return MaterialPageRoute(builder: (context) => screen);
  };
}
