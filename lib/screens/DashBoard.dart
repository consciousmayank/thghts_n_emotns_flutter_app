import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:thghts_n_emotns_flutter_app/mixins/AllScopedModels.dart';
import 'package:thghts_n_emotns_flutter_app/scoped_models/AppScopedModel.dart';

import 'dash_board_sub_screens/AddNewPost.dart';
import 'dash_board_sub_screens/MyAccounts.dart';
import 'dash_board_sub_screens/PostsList.dart';

class DashBoard extends StatefulWidget {

  AppScopedModel scopedModel;

  DashBoard(this.scopedModel);

  @override
  DashBoardState createState() => new DashBoardState();
}

class DashBoardState extends State<DashBoard> {
  int _selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AllScopedModel>(
      builder: (BuildContext context, Widget child, AllScopedModel model) {
        widget.scopedModel = model;
        return WillPopScope(
          onWillPop: _onBackPressed,
          child: Scaffold(
              body: getProperPage(_selectedIndex, model),
              bottomNavigationBar: BottomNavigationBar(
                  backgroundColor: Colors.tealAccent[700],
                  currentIndex: _selectedIndex,
                  selectedItemColor: Colors.black,
                  onTap: onItemTapped,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                        icon: Icon(Icons.train), title: Text('Thoughts Train')),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.add), title: Text('Add Thought')),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.account_circle),
                        title: Text('My Account'))
                  ])),
        );
      },
    );
  }

  Widget getProperPage(int selectedIndex, AllScopedModel model) {

    switch (selectedIndex) {
      case 0:
        return PostsList(model);
        break;

      case 1:
        return AddNewPost(onItemTapped);
        break;

      case 2:
        return MyAccount();
        break;

      default:
        return PostsList(model);
    }
  }

  Future<bool> _onBackPressed() {
    if(_selectedIndex == 0){
      return Future.value(true);
    }else{
      setState(() {
        _selectedIndex = 0;
      });
      return Future.value(false);
    }

  }
}
