library error404;

import 'package:flutter/material.dart';

class Error404 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Oops!')),
      body: Column(children: [
        const SizedBox(height: 128),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 400,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Maya',
                      style: TextStyle(
                          // color: Colors.black,
                          fontFamily: 'Tangerine',
                          fontSize: 72,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 48),
                    Text('Here\'s the excuse: ',
                        style: TextStyle(fontSize: 20)),
                    const SizedBox(height: 24),
                    Text('The link you clicked has not been implemented yet',
                        style: TextStyle(fontSize: 20, color: Colors.brown)),
                  ]),
            ),
            const SizedBox(width: 20),
            Image(image: AssetImage('images/robot.png')),
          ],
        ),
      ]),
    );
  }
}
