// Flutter code sample for material.BottomNavigationBar.1

// This example shows a [BottomNavigationBar] as it is used within a [Scaffold]
// widget. The [BottomNavigationBar] has three [BottomNavigationBarItem]
// widgets and the [currentIndex] is set to index 0. The selected item is
// amber. The `_onItemTapped` function changes the selected item's index
// and displays a corresponding message in the center of the [Scaffold].
//
// ![A scaffold with a bottom navigation bar containing three bottom navigation
// bar items. The first one is selected.](https://flutter.github.io/assets-for-api-docs/assets/material/bottom_navigation_bar.png)

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:thghts_n_emotns_flutter_app/scoped_models/AppScopedModel.dart';
import 'package:thghts_n_emotns_flutter_app/screens/DashBoard.dart';
import 'package:thghts_n_emotns_flutter_app/screens/LoginPage.dart';
import 'package:thghts_n_emotns_flutter_app/utils/adaptive_theme.dart';

import 'mixins/AllScopedModels.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  AllScopedModel _model = AllScopedModel();
  bool _isUserLoggedIn = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModel<AllScopedModel>(
      child: MaterialApp(
        title: 'Thoughts And Emotions',
        theme: getAdaptiveThemeData(context),
        routes: {
          '/': (BuildContext context) {
            _model.isUserLoggedIn().then((bool value) {
              _isUserLoggedIn = value;
              print("Value is $value");
            });

            if (_isUserLoggedIn) {
              return DashBoard(_model);
            } else {
              return LoginPage(_model);
            }
          },
        },
      ),
      model: _model,
    );
  }
}
