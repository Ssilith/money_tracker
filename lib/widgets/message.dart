import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

message(BuildContext context, String title, String message, String type) {
  ContentType contentType = parseContentType(type);
  final snackBar = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: title,
      message: message,
      contentType: contentType,
    ),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

ContentType parseContentType(String type) {
  switch (type.toLowerCase()) {
    case 'success':
      return ContentType.success;
    case 'failure':
      return ContentType.failure;
    case 'help':
      return ContentType.help;
    case 'warning':
      return ContentType.warning;
    default:
      throw ArgumentError('Unknown ContentType: $type');
  }
}
