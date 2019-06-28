import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:thghts_n_emotns_flutter_app/mixins/AllScopedModels.dart';
import 'package:thghts_n_emotns_flutter_app/models/Comments.dart';
import 'package:thghts_n_emotns_flutter_app/models/LogedInUserDetails.dart';
import 'package:thghts_n_emotns_flutter_app/models/PostsData.dart';
import 'package:thghts_n_emotns_flutter_app/utils/adapative_progress_indicator.dart';
import 'package:thghts_n_emotns_flutter_app/utils/adaptive_theme.dart';

class PostsDetails extends StatefulWidget {
  final PostData postList;
  final AllScopedModel model;

  PostsDetails(this.postList, this.model);

  @override
  PostsDetailsState createState() => new PostsDetailsState();
}

class PostsDetailsState extends State<PostsDetails> {
  ScrollController _controller;
  bool showCommentsFAB = true;
  var commentsController = new TextEditingController();
  bool _validateComments = true;
  LoggedInUserDetails _user;
  List<String> listViewData = [];

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AllScopedModel>(
      builder: (BuildContext context, Widget child, AllScopedModel model) {
        return Container(
          decoration: getTealGradient(),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.tealAccent,
              title: Text(widget.postList.tag),
            ),
            body: ModalProgressHUD(
              progressIndicator: AdaptiveProgressIndicator(),
              inAsyncCall: model.isLoading,
              child: makeUI(model),
            ),
            floatingActionButton: AnimatedOpacity(
              child: FloatingActionButton(
                mini: true,
                onPressed: () {
                  showAddCommentsModalSheet(model, context);
                },
                child: Icon(Icons.add_comment), //Change Icon
              ),
              duration: Duration(milliseconds: 200),
              opacity: showCommentsFAB ? 1 : 0,
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation
                .endFloat, //Change for different locations
          ),
        );
      },
    );
  }

  Widget makeUI(AllScopedModel model) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollStartNotification) {
          _onStartScroll(scrollNotification.metrics);
        } else if (scrollNotification is ScrollUpdateNotification) {
          _onUpdateScroll(scrollNotification.metrics);
        } else if (scrollNotification is ScrollEndNotification) {
          _onEndScroll(scrollNotification.metrics);
        }
      },
      child: ListView.builder(
        itemCount: listViewData.length,
        itemBuilder: (BuildContext context, int index) {
          return makeListItem(context, model, index);
        },
      ),
    );
  }

  @override
  void initState() {
    listViewData.add(widget.postList.post);
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    widget.model.getLoggedInUser().then((LoggedInUserDetails user) {
      _user = user;
    });
    getComments();
    super.initState();
  }

  _scrollListener() {
    //Bottom
    /*if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      if(showCommentsFAB){
        setState(() {
          showCommentsFAB = !showCommentsFAB;
        });
      }
    }*/
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        showCommentsFAB = true;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didUpdateWidget(PostsDetails oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  _onStartScroll(ScrollMetrics metrics) {
    setState(() {
      showCommentsFAB = false;
    });
  }

  _onUpdateScroll(ScrollMetrics metrics) {
    setState(() {
      showCommentsFAB = false;
    });
  }

  _onEndScroll(ScrollMetrics metrics) {
    setState(() {
      showCommentsFAB = true;
    });
  }

  showPosts(String postList) {
    return SingleChildScrollView(
      child: Container(
        child: Text(
          postList,
          style: TextStyle(
            color: Color(int.parse('0xFF' + widget.postList.textColor)),
            fontSize: 20.00,
            fontFamily: 'Alice',
          ),
        ),
      ),
    );
  }

  void showAddCommentsModalSheet(AllScopedModel model, BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
              padding: EdgeInsets.all(10.0),
              decoration: getTealGradient(),
              child: Column(
                children: <Widget>[
                  Container(
                      alignment: Alignment.topRight,
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(5),
                      child: FlatButton(
                        child: Text('Done'),
                        onPressed: () {
                          Navigator.pop(context);

                          if (!commentsController.text.isEmpty) {
                            model
                                .sendComments(
                                    widget.postList.id,
                                    commentsController.text,
                                    _user.userId,
                                    _user.userEmail)
                                .then((String value) {
                                  commentsController.clear();
                              if (value.length > 0) {
                                getComments();
                              }
                            });
                          }
                        },
                      )),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(8.0)),
                        gradient: new LinearGradient(
                          colors: [
                            Color(0xAF039BE5),
                            Color(0xBD81D4FA),
                          ],
                          begin: FractionalOffset.bottomLeft,
                          end: FractionalOffset.topRight,
                        ),
                      ),
                      child: TextField(
                        maxLines: 100,
                        controller: commentsController,
                        autofocus: false,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: Colors.transparent,
                            labelText: 'Write what you about this post',
                            errorText: !_validateComments
                                ? 'Value Can\'t Be Empty'
                                : null,
                            labelStyle: TextStyle(color: Colors.black),
                            filled: true),
                      ),
                    ),
                  )
                ],
              ));
        });
  }

  void getComments() {
    widget.model
        .getComments(widget.postList.id)
        .then((List<Comments> commentsList) {
      if (commentsList != null) {
        setState(() {
          for (int i = 0; i < commentsList.length; i++) {
            if (!listViewData.contains(commentsList[i].comment)) {
              listViewData.add(commentsList[i].comment);
            }
          }
        });
      }
    });
  }

  Widget makeListItem(BuildContext context, AllScopedModel model, int index) {
    return Padding(
      padding: index == 0
          ? EdgeInsets.all(8.0)
          : EdgeInsets.only(left: 30.0, right: 5.0, top: 5.0, bottom: 5.0),
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        semanticContainer: true,
        color: index == 0
            ? Color(int.parse('0x59' + widget.postList.emotionColor))
            : Color(
                int.parse('0x59827717'),
              ),
        elevation: index == 0 ? 10.0 : 2.0,
        child: Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.all(20.0),
          child: showPosts(listViewData[index]),
        ),
      ),
    );
  }
}
