import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FinishWizard extends StatelessWidget {
  const FinishWizard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: 20.0,
          ),
          child: Text(
            "We finish setting up your account",
            style: Theme.of(context).textTheme.headline2,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
