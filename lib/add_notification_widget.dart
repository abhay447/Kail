
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddKailActivity extends StatelessWidget{
  final Key _formKey = UniqueKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            title: Text('Add new acitvity'),
      ),
      body : Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Name',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Hour',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Minutes',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                onPressed: () {
                  // Validate will return true if the form is valid, or false if
                  // the form is invalid.
                  // if (_formKey.currentState.validate()) {
                  //   // Process data.
                  // }
                },
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      )
    );

  }
}
