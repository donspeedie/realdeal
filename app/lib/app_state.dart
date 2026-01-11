import 'package:flutter/material.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  bool _showFullListFNF = true;
  bool get showFullListFNF => _showFullListFNF;
  set showFullListFNF(bool value) {
    _showFullListFNF = value;
  }

  bool _export = true;
  bool get export => _export;
  set export(bool value) {
    _export = value;
  }

  String _customerEmail = '';
  String get customerEmail => _customerEmail;
  set customerEmail(String value) {
    _customerEmail = value;
  }

  String _stripeCustomerId = '';
  String get stripeCustomerId => _stripeCustomerId;
  set stripeCustomerId(String value) {
    _stripeCustomerId = value;
  }

  dynamic _selectedProduct;
  dynamic get selectedProduct => _selectedProduct;
  set selectedProduct(dynamic value) {
    _selectedProduct = value;
  }
}
