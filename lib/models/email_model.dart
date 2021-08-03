import 'package:flutter/material.dart';

class EmailModel with ChangeNotifier {
  final String email;
  final String msg;
  final String subject;

  EmailModel({
    @required this.email,
    @required this.msg,
    @required this.subject,
  });
}
