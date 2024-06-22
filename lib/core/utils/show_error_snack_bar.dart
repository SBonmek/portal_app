import 'package:flutter/material.dart';

showErrorSnackBar(BuildContext context, {required String errorText}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red,
      content: Text(errorText),
    ),
  );
}
