import 'package:flutter/material.dart';
import 'package:thghts_n_emotns_flutter_app/models/PostsData.dart';
import 'package:thghts_n_emotns_flutter_app/screens/LoginPage.dart';
import 'package:thghts_n_emotns_flutter_app/utils/adaptive_theme.dart';

class CustomCarousel extends StatefulWidget {
  List<PostData> _postList;

  CustomCarousel(this._postList);

  @override
  CustomCarouselState createState() => new CustomCarouselState();
}

class CustomCarouselState extends State<CustomCarousel> {
  PageController _pageController;
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: getTealGradient(),
      child: new Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget._postList.length,
              itemBuilder: (context, index) => animatedItemBuilder(index),
              controller: _pageController,
              onPageChanged: (value) {
                setState(() {
                  _currentPage = value;
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
        initialPage: _currentPage, keepPage: false, viewportFraction: 0.85);
  }

  animatedItemBuilder(int index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        double value = 1;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page - index;
          value = (1 - (value.abs() * 0.5)).clamp(0.0, 1.0);
        }
        return GestureDetector(
          onTap: () {},
          child: makePostsView(index, value),
        );
      },
    );
  }

  showPosts(PostData postList) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text(
                postList.tag,
                style: TextStyle(
                  fontSize: 30.00,
                  fontFamily: 'Alice',
                  decoration: TextDecoration.underline,
                  decorationStyle: TextDecorationStyle.wavy,
                ),
              ),
              SizedBox(
                height: 20.00,
              ),
              Text(
                postList.emotion,
                style: TextStyle(
                  fontSize: 25.00,
                  fontFamily: 'Alice',
                ),
              ),
              SizedBox(
                height: 20.00,
              ),
              Text(
                postList.post,
                overflow: TextOverflow.ellipsis,
                maxLines: 10,
                style: TextStyle(
                  fontSize: 20.00,
                  fontFamily: 'Alice',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget makePostsView(int index, double value) {
    return Center(
      child: SizedBox(
        height: Curves.ease.transform(value) * 500,
        width: Curves.ease.transform(value) * 450,
        child: Container(
          decoration: BoxDecoration(
            color: index % 2 == 0 ? Colors.deepPurpleAccent : Colors.green,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5.0,
                spreadRadius: 5.0,
                offset: Offset(
                  5.0, // horizontal, move right 10
                  15.0, // vertical, move down 10
                ),
              )
            ],
            borderRadius: BorderRadius.all(Radius.circular(10.00)),
          ),
          margin: EdgeInsets.all(10.00),
          child: showPosts(widget._postList[index]),
        ),
      ),
    );
  }

}
