import 'package:flutter/material.dart';
import 'package:flutter_models/models/UserModel.dart';
import 'package:flutter_inputs/MainButton.dart';
import 'package:flutter_inputs/forms/inputs/TextInput.dart';
import 'package:forkdev/helpers/translate.dart';

class StatusWizard extends StatelessWidget {
  final UserModel userModel;
  final Function(String, String) onSave;

  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();

  StatusWizard({
    Key key,
    this.onSave,
    this.userModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _keyForm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: 20.0,
            ),
            child: Text(
              t(context, 'StatusWizard.title'),
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
            ),
            child: TextInput(
              controller: _usernameController,
              placeholder: t(context, 'StatusWizard.placeholder'),
              onChanged: (value) => print(value),
              validator: (value) =>
                  value.isEmpty ? t(context, 'StatusWizard.validator') : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
            ),
            child: SizedBox(
              width: double.infinity,
              child: MainButton(
                label: t(context, 'StatusWizard.button'),
                onPressed: () async {
                  if (_keyForm.currentState.validate()) {
                    onSave(UserModel.STATUS, _usernameController.text);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
