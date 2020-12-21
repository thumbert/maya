library models.calculator_list;

import 'package:flutter/material.dart';

final calculators = <CalculatorType>[
  // CalculatorType(0, 'Electricity swap', Colors.primaries[0]),
  CalculatorType(0, 'Electricity swap', Colors.orange[200]),
  CalculatorType(1, 'Electricity monthly option', Colors.indigo[200]),
  CalculatorType(2, 'Electricity daily option', Colors.indigo[300]),
  CalculatorType(3, 'Electricity heat-rate swap', Colors.pink[200]),
  CalculatorType(4, 'Electricity heat-rate option', Colors.pink[300]),
];

class CalculatorType {
  final int id;
  final String title;
  final Color color;
  bool selected = false;

  CalculatorType(this.id, this.title, this.color);
}

/// There are 18 primary colors, jump by 5, mod 18.
