import 'dart:core';

import 'package:flutter/material.dart';

typedef void RouteCallback(BuildContext context);

class RouteItem {
  final String title;
  final String? subtitle;
  final RouteCallback? push;

  RouteItem({
    required this.title,
    this.subtitle,
    this.push,
  });
}
