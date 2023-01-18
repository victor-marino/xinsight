import 'package:flutter/material.dart';

class Transaction {
  // Data model to hold the data of each transaction
  final DateTime date;
  final DateTime? valueDate;
  final DateTime? fiscalDate;
  final String accountType;
  final int operationCode;
  final String operationType;
  final IconData icon;
  final String? instrumentCodeType;
  final String? instrumentCode;
  final String? instrumentName;
  final double? titles;
  final double? price;
  final double amount;
  final String status;

  Transaction({required this.date, this.valueDate, this.fiscalDate, required this.accountType, required this.operationCode, required this.operationType, required this.icon, this.instrumentCodeType, this.instrumentCode, this.instrumentName, this.titles, this.price, required this.amount, required this.status});

  @override
  String toString() {
    // Override toString() method for easier priting and troubleshooting
    return date.toString() + ", " + valueDate.toString() + ", " + fiscalDate.toString() + ", " + accountType.toString() + ", " + operationCode.toString() + ", " + operationType.toString() + ", " + icon.toString() + ", " + instrumentCodeType.toString() + ", " + instrumentCode.toString() + ", " + instrumentName.toString() + ", " + titles.toString() + ", " + price.toString() + ", " + amount.toString() + ", " + status.toString();
  }
}