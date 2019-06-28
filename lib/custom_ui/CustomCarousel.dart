import 'package:flutter/material.dart';
import 'package:thghts_n_emotns_flutter_app/models/PostsData.dart';
import 'package:thghts_n_emotns_flutter_app/screens/DashBoard.dart';
import 'package:thghts_n_emotns_flutter_app/screens/LoginPage.dart';
import 'package:thghts_n_emotns_flutter_app/screens/Posts_Details.dart';
import 'package:thghts_n_emotns_flutter_app/utils/EnterExitRoute.dart';
import 'package:thghts_n_emotns_flutter_app/utils/adaptive_theme.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:thghts_n_emotns_flutter_app/utils/custom_route.dart';

class CustomCarousel extends StatefulWidget {
  final List<PostData> _postList;
  final Function toPostDetails;
  CustomCarousel(this._postList, this.toPostDetails);

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
          value = (1 - (value.abs() * 0.6)).clamp(0.0, 1.0);
        }
        return makePostsView(index, value);
      },
    );
  }

  showPosts(PostData postList) {

    int commentsCount = 0 ;
    if(postList.commentsMap != null && postList.commentsMap.keys.length > 1){
      commentsCount = postList.commentsMap.length - 1;
    }


    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.topRight,
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.all(5),
          child: Text(
            '$commentsCount Comments',
            style: TextStyle(
              color: Color(int.parse('0xFF' + postList.textColor)),
              fontSize: 10.00,
              fontFamily: 'Alice',
            ),
          ),
        ),
        Container(
          alignment: Alignment.topCenter,
          child: Text(postList.tag,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Color(int.parse('0xFF' + postList.textColor)),
                fontSize: 25.00,
                fontFamily: 'Alice',
              )),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(20.0),
            alignment: Alignment.topLeft,
            child: Text(
              postList.post,
              overflow: TextOverflow.ellipsis,
              maxLines: 11,
              style: TextStyle(
                color: Color(int.parse('0xFF' + postList.textColor)),
                fontSize: 20.00,
                fontFamily: 'Alice',
              ),
            ),
          ),
        ),
        Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Swipe Up to Read more',
              style: TextStyle(
                fontSize: 12.0,
                color: Color(int.parse('0xFF' + postList.textColor)),
              ),
            ))
      ],
    );
  }

  Widget makePostsView(int index, double value) {
    DragStartDetails startVerticalDragDetails;

    DragUpdateDetails updateVerticalDragDetails;

    return GestureDetector(
      onVerticalDragStart: (dragDetails) {
        startVerticalDragDetails = dragDetails;
      },
      onVerticalDragUpdate: (dragDetails) {
        updateVerticalDragDetails = dragDetails;
      },
      onVerticalDragEnd: (endDetails) {
        double dx = updateVerticalDragDetails.globalPosition.dx -
            startVerticalDragDetails.globalPosition.dx;
        double dy = updateVerticalDragDetails.globalPosition.dy -
            startVerticalDragDetails.globalPosition.dy;
        double velocity = endDetails.primaryVelocity;

        //Convert values to be positive
        if (dx < 0) dx = -dx;
        if (dy < 0) dy = -dy;

        if (velocity < 0) {
          print('Swipe Up');
          widget.toPostDetails(widget._postList[index]);
        } else {
          print('Swipe down');
        }
      },
      child: Center(
        child: SizedBox(
          height: Curves.ease.transform(value) * 400,
          width: Curves.ease.transform(value) * 450,
          child: Container(
            decoration: BoxDecoration(
              color: Color(
                  int.parse('0x80' + widget._postList[index].emotionColor)),
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
      ),
    );
  }
}
