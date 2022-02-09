import 'package:flutter/material.dart';

void disposeKeyboard() {
  return FocusManager.instance.primaryFocus?.unfocus();
}
