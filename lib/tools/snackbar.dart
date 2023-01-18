import 'package:flutter/material.dart';

// Reusable class to show a snackbar with error messages across the app

void showInSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
  ));
}
