import 'package:flutter/material.dart';
import 'package:forkdev/services/AppLocalizationsService.dart';

String t(BuildContext context, String key) =>
    AppLocalizationsService.of(context).translate(key);
