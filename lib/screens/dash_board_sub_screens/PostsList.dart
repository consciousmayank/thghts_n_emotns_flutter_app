import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:thghts_n_emotns_flutter_app/custom_ui/CustomCarousel.dart';
import 'package:thghts_n_emotns_flutter_app/models/PostsData.dart';
import 'package:thghts_n_emotns_flutter_app/scoped_models/AppScopedModel.dart';
import 'package:thghts_n_emotns_flutter_app/utils/adapative_progress_indicator.dart';
import 'package:thghts_n_emotns_flutter_app/utils/adaptive_theme.dart';

class PostsList extends StatefulWidget {
  final AppScopedModel model;

  PostsList(this.model);

  @override
  PostsListState createState() => new PostsListState();
}

class PostsListState extends State<PostsList> {
  List<PostData> postList;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppScopedModel>(
      builder: (BuildContext context, Widget child, AppScopedModel model) {
        return Container(
          decoration: getTealGradient(),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.tealAccent,
              title: Text('Thoughts Train'),
            ),
            body: Center(
              child: Container(
                child: postList == null
                    ? AdaptiveProgressIndicator()
                    : loadList(postList),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.model != null) {
      widget.model.getPosts().then((List<PostData> list) {
        setState(() {
          postList = list;
        });
      });
    }
  }

  loadList(List<PostData> postList) {
    return CustomCarousel(List.of(postList.reversed));
  }
}
