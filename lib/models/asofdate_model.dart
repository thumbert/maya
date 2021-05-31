library models.asofdate_model;

import 'package:date/date.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart';

class AsOfDateModel extends ChangeNotifier {
  AsOfDateModel();

  Date _asOfDate = Date.today(location: UTC);

  void init(Date date) => _asOfDate = date;

  set asOfDate(Date date) {
    _asOfDate = date;
    notifyListeners();
  }

  Date get asOfDate => _asOfDate;
}
