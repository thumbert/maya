import 'package:flutter/material.dart';
import 'package:elec/calculators/elec_swap.dart';
import '../as_of_date.dart';
import '../term.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:elec/risk_system.dart';

// Row topRow(ElecSwapCalculator calculator) {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.start,
//     children: [
//       SizedBox(width: 20),
//       TermUi(calculator),
//       SizedBox(width: 40),
//       AsOfDateUi(calculator),
//       SizedBox(width: 40),
//       AdvancedSwitch(
//         activeLabel: 'Buy',
//         inactiveLabel: 'Sell',
//         activeColor: Colors.green,
//         inactiveColor: Colors.red,
//         borderRadius: BorderRadius.circular(20),
//         width: 100,
//         height: 30,
//         value: calculator.buySell == BuySell.buy ? true : false,
//         onChanged: (value) => setState(() {
//           calculator.buySell = value ? BuySell.buy : BuySell.sell;
//         }),
//       )
//     ],
//   ),
//
// }
