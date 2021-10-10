import 'package:flutter/material.dart';

class Transaction {
  final DateTime date;
  final DateTime valueDate;
  final DateTime fiscalDate;
  final String accountType;
  final int operationCode;
  final String operationType;
  final IconData icon;
  final String instrumentCode;
  final String instrumentName;
  final double titles;
  final double price;
  final double amount;
  final String status;

  Transaction({this.date, this.valueDate, this.fiscalDate, this.accountType, this.operationCode, this.operationType, this.icon, this.instrumentCode, this.instrumentName, this.titles, this.price, this.amount, this.status});
}