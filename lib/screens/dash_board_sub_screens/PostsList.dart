import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:thghts_n_emotns_flutter_app/custom_ui/CustomCarousel.dart';
import 'package:thghts_n_emotns_flutter_app/mixins/AllScopedModels.dart';
import 'package:thghts_n_emotns_flutter_app/models/PostsData.dart';
import 'package:thghts_n_emotns_flutter_app/scoped_models/AppScopedModel.dart';
import 'package:thghts_n_emotns_flutter_app/utils/adapative_progress_indicator.dart';
import 'package:thghts_n_emotns_flutter_app/utils/adaptive_theme.dart';
import 'package:thghts_n_emotns_flutter_app/utils/custom_route.dart';

import '../Posts_Details.dart';

class PostsList extends StatefulWidget {
  final AllScopedModel model;

  PostsList(this.model);

  @override
  PostsListState createState() => new PostsListState();
}

class PostsListState extends State<PostsList> {
  List<PostData> postList;

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
              title: Text('Thoughts Train'),
            ),
            body: Center(
              child: Container(
                child: postList == null
                    ? AdaptiveProgressIndicator()
                    : loadList(postList, context),
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

  Widget loadList(List<PostData> postList, BuildContext context) {
    return CustomCarousel(List.of(postList.reversed), toPostDetails);
  }

  void toPostDetails(PostData postList){
    Navigator.push(
      context,
      CustomRoute(
          builder: (context) => PostsDetails(postList, widget.model)),
    );
  }

}
