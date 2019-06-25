import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:thghts_n_emotns_flutter_app/models/Emotion.dart';
import 'package:thghts_n_emotns_flutter_app/models/LogedInUserDetails.dart';
import 'package:thghts_n_emotns_flutter_app/scoped_models/AppScopedModel.dart';
import 'package:thghts_n_emotns_flutter_app/utils/adapative_progress_indicator.dart';

class AddNewPost extends StatefulWidget {
  @override
  AddNewPostState createState() => new AddNewPostState();
}

class AddNewPostState extends State<AddNewPost> {
  var tagsTextEditingController = new TextEditingController();
  var emotionsTextEditingController = new TextEditingController();
  var postsTextEditingController = new TextEditingController();
  bool _validateTags = true;
  bool _validateEmotions = true;
  bool _validatePost = true;

  var size;

  /*24 is for notification bar on Android*/
  var itemHeight;
  var itemWidth;

  String emotionColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  void dispose() {
    tagsTextEditingController.dispose();
    emotionsTextEditingController.dispose();
    postsTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    itemHeight = (size.height - kToolbarHeight - 24) / 8;
    itemWidth = size.width / 2;
    return ScopedModelDescendant<AppScopedModel>(
      builder: (BuildContext context, Widget child, AppScopedModel model) {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.tealAccent,
              title: Text('Add New Post'),
            ),
            body: ModalProgressHUD(
              progressIndicator: AdaptiveProgressIndicator(),
              inAsyncCall: model.isLoading,
              child: buildUi(model),
            ));
      },
    );
  }

  Widget buildTagsWidget(BuildContext context, AppScopedModel model) {
    return Container(
      decoration: containerDecoration(),
      child: TextField(
          cursorWidth: 0.00,
          autofocus: false,
          controller: tagsTextEditingController,
          onTap: () {
            model.getTags().then((List<String> tags) {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      decoration: tealGradient(),
                      child: GridView.count(
                        crossAxisCount: 3,
                        childAspectRatio: (itemWidth / itemHeight),
                        // Generate 100 widgets that display their index in the List.
                        children: makeTagsList(tags, context),
                      ),
                    );
                  });
            });
          },
          decoration: plainTextFieldDecoration(
              'Choose a Tag for your Post.', _validateTags)),
    );
  }

  Widget buildEmotionsWidget(BuildContext context, AppScopedModel model) {
    return Container(
      decoration: containerDecoration(),
      child: TextField(
        cursorWidth: 0.00,
        autofocus: false,
        controller: emotionsTextEditingController,
        onTap: () {
          model.getEmotions().then((List<Emotions> tags) {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    decoration: tealGradient(),
                    child: GridView.count(
                      crossAxisCount: 3,
                      // Generate 100 widgets that display their index in the List.
                      children: makeEmotionsList(tags, context),
                    ),
                  );
                });
          });
        },
        decoration: plainTextFieldDecoration(
            'Choose an Emotion too.', _validateEmotions),
      ),
    );
  }

  List<Container> makeTagsList(List<String> tags, BuildContext context) {
    List<Container> myWidgets = [];
    if (tags != null) {
      myWidgets = tags.map((item) {
        return new Container(
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.00)),
            gradient: new LinearGradient(
              colors: [
                Colors.blueAccent,
                Colors.deepPurpleAccent,
              ],
              begin: FractionalOffset.bottomLeft,
              end: FractionalOffset.topRight,
            ),
          ),
          margin: EdgeInsets.all(3.00),
          child: FlatButton(
            child: Text(item),
            onPressed: () {
              print(item);
              tagsTextEditingController.text = item;
              Navigator.pop(context);
            },
          ),
        );
      }).toList();
    }
    return myWidgets;
  }

  List<Container> makeEmotionsList(
      List<Emotions> emotions, BuildContext context) {
    List<Container> myWidgets = [];
    if (emotions != null) {
      myWidgets = emotions.map((item) {
        return new Container(
          margin: EdgeInsets.all(5.00),
          child: RaisedButton(
            child: Text(
              item.englishName + '\n\n(' + item.hindiName + ')',
              style: TextStyle(
                  color: Color(int.parse('0xFF' + item.textColor)),
                  fontStyle: FontStyle.normal,
                  fontSize: 16.00),
            ),
            color: Color(int.parse('0xFF' + item.colorHex)),
            onPressed: () {
              print(item.englishName);
              emotionsTextEditingController.text = item.englishName;
              emotionColor = item.colorHex;
              Navigator.pop(context);
            },
            elevation: 5.00,
          ),
        );
      }).toList();
    }
    return myWidgets;
  }

  Widget buildPostsWidget(BuildContext context, AppScopedModel model) {
    return Expanded(
      child: Container(
        decoration: containerDecoration(),
        child: TextField(
          maxLines: 100,
          cursorWidth: 0.00,
          controller: postsTextEditingController,
          autofocus: false,
          decoration: plainTextFieldDecoration(
              "Pour your Heart out. We are Listening.", _validatePost),
        ),
      ),
    );
  }

  plainTextFieldDecoration(String labelText, bool validate) {
    return InputDecoration(
        border: InputBorder.none,
        fillColor: Colors.transparent,
        labelText: labelText,
        errorText: !validate ? 'Value Can\'t Be Empty' : null,
        labelStyle: TextStyle(color: Colors.black),
        filled: true);
  }

  containerDecoration() {
    return new BoxDecoration(
      borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
      gradient: new LinearGradient(
        colors: [
          Color(0xAF039BE5),
          Color(0xBD81D4FA),
        ],
        begin: FractionalOffset.bottomLeft,
        end: FractionalOffset.topRight,
      ),
    );
  }

  tealGradient() {
    return BoxDecoration(
        gradient: new LinearGradient(
      colors: [
        Colors.teal,
        Colors.tealAccent,
      ],
      begin: FractionalOffset.bottomLeft,
      end: FractionalOffset.topRight,
    ));
  }

  buildUi(AppScopedModel model) {
    return Container(
      padding: EdgeInsets.all(10.00),
      decoration: BoxDecoration(
          gradient: new LinearGradient(
            colors: [
              Colors.teal,
              Colors.tealAccent,
            ],
            begin: FractionalOffset.bottomLeft,
            end: FractionalOffset.topRight,
          )),
      child: Column(
        children: <Widget>[
          buildTagsWidget(context, model),
          SizedBox(
            height: 20.00,
          ),
          buildEmotionsWidget(context, model),
          SizedBox(
            height: 20.00,
          ),
          buildPostsWidget(context, model),
          SizedBox(
            height: 20.00,
          ),
          RaisedButton(
              child: Text('Save Post'),
              onPressed: () {
                bool moveForward = false;
                setState(() {
                  if (tagsTextEditingController.text.isEmpty) {
                    _validateTags = false;
                    moveForward = false;
                  } else {
                    _validateTags = true;
                    moveForward = true;
                  }
                  if (emotionsTextEditingController.text.isEmpty) {
                    _validateEmotions = false;
                    moveForward = false;
                  } else {
                    _validateEmotions = true;
                    moveForward = true;
                  }
                  if (postsTextEditingController.text.isEmpty) {
                    _validatePost = false;
                    moveForward = false;
                  } else {
                    _validatePost = true;
                    moveForward = true;
                  }
                });

                if (moveForward) {
                  model
                      .getLoggedInUser()
                      .then((LoggedInUserDetails user) {
                    model
                        .sendPost(
                        user.userEmail,
                        user.userId,
                        tagsTextEditingController.text,
                        emotionsTextEditingController.text,
                        emotionColor,
                        postsTextEditingController.text)
                        .then((bool value) {
                      if (value) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Post added Successfully.'),
                                content:
                                Text('Please go to Thought Train'),
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text('Okay'),
                                  )
                                ],
                              );
                            });
                      }
                    });
                  });
                }
              }),
        ],
      ),
    );
  }
}
