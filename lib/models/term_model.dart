library models.term_model;

import 'package:date/date.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart';

class TermModel extends ChangeNotifier {
  TermModel();

  Term _term = _defaultTerm();

  /// Set the _term without triggering a notification.
  /// Useful to set the term to the calculator term.
  void init(Term term) => _term = term;

  /// Return first Jan-Feb or first Jul-Aug from today.
  static Term _defaultTerm() {
    var today = Date.today(location: UTC);
    if (today.month >= 7) {
      var start = Date.utc(today.year + 1, 1, 1);
      var end = Date.utc(today.year + 1, 3, 1).previous;
      return Term(start, end);
    } else {
      var start = Date.utc(today.year, 7, 1);
      var end = Date.utc(today.year, 8, 31);
      return Term(start, end);
    }
  }

  set term(Term term) {
    _term = term;
    // propagate the changes from the UI
    notifyListeners();
  }

  Term get term => _term;
}
