import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AnswerForm extends StatefulWidget {
  @override
  _AnswerFormState createState() => _AnswerFormState();
}

class _AnswerFormState extends State<AnswerForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter your answer.';
              }
            }
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 2.0),
            child: RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Checking answer')));
                }
              },
              child: Text('Submit'),
            )
          ),
        ]
      )
    );
  }


}