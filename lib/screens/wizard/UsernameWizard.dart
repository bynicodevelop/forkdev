import 'package:flutter/material.dart';
import 'package:flutter_models/models/UserModel.dart';
import 'package:flutter_inputs/MainButton.dart';
import 'package:flutter_inputs/forms/inputs/TextInput.dart';

class UsernameWizard extends StatelessWidget {
  final UserModel userModel;
  final Function(String, String) onSave;

  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();

  UsernameWizard({
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
              "Let's start by choosing your username",
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
            ),
            child: TextInput(
              controller: _usernameController,
              placeholder: 'Enter your username',
              onChanged: (value) => print(value),
              validator: (value) =>
                  value.isEmpty ? 'Please enter your username' : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
            ),
            child: SizedBox(
              width: double.infinity,
              child: MainButton(
                label: 'Save',
                onPressed: () async {
                  if (_keyForm.currentState.validate()) {
                    onSave(UserModel.USERNAME, _usernameController.text);
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
