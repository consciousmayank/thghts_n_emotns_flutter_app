import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:thghts_n_emotns_flutter_app/scoped_models/AppScopedModel.dart';
import 'package:thghts_n_emotns_flutter_app/utils/adapative_progress_indicator.dart';
import 'package:thghts_n_emotns_flutter_app/utils/adaptive_theme.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'DashBoard.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
  };


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery
        .of(context)
        .size
        .width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;

    return ScopedModelDescendant<AppScopedModel>(
      builder: (BuildContext context, Widget child, AppScopedModel model) {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.tealAccent,
              title: Text('Login'),
            ),
            body:

            ModalProgressHUD(
              progressIndicator: AdaptiveProgressIndicator(),
              inAsyncCall: model.isLoading,
              child: buildBody(model),
            )


        );
      },
    );
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'E-Mail', filled: true, fillColor: Colors.white),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(
                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'Please enter a valid email';
        }
      },
      onSaved: (String value) {
        _formData['email'] = value;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Password', filled: true, fillColor: Colors.white),
      obscureText: true,
      controller: _passwordTextController,
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return 'Password invalid';
        }
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  _submitForm(AppScopedModel model) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    print(_formData['email']);
    print(_formData['password']);

    model
        .tryLogin(
        _formData['email'].toString(), _formData['password'].toString())
        .then((bool isSuccess) {
      if (isSuccess) {
        print('got ' + isSuccess.toString());
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return DashBoard();
            },
          ),
        );
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Login Failed !'),
                content: Text('UserName or password are incorrect.'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Retry'),
                  )
                ],
              );
            });
      }
    });
  }

  Widget buildBody(AppScopedModel model) {
    return Container(
      decoration: getTealGradient(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            decoration: getBlueGradient(),
            child: Card(
              color: Colors.lightBlue,
              elevation: 10.00,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Container(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          _buildEmailTextField(),
                          SizedBox(
                            height: 10.0,
                          ),
                          _buildPasswordTextField(),
                          SizedBox(
                            height: 10.0,
                          ),
                          RaisedButton(
                            textColor: Colors.white,
                            child: Text('LOGIN'),
                            onPressed: () => _submitForm(model),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
