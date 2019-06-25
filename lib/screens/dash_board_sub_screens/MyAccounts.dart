import 'package:flutter/material.dart';
import 'package:thghts_n_emotns_flutter_app/scoped_models/AppScopedModel.dart';

class MyAccount extends StatefulWidget {
  @override
  MyAccountState createState() => new MyAccountState();
}

class MyAccountState extends State<MyAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.tealAccent,
          title: Text('My Account'),
        ),
        body: Text('My Account baby!'));
  }
}
