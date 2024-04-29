/*
 * @author Stephanos B
 */

import 'package:flutter/material.dart';
import 'package:flutter_application_1/detailsPage.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              print("\t# To Latest"); //debug
              toLatest(context);
            },
            child: const Text('To Latest'),
          ),
          const Text("text")
        ],
      ),
    );
  } // build

  toLatest(context) {
    print("\t# to Latest"); // debug
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => DetailsPage()));
  } //toLatest()

  toLatestHour(context) {
    print("\t# to Latest Hour"); // debug
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => DetailsPage()));
  } //toLatestHour()
} // MyHomePage
