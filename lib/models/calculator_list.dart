library models.calculator_list;

import 'package:flutter/material.dart';

final calculators = <CalculatorType>[
  CalculatorType(0, 'Elec swap', Colors.indigo),
  CalculatorType(1, 'Elec monthly option', Colors.green),
  CalculatorType(2, 'Elec daily option', Colors.yellow),
  CalculatorType(3, 'Elec heat-rate swap', Colors.red),
  CalculatorType(4, 'Elec heat-rate option', Colors.teal),
];

class CalculatorType {
  final int id;
  final String title;
  final Color color;
  bool selected = false;

  CalculatorType(this.id, this.title, this.color);
}
