library models.asofdate_model;

import 'package:date/date.dart';
import 'package:flutter/material.dart';

class AsOfDateModel extends ChangeNotifier {
  AsOfDateModel();

  Date _asOfDate;

  void init(Date date) => _asOfDate = date;

  set asOfDate(Date date) {
    _asOfDate = date;
    notifyListeners();
  }

  Date get asOfDate => _asOfDate ?? Date.today();
}
