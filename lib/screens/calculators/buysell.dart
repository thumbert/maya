library screens.calculators.asofdate;

import 'package:elec/risk_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:provider/provider.dart';
import 'package:maya/models/buysell_model.dart';

typedef VoidCallBack = void Function();

class BuySellUi extends StatefulWidget {
  BuySellUi();
  @override
  State<StatefulWidget> createState() => _BuySellState();
}

class _BuySellState extends State<BuySellUi> {
  _BuySellState();

  final _buySellController = AdvancedSwitchController();

  @override
  void initState() {
    super.initState();
    final model = context.read<BuySellModel>();
    _buySellController.value = model.buySell == BuySell.buy ? true : false;
    _buySellController.addListener(() {
      setState(() {
        final buySell = _buySellController.value ? BuySell.buy : BuySell.sell;
        model.setAndNotify(buySell);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // note: don't set the enabled field, let the controller dictate the state
    return AdvancedSwitch(
      activeChild: Text('Buy'),
      inactiveChild: Text('Sell'),
      activeColor: Colors.green,
      inactiveColor: Colors.red,
      borderRadius: BorderRadius.circular(20),
      width: 100,
      height: 30,
      controller: _buySellController,
    );
  }
}
