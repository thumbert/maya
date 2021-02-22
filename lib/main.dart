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
        return MaterialPageRoute<void>(builder: (_) => Error404());
      },
      theme: ThemeData(
          primarySwatch: Colors.indigo,
          buttonColor: Colors.orange[200],
          visualDensity: VisualDensity.adaptivePlatformDensity,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                minimumSize: Size(100, 40), primary: Colors.orange[200]),
          )),
    );
  }
}

RouteFactory _routes() {
  return (settings) {
    var arguments = settings.arguments as Map<String, dynamic>;
    var route = settings.name + '/${arguments['calculatorType']}';
    route = route.replaceAll('_', '-');
    print(route);
    if (arguments.keys.length == 1) {
      // no initial value for the calculator, you're just coming from the calculator list
      arguments = null;
    }
    Widget screen;
    switch (route) {
      case '/calculators/elec-swap':
        screen = ElecSwapMainUi(initialValue: arguments);
        break;
      case '/calculators/elec-daily-option':
        screen = ElecDailyOptionMainUi();
        break;
      default:
        screen = Error404();
        break;
    }
    return MaterialPageRoute<void>(builder: (context) => screen);
  };
}
