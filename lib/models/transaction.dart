import 'package:flutter/material.dart';

class Transaction {
  // Data model to hold the data of each transaction
  final DateTime date;
  final DateTime? valueDate, fiscalDate;
  final String accountType, operationType, status;
  final String? instrumentCodeType, instrumentCode, instrumentName;
  final int operationCode;
  final double amount;
  final double? titles, price;
  final IconData icon;
  final Uri? downloadLink;

  Transaction(
      {required this.date,
      this.valueDate,
      this.fiscalDate,
      required this.accountType,
      required this.operationCode,
      required this.operationType,
      required this.icon,
      this.instrumentCodeType,
      this.instrumentCode,
      this.instrumentName,
      this.titles,
      this.price,
      required this.amount,
      required this.status,
      this.downloadLink});
}
