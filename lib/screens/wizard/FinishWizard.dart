import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:forkdev/helpers/translate.dart';

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
            t(context, 'FinishWizard.title'),
            style: Theme.of(context).textTheme.headline2,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
