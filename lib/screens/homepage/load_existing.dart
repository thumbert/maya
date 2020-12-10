library homepage.load_existing;

import 'package:flutter/material.dart';

class LoadExistingForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoadExistingFormState();
}

class _LoadExistingFormState extends State<LoadExistingForm> {
  _LoadExistingFormState();

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24.0),
            Text(
              'Load an existing calculator',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 24.0),
            Container(
                width: 200,
                child: TextField(
                  decoration:
                      InputDecoration(filled: true, labelText: 'Employee Id'),
                )),
            SizedBox(height: 24.0),
            RaisedButton(
              child: Text('Load'),
              onPressed: () {},
              color: Colors.blue,
              textColor: Colors.white,
            )
          ],
        ));
  }
}
