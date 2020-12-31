import 'package:flutter/material.dart';
import 'package:forkdev/helpers/translate.dart';

class NoFound extends StatelessWidget {
  final String label;

  const NoFound({
    Key key,
    @required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(t(context, label)),
      ),
    );
  }
}
