import 'package:flutter/material.dart';

void navigate(BuildContext context, Widget screen) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
}
