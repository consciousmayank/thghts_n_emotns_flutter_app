import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:thghts_n_emotns_flutter_app/scoped_models/AppScopedModel.dart';

import 'dash_board_sub_screens/AddNewPost.dart';
import 'dash_board_sub_screens/MyAccounts.dart';
import 'dash_board_sub_screens/PostsList.dart';

class DashBoard extends StatefulWidget {
  @override
  DashBoardState createState() => new DashBoardState();
}

class DashBoardState extends State<DashBoard> {
  int _selectedIndex = 0;
  static AppScopedModel scopedModel;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppScopedModel>(
      builder: (BuildContext context, Widget child, AppScopedModel model) {
        scopedModel = model;
        return Scaffold(
            body: getProperPage(_selectedIndex, model),
            bottomNavigationBar: BottomNavigationBar(
                backgroundColor: Colors.tealAccent[700],
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.black,
                onTap: _onItemTapped,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Icon(Icons.train), title: Text('Thoughts Train')),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.add), title: Text('Add Thought')),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.account_circle),
                      title: Text('My Account'))
                ]));
      },
    );
  }

  Widget getProperPage(int selectedIndex, AppScopedModel model) {
    switch (selectedIndex) {
      case 0:
        return PostsList(model);
        break;

      case 1:
        return AddNewPost();
        break;

      case 2:
        return MyAccount();
        break;

      default:
        return PostsList(model);
    }
  }
}
