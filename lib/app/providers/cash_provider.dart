import 'package:flutter/material.dart';

import '../models/cash.dart';

class CashProvider extends ChangeNotifier {
  List<Cash> cashes = [
    Cash(
        id: '1',
        name: 'الاسم',
        cashNumber: '123',
        price: '3655.255',
        date: '25-07-2024'),
    Cash(
        id: '2',
        name: 'الاسم',
        cashNumber: '123',
        price: '3655.255',
        date: '25-07-2024'),
    Cash(
        id: '3',
        name: 'الاسم',
        cashNumber: '123',
        price: '3655.255',
        date: '25-07-2024'),
    Cash(
        id: '4',
        name: 'الاسم',
        cashNumber: '123',
        price: '3655.255',
        date: '25-07-2024'),
    Cash(
        id: '5',
        name: 'الاسم',
        cashNumber: '123',
        price: '3655.255',
        date: '25-07-2024'),
    Cash(
        id: '6',
        name: 'الاسم',
        cashNumber: '123',
        price: '3655.255',
        date: '25-07-2024'),
    Cash(
        id: '7',
        name: 'الاسم',
        cashNumber: '123',
        price: '3655.255',
        date: '25-07-2024'),
    Cash(
        id: '8',
        name: 'الاسم',
        cashNumber: '123',
        price: '3655.255',
        date: '25-07-2024'),
    Cash(
        id: '9',
        name: 'الاسم',
        cashNumber: '123',
        price: '3655.255',
        date: '25-07-2024'),
    Cash(
        id: '10',
        name: 'الاسم',
        cashNumber: '123',
        price: '3655.255',
        date: '25-07-2024'),
  ];

  void addCash(Cash cash) {
    print("=================================");
    print(cash.id);
    print(cash.name);
    print(cash.price);
    print("=================================");
    cashes.add(cash);
    notifyListeners();
  }

  void updateCash({required Cash cash}) {
    cashes[cashes.indexWhere((oldCash) => oldCash.id == cash.id)] = cash;
    notifyListeners();
  }

  void deleteCash(Cash cash) {
    cashes.remove(cash);
    notifyListeners();
  }
}
