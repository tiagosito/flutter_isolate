import 'dart:isolate';

import 'package:flutter/material.dart';

class IsolateObject<T> {
  final T value;
  final SendPort sender;

  IsolateObject({
    this.value,
    @required this.sender,
  });
}
