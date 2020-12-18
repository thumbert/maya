library screens.homepage.homepage;

import 'package:flutter/material.dart';
import 'package:maya/screens/homepage/calculator_list.dart';
import 'package:maya/screens/homepage/load_existing.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Welcome'),
          bottom: TabBar(
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.white,
            labelStyle: TextStyle(fontSize: 18.0),
            indicator: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
              color: Colors.white,
            ),
            isScrollable: false,
            tabs: [
              Tab(text: 'Create new'),
              Tab(text: 'Open existing'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [CalculatorList()]),
            Center(child: LoadExistingForm()),
          ],
        ),
      ),
    );
  }
}
